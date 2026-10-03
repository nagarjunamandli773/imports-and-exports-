Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$resBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)

$g = [System.Drawing.Graphics]::FromImage($resBmp)
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)
$g.Dispose()

# Text region in full image coordinates:
# x: 880 to 1015, y: 18 to 115
# Let's inspect text mask:
# In this region, background is blue sky at top (y: 18-50, R: 30-70, G: 80-130, B: 140-190)
# sunset cloud in middle (y: 50-85, R: 160-210, G: 110-160, B: 140-180)
# Text is white/cream (R > 210, G > 210, B > 210) and yellow swoop (R > 210, G > 180, B < 120)

for ($y = 10; $y -le 115; $y++) {
    for ($x = 880; $x -le 1020; $x++) {
        $c = $bmp.GetPixel($x, $y)
        
        # Detect if this pixel is part of the white text or yellow underline
        $isWhiteText = ($c.R -gt 195 -and $c.G -gt 195 -and $c.B -gt 195) -or
                       ($c.R -gt 170 -and $c.G -gt 170 -and $c.B -gt 180 -and [Math]::Abs($c.R - $c.G) -lt 25 -and [Math]::Abs($c.G - $c.B) -lt 25)
        $isYellowLine = ($c.R -gt 190 -and $c.G -gt 160 -and $c.B -lt 140)
        
        # Soft glow / edge around text
        $isTextGlow = ($c.R -gt 160 -and $c.G -gt 160 -and $c.B -gt 170 -and $y -lt 85) -or
                      ($c.R -gt 185 -and $c.G -gt 155 -and $c.B -lt 150 -and $y -ge 75 -and $y -le 112)

        # If it's within the text bounding zone and matches text characteristics
        if ($isWhiteText -or $isYellowLine -or $isTextGlow) {
            # Find nearest non-text pixels to the left and right at this same Y
            $leftColor = $null
            for ($lx = $x - 1; $lx -ge 860; $lx--) {
                $lc = $bmp.GetPixel($lx, $y)
                $lIsText = ($lc.R -gt 170 -and $lc.G -gt 170 -and $lc.B -gt 170) -or ($lc.R -gt 190 -and $lc.G -gt 160 -and $lc.B -lt 140)
                if (-not $lIsText) {
                    $leftColor = $lc
                    $leftX = $lx
                    break
                }
            }

            $rightColor = $null
            for ($rx = $x + 1; $rx -lt 1024; $rx++) {
                $rc = $bmp.GetPixel($rx, $y)
                $rIsText = ($rc.R -gt 170 -and $rc.G -gt 170 -and $rc.B -gt 170) -or ($rc.R -gt 190 -and $rc.G -gt 160 -and $rc.B -lt 140)
                if (-not $rIsText) {
                    $rightColor = $rc
                    $rightX = $rx
                    break
                }
            }

            if ($leftColor -and $rightColor -and ($rightX -gt $leftX)) {
                $t = ($x - $leftX) / ($rightX - $leftX)
                $nr = [int]($leftColor.R * (1 - $t) + $rightColor.R * $t)
                $ng = [int]($leftColor.G * (1 - $t) + $rightColor.G * $t)
                $nb = [int]($leftColor.B * (1 - $t) + $rightColor.B * $t)
                $resBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($nr, $ng, $nb))
            } elseif ($leftColor) {
                $resBmp.SetPixel($x, $y, $leftColor)
            }
        }
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_cleaned_test.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$resBmp.Dispose()
Write-Host "Inpainting complete, saved service_hero_cleaned_test.jpg"
