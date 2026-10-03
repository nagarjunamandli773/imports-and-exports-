Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Let's inspect each pixel in the quote region: x: 878 to 995, y: 15 to 115
# We want to identify text/swoosh and inpaint it.
# First, let's create a mask of text/swoosh pixels.
$mask = New-Object 'bool[,]' $bmp.Width, $bmp.Height

for ($x = 875; $x -le 995; $x++) {
    for ($y = 15; $y -le 114; $y++) {
        $c = $bmp.GetPixel($x, $y)
        
        # White text & antialiasing
        $isWhiteText = ($c.R -gt 60 -and $c.G -gt 60 -and $c.B -gt 70) -or `
                       ($c.R -gt 90 -and $c.G -gt 90)
        
        # Gold swoosh & antialiasing
        $isGoldSwoosh = ($c.R -gt 70 -and $c.G -gt 55 -and $c.B -lt ($c.R - 10)) -and ($c.R -gt 85)
        
        if ($isWhiteText -or $isGoldSwoosh) {
            $mask[$x, $y] = $true
        }
    }
}

# Expand the mask by 2px (dilation) to catch any antialiasing halos
$dilatedMask = New-Object 'bool[,]' $bmp.Width, $bmp.Height
for ($x = 875; $x -le 995; $x++) {
    for ($y = 15; $y -le 114; $y++) {
        if ($mask[$x, $y]) {
            for ($dx = -2; $dx -le 2; $dx++) {
                for ($dy = -2; $dy -le 2; $dy++) {
                    $nx = $x + $dx
                    $ny = $y + $dy
                    if ($nx -ge 0 -and $nx -lt $bmp.Width -and $ny -ge 0 -and $ny -lt $bmp.Height) {
                        $dilatedMask[$nx, $ny] = $true
                    }
                }
            }
        }
    }
}

# Now, for any masked pixel, let's inpaint by interpolating from the nearest non-masked background pixels!
# Notice: horizontally, for row y:
# To the left: non-masked background at xLeft (around 878-885)
# To the right: non-masked background at xRight (around 985-1000)
# Also vertically: non-masked at yTop (around 12-15) and yBottom (around 114-118)

for ($x = 875; $x -le 995; $x++) {
    for ($y = 15; $y -le 114; $y++) {
        if ($dilatedMask[$x, $y]) {
            # Find closest unmasked pixel to the left on this row
            $leftX = $x
            while ($leftX -ge 860 -and $dilatedMask[$leftX, $y]) { $leftX-- }
            $cLeft = $bmp.GetPixel($leftX, $y)
            
            # Find closest unmasked pixel to the right on this row
            $rightX = $x
            while ($rightX -lt 1015 -and $dilatedMask[$rightX, $y]) { $rightX++ }
            $cRight = $bmp.GetPixel($rightX, $y)
            
            # Find closest unmasked pixel above in this column
            $topY = $y
            while ($topY -ge 5 -and $dilatedMask[$x, $topY]) { $topY-- }
            $cTop = $bmp.GetPixel($x, $topY)
            
            # Find closest unmasked pixel below in this column
            $botY = $y
            while ($botY -le 120 -and $dilatedMask[$x, $botY]) { $botY++ }
            $cBot = $bmp.GetPixel($x, $botY)
            
            # Weights based on inverse distance
            $dLeft = [Math]::Max(1, $x - $leftX)
            $dRight = [Math]::Max(1, $rightX - $x)
            $dTop = [Math]::Max(1, $y - $topY)
            $dBot = [Math]::Max(1, $botY - $y)
            
            $wLeft = 1.0 / $dLeft
            $wRight = 1.0 / $dRight
            $wTop = 1.0 / $dTop
            $wBot = 1.0 / $dBot
            
            $totalW = $wLeft + $wRight + $wTop + $wBot
            
            $newR = [int](($cLeft.R * $wLeft + $cRight.R * $wRight + $cTop.R * $wTop + $cBot.R * $wBot) / $totalW)
            $newG = [int](($cLeft.G * $wLeft + $cRight.G * $wRight + $cTop.G * $wTop + $cBot.G * $wBot) / $totalW)
            $newB = [int](($cLeft.B * $wLeft + $cRight.B * $wRight + $cTop.B * $wTop + $cBot.B * $wBot) / $totalW)
            
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $newR, $newG, $newB))
        }
    }
}

# Apply a gentle 3x3 blur over the inpainted region to make all transitions silky smooth
$temp = $bmp.Clone()
for ($x = 875; $x -le 995; $x++) {
    for ($y = 15; $y -le 114; $y++) {
        if ($dilatedMask[$x, $y]) {
            $sumR = 0; $sumG = 0; $sumB = 0; $count = 0
            for ($dx = -2; $dx -le 2; $dx++) {
                for ($dy = -2; $dy -le 2; $dy++) {
                    $nx = $x + $dx
                    $ny = $y + $dy
                    if ($nx -ge 0 -and $nx -lt $bmp.Width -and $ny -ge 0 -and $ny -lt $bmp.Height) {
                        $p = $temp.GetPixel($nx, $ny)
                        $sumR += $p.R
                        $sumG += $p.G
                        $sumB += $p.B
                        $count++
                    }
                }
            }
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, [int]($sumR / $count), [int]($sumG / $count), [int]($sumB / $count)))
        }
    }
}
$temp.Dispose()

# Save preview of quote region to inspect
$previewRect = New-Object System.Drawing.Rectangle(850, 0, $bmp.Width - 850, 125)
$previewBmp = $bmp.Clone($previewRect, $bmp.PixelFormat)
$previewBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\quote_removed_preview.png")
$previewBmp.Dispose()

# Also save full banner test
$bmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\test_banner_no_quote.png")

$bmp.Dispose()
Write-Host "Inpainting complete! Preview saved."
