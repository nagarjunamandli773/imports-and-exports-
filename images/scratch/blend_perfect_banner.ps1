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

# Crop pure sunset sky from hero_banner (x: 1050 to 1350, y: 30 to 250)
$skyRect = New-Object System.Drawing.Rectangle(1050, 30, 300, 220)
$pureSky = $heroBmp.Clone($skyRect, $heroBmp.PixelFormat)

# Destination in service hero banner:
# x: 875 to 1024 (w: 149), y: 0 to 100 (h: 100)
$destX = 872
$destY = 0
$destW = $bmp.Width - $destX
$destH = 102

# Resize pureSky to destW x destH
$scaledSky = New-Object System.Drawing.Bitmap($destW, $destH)
$sg = [System.Drawing.Graphics]::FromImage($scaledSky)
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$sg.DrawImage($pureSky, 0, 0, $destW, $destH)
$sg.Dispose()

# Now blend with feathering
for ($y = 0; $y -lt $destH; $y++) {
    for ($x = 0; $x -lt $destW; $x++) {
        $realX = $destX + $x
        $realY = $destY + $y
        
        # Feather left edge
        $alphaX = 1.0
        if ($x -lt 14) {
            $alphaX = $x / 14.0
        }
        
        # Feather bottom edge near skyline
        $alphaY = 1.0
        if ($y -gt ($destH - 12)) {
            $alphaY = ($destH - 1 - $y) / 11.0
        }
        
        $alpha = [Math]::Max(0.0, [Math]::Min(1.0, $alphaX * $alphaY))
        
        $origCol = $bmp.GetPixel($realX, $realY)
        $skyCol = $scaledSky.GetPixel($x, $y)
        
        # Slight color matching to service banner's vibrant blue/sunset palette
        # Adjust skyCol RGB slightly to match left neighbor
        $adjR = [Math]::Min(255, [int]($skyCol.R * 0.95 + 10))
        $adjG = [Math]::Min(255, [int]($skyCol.G * 0.95 + 15))
        $adjB = [Math]::Min(255, [int]($skyCol.B * 1.05 + 20))
        
        $finalR = [int]($origCol.R * (1 - $alpha) + $adjR * $alpha)
        $finalG = [int]($origCol.G * (1 - $alpha) + $adjG * $alpha)
        $finalB = [int]($origCol.B * (1 - $alpha) + $adjB * $alpha)
        
        $resBmp.SetPixel($realX, $realY, [System.Drawing.Color]::FromArgb($finalR, $finalG, $finalB))
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_perfect.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$heroBmp.Dispose()
$pureSky.Dispose()
$scaledSky.Dispose()
$resBmp.Dispose()
$g.Dispose()

Write-Host "Saved service_hero_perfect.jpg"
