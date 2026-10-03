Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

# Let's crop the top hero banner (y = 0 to 148)
$heroRect = New-Object System.Drawing.Rectangle(0, 0, [int]$bmp.Width, 148)
$heroBmp = $bmp.Clone($heroRect, $bmp.PixelFormat)
$heroBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg", $jpegCodec, $encoderParams)

# Also let's crop just the right visual part (ship, plane, cranes)
$w = [int]$bmp.Width - 460
$visualRect = New-Object System.Drawing.Rectangle(460, 0, $w, 148)
$visualBmp = $bmp.Clone($visualRect, $bmp.PixelFormat)
$visualBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_right_visual.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$heroBmp.Dispose()
$visualBmp.Dispose()

Write-Host "Crops saved successfully!"
