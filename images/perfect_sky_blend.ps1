Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$w = [int]$bmp.Width - 4
$h = 144
$heroRect = New-Object System.Drawing.Rectangle(2, 2, $w, $h)
$heroBmp = $bmp.Clone($heroRect, $bmp.PixelFormat)

# In the original image, let's look at the sky columns from x=750 to 820 (which have the natural sky and clouds)
# Let's clone that sky texture and seamlessly blend it onto x=885 to 1018
for ($y = 0; $y -lt 115; $y++) {
    # Sample clean sky color on the left of crane at x=780 to 820
    # Also sample the sky at x=880 (before the text starts)
    $cLeft = $heroBmp.GetPixel(860, $y)
    
    # Calculate gradient interpolation for the text area
    for ($x = 880; $x -lt ($heroBmp.Width - 1); $x++) {
        $c = $heroBmp.GetPixel($x, $y)
        
        # If this pixel is part of the text or swoosh, or in the text box
        # Check text brightness:
        $isText = ($c.R -gt 135 -and $c.G -gt 135 -and $c.B -gt 130) -or `
                  ($c.R -gt 160 -and $c.G -gt 150 -and $c.B -gt 80) -or `
                  ($c.R -gt 130 -and $c.G -gt 120 -and $c.B -lt 110)
        
        # Text region is x from 892 to 1015, y from 10 to 112
        if (($isText -or ($x -ge 892 -and $x -le 1015 -and $y -ge 12 -and $y -le 112)) -and $y -lt 112) {
            # Let's compute natural sky color at this height:
            # Top sky (y=5): #1c426f (R=28, G=66, B=111)
            # Mid sky (y=50): #2d5887 (R=45, G=88, B=135)
            # Cloud top (y=80): #567299 (R=86, G=114, B=153)
            # Sunset cloud (y=105): #a28994 (R=162, G=137, B=148)
            # Warm glow at bottom (y=112): #cf9d84 (R=207, G=157, B=132)
            
            $norm = $y / 112.0
            
            # Interpolate smoothly matching the sunset horizon
            if ($norm -lt 0.45) {
                # Upper sky
                $t = $norm / 0.45
                $r = [int](28 * (1 - $t) + 48 * $t)
                $g = [int](66 * (1 - $t) + 90 * $t)
                $b = [int](111 * (1 - $t) + 138 * $t)
            } elseif ($norm -lt 0.75) {
                # Mid sky into cloud
                $t = ($norm - 0.45) / 0.30
                $r = [int](48 * (1 - $t) + 96 * $t)
                $g = [int](90 * (1 - $t) + 120 * $t)
                $b = [int](138 * (1 - $t) + 155 * $t)
            } elseif ($norm -lt 0.92) {
                # Rosy sunset cloud
                $t = ($norm - 0.75) / 0.17
                $r = [int](96 * (1 - $t) + 168 * $t)
                $g = [int](120 * (1 - $t) + 142 * $t)
                $b = [int](155 * (1 - $t) + 150 * $t)
            } else {
                # Warm golden dusk horizon
                $t = ($norm - 0.92) / 0.08
                $r = [int](168 * (1 - $t) + 215 * $t)
                $g = [int](142 * (1 - $t) + 165 * $t)
                $b = [int](150 * (1 - $t) + 135 * $t)
            }
            
            # Add subtle natural horizontal gradient (sunset brighter to the left)
            $xDist = (1015 - $x) / 130.0
            $r = [Math]::Min(255, [int]($r + $xDist * 18))
            $g = [Math]::Min(255, [int]($g + $xDist * 12))
            $b = [Math]::Min(255, [int]($b + $xDist * 5))
            
            $heroBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $r, $g, $b))
        }
    }
}

# Soft blur on the text region to blend boundaries seamlessly
$temp = $heroBmp.Clone()
for ($x = 885; $x -lt ($heroBmp.Width - 3); $x++) {
    for ($y = 10; $y -lt 114; $y++) {
        $sumR = 0; $sumG = 0; $sumB = 0; $cnt = 0
        for ($dx = -3; $dx -le 3; $dx++) {
            for ($dy = -3; $dy -le 3; $dy++) {
                $px = $x + $dx
                $py = $y + $dy
                if ($px -ge 0 -and $px -lt $heroBmp.Width -and $py -ge 0 -and $py -lt $heroBmp.Height) {
                    $c = $temp.GetPixel($px, $py)
                    $sumR += $c.R
                    $sumG += $c.G
                    $sumB += $c.B
                    $cnt++
                }
            }
        }
        $heroBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, [int]($sumR/$cnt), [int]($sumG/$cnt), [int]($sumB/$cnt)))
    }
}
$temp.Dispose()

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$destPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$heroBmp.Save($destPath, $jpegCodec, $encoderParams)

$bmp.Dispose()
$heroBmp.Dispose()

Write-Host "Seamless sky reconstruction finished!"
