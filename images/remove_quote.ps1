Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$destPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Let's inspect the bounding box of the text:
# x: 885 to 1015
# y: 15 to 110
# We can sample sky gradient colors:
# Top sky color at (950, 5): approx Color(22, 55, 95)
# Mid sky color at (950, 60): approx Color(35, 75, 120)
# Lower sky / cloud color at (950, 105): approx Color(65, 95, 135)

# We can create a seamless gradient brush that covers the text region
# Region to cover: polygon / rectangle around the text (from x=895 to width-2, y=10 to 115)
# But let's be very precise: The crane arm is at x=870, y=0 to 110.
# The container is at y=95+, x=840 to 890.

# Let's do a smooth pixel-level inpaint from the surrounding clean sky columns:
# For each pixel (x, y) in the text area (x: 890 to 1018, y: 12 to 115):
# If it's part of the text/line (white, light yellow, bright pixels), we interpolate from the sky background:
for ($x = 885; $x -lt ($bmp.Width - 1); $x++) {
    for ($y = 8; $y -lt 118; $y++) {
        $c = $bmp.GetPixel($x, $y)
        
        # Check if the pixel is text / gold line (high brightness or yellowish / whitish)
        $isText = ($c.R -gt 130 -and $c.G -gt 130 -and $c.B -gt 140) -or `
                  ($c.R -gt 170 -and $c.G -gt 160 -and $c.B -gt 90) -or `
                  ($c.R -gt 140 -and $c.G -gt 130 -and $c.B -lt 110) # gold line
        
        # Also within the text bounding region, smooth out any halo
        if ($x -ge 892 -and $x -le 1015 -and $y -ge 14 -and $y -le 114) {
            # Base sky gradient formula matching the surrounding sky
            $normY = $y / 144.0
            
            # Deep sky at top: R=24, G=58, B=98
            # Mid sky: R=45, G=82, B=126
            # Cloud base: R=78, G=102, B=140
            
            $r = [int](22 + $normY * 65)
            $g = [int](55 + $normY * 55)
            $b = [int](95 + $normY * 50)
            
            # Add slight horizontal variation matching the sunset glow on the left
            $glowFactor = [Math]::Max(0.0, (960 - $x) / 80.0)
            $r = [Math]::Min(255, [int]($r + $glowFactor * 25))
            $g = [Math]::Min(255, [int]($g + $glowFactor * 18))
            $b = [Math]::Min(255, [int]($b + $glowFactor * 10))

            # If it's text or close to text, replace with smoothed sky
            if ($isText -or ($x -ge 900 -and $x -le 1010 -and $y -ge 16 -and $y -le 110)) {
                $newColor = [System.Drawing.Color]::FromArgb(255, $r, $g, $b)
                $bmp.SetPixel($x, $y, $newColor)
            }
        }
    }
}

# Apply a soft 3x3 gaussian blur over the inpainted region to make it perfectly smooth
$inpaintRect = New-Object System.Drawing.Rectangle(888, 10, $bmp.Width - 890, 108)
# We can do a 2-pass box blur for seamless blending
$tempBmp = $bmp.Clone()
for ($x = 890; $x -lt ($bmp.Width - 3); $x++) {
    for ($y = 12; $y -lt 116; $y++) {
        $sumR = 0; $sumG = 0; $sumB = 0; $count = 0
        for ($dx = -2; $dx -le 2; $dx++) {
            for ($dy = -2; $dy -le 2; $dy++) {
                $px = $x + $dx
                $py = $y + $dy
                if ($px -ge 0 -and $px -lt $bmp.Width -and $py -ge 0 -and $py -lt $bmp.Height) {
                    $pCol = $tempBmp.GetPixel($px, $py)
                    $sumR += $pCol.R
                    $sumG += $pCol.G
                    $sumB += $pCol.B
                    $count++
                }
            }
        }
        $avgR = [int]($sumR / $count)
        $avgG = [int]($sumG / $count)
        $avgB = [int]($sumB / $count)
        $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $avgR, $avgG, $avgB))
    }
}
$tempBmp.Dispose()

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$bmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg", $jpegCodec, $encoderParams)

# Also overwrite product_hero_cropped.jpg
$bmp.Save($destPath, $jpegCodec, $encoderParams)

$bmp.Dispose()
$g.Dispose()

Write-Host "Quote text removed cleanly!"
