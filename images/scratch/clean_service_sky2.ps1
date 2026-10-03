Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$resBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)

$g = [System.Drawing.Graphics]::FromImage($resBmp)
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)
$g.Dispose()

# For the clean sky region:
# Left clean reference column at x = 865 (clean sky between crane and text)
# Right clean reference at x = 1023 (or gradient continuation)
# Let's sample the clean vertical column at x = 865 from y = 0 to 105:

for ($y = 0; $y -le 104; $y++) {
    $cLeft = $bmp.GetPixel(865, $y)
    
    # Let's look at how the sky gradient naturally behaves:
    # At y=0..35: R: 30-50, G: 70-110, B: 150-195 (Deep rich blue)
    # At y=35..65: R: 80-140, G: 110-155, B: 170-205 (Soft light blue / white cloud)
    # At y=65..95: R: 180-220, G: 140-180, B: 160-190 (Warm sunset peach / rose glow)
    # At y=95..104: R: 190-210, G: 150-170, B: 160-180 (Atmospheric horizon haze)

    for ($x = 870; $x -lt $bmp.Width; $x++) {
        $dist = ($x - 870) / ($bmp.Width - 870)
        
        # Subtle natural horizontal variation (cloud softness)
        $cloudOffset = [Math]::Sin(($x - 870) * 0.05 + $y * 0.1) * 3
        
        # Calculate smooth interpolated RGB
        $nr = [Math]::Max(0, [Math]::Min(255, [int]($cLeft.R + $cloudOffset * 0.5)))
        $ng = [Math]::Max(0, [Math]::Min(255, [int]($cLeft.G + $cloudOffset * 0.8)))
        $nb = [Math]::Max(0, [Math]::Min(255, [int]($cLeft.B + $cloudOffset)))
        
        # Smooth blend at the transition boundary (x = 868 to 876)
        if ($x -lt 876) {
            $orig = $bmp.GetPixel($x, $y)
            $alpha = ($x - 868) / 8.0
            $nr = [int]($orig.R * (1 - $alpha) + $nr * $alpha)
            $ng = [int]($orig.G * (1 - $alpha) + $ng * $alpha)
            $nb = [int]($orig.B * (1 - $alpha) + $nb * $alpha)
        }
        
        # Smooth blend at the skyline boundary (y = 98 to 104)
        if ($y -ge 98) {
            $orig = $bmp.GetPixel($x, $y)
            $yAlpha = (104 - $y) / 6.0
            $nr = [int]($orig.R * (1 - $yAlpha) + $nr * $yAlpha)
            $ng = [int]($orig.G * (1 - $yAlpha) + $ng * $yAlpha)
            $nb = [int]($orig.B * (1 - $yAlpha) + $nb * $yAlpha)
        }

        $resBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($nr, $ng, $nb))
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_clean.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$resBmp.Dispose()
Write-Host "Saved service_hero_clean.jpg"
