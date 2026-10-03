Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg"
$bannerSrc = "c:\Users\Administrator\Pictures\emports and exports\images\hero_banner.jpg"

$bmp = [System.Drawing.Bitmap]::FromFile($src)
$heroBmp = [System.Drawing.Bitmap]::FromFile($bannerSrc)

$resBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
$g = [System.Drawing.Graphics]::FromImage($resBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Draw the base image
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)

# Clean sky from hero_banner (wide aspect ratio: 350x220)
$skyRect = New-Object System.Drawing.Rectangle(1020, 25, 340, 220)
$pureSky = $heroBmp.Clone($skyRect, $heroBmp.PixelFormat)

$destX = 866
$destY = 0
$destW = $bmp.Width - $destX
$destH = 118

$scaledSky = New-Object System.Drawing.Bitmap($destW, $destH)
$sg = [System.Drawing.Graphics]::FromImage($scaledSky)
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$sg.DrawImage($pureSky, 0, 0, $destW, $destH)
$sg.Dispose()

for ($y = 0; $y -lt $destH; $y++) {
    $refLeft = $bmp.GetPixel(865, $y)
    $skyLeftSample = $scaledSky.GetPixel(0, $y)
    
    $diffR = $refLeft.R - $skyLeftSample.R
    $diffG = $refLeft.G - $skyLeftSample.G
    $diffB = $refLeft.B - $skyLeftSample.B
    
    for ($x = 0; $x -lt $destW; $x++) {
        $realX = $destX + $x
        $realY = $destY + $y
        
        $alphaX = 1.0
        if ($x -lt 16) {
            $alphaX = $x / 16.0
        }
        
        $alphaY = 1.0
        if ($y -gt 105) {
            $alphaY = ($destH - 1 - $y) / 12.0
        }
        
        $alpha = [Math]::Max(0.0, [Math]::Min(1.0, $alphaX * $alphaY))
        
        $origCol = $bmp.GetPixel($realX, $realY)
        $skyCol = $scaledSky.GetPixel($x, $y)
        
        # Color match offset smoothly
        $adjR = [Math]::Max(0, [Math]::Min(255, [int]($skyCol.R + $diffR)))
        $adjG = [Math]::Max(0, [Math]::Min(255, [int]($skyCol.G + $diffG)))
        $adjB = [Math]::Max(0, [Math]::Min(255, [int]($skyCol.B + $diffB)))
        
        $finalR = [int]($origCol.R * (1 - $alpha) + $adjR * $alpha)
        $finalG = [int]($origCol.G * (1 - $alpha) + $adjG * $alpha)
        $finalB = [int]($origCol.B * (1 - $alpha) + $adjB * $alpha)
        
        $resBmp.SetPixel($realX, $realY, [System.Drawing.Color]::FromArgb($finalR, $finalG, $finalB))
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_banner_clean.jpg", $jpegCodec, $encoderParams)
$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_visual.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$heroBmp.Dispose()
$pureSky.Dispose()
$scaledSky.Dispose()
$resBmp.Dispose()
$g.Dispose()

Write-Host "Refined blend saved!"
