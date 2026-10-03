Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$resBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)

$g = [System.Drawing.Graphics]::FromImage($resBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Draw full base image
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)

# Source patch: x: 365 to 475 (w: 110), y: 0 to 95 (h: 95)
# Destination 1: x: 875 to 1024 (w: 149), y: 0 to 98 (h: 98)
$srcRect = New-Object System.Drawing.Rectangle(365, 0, 110, 95)
$skyPatch = $bmp.Clone($srcRect, $bmp.PixelFormat)

# We will paint this onto resBmp with feathered alpha mask so it blends seamlessly
$destXStart = 872
$destYStart = 0
$destW = $bmp.Width - $destXStart
$destH = 100

# Scaled sky patch to match dest width/height
$scaledSky = New-Object System.Drawing.Bitmap($destW, $destH)
$sg = [System.Drawing.Graphics]::FromImage($scaledSky)
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$sg.DrawImage($skyPatch, 0, 0, $destW, $destH)
$sg.Dispose()

# Now blend pixel by pixel with smooth alpha edge feathering
for ($y = 0; $y -lt $destH; $y++) {
    for ($x = 0; $x -lt $destW; $x++) {
        $realX = $destXStart + $x
        $realY = $destYStart + $y
        
        # Calculate alpha
        $alphaX = 1.0
        if ($x -lt 12) {
            $alphaX = $x / 12.0
        }
        
        $alphaY = 1.0
        if ($y -gt ($destH - 12)) {
            $alphaY = ($destH - 1 - $y) / 11.0
        }
        
        $alpha = [Math]::Max(0.0, [Math]::Min(1.0, $alphaX * $alphaY))
        
        $origCol = $bmp.GetPixel($realX, $realY)
        $skyCol = $scaledSky.GetPixel($x, $y)
        
        # Color temperature adjustment to match right side's slightly warmer tone
        $adjR = [Math]::Min(255, [int]($skyCol.R * 1.05 + 5))
        $adjG = [Math]::Min(255, [int]($skyCol.G * 0.98))
        $adjB = [Math]::Min(255, [int]($skyCol.B * 0.96))
        
        $finalR = [int]($origCol.R * (1 - $alpha) + $adjR * $alpha)
        $finalG = [int]($origCol.G * (1 - $alpha) + $adjG * $alpha)
        $finalB = [int]($origCol.B * (1 - $alpha) + $adjB * $alpha)
        
        $resBmp.SetPixel($realX, $realY, [System.Drawing.Color]::FromArgb($finalR, $finalG, $finalB))
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_seamless.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$skyPatch.Dispose()
$scaledSky.Dispose()
$resBmp.Dispose()
$g.Dispose()

Write-Host "Saved service_hero_seamless.jpg"
