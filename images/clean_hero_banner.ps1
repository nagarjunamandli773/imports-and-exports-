Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

# Crop exactly the top banner area (from y = 2 to y = 146, x = 2 to width - 4)
$w = [int]$bmp.Width - 4
$h = 144
$heroRect = New-Object System.Drawing.Rectangle(2, 2, $w, $h)
$heroBmp = $bmp.Clone($heroRect, $bmp.PixelFormat)

$destPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$heroBmp.Save($destPath, $jpegCodec, $encoderParams)

$bmp.Dispose()
$heroBmp.Dispose()

Write-Host "Cleaned product hero banner ($w x $h) saved successfully!"
