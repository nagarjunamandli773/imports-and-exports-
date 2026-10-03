Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

# In media_1789971937755.jpg, let's crop y from 0 to 148, x from 0 to width
$rect = New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, 148)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\orig_hero_raw.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$crop.Dispose()
Write-Host "Saved orig_hero_raw.jpg"
