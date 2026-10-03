Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971500581.png"
$destPath = "c:\Users\Administrator\Pictures\emports and exports\images\hero_visual_clean.jpg"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

# Trim left 4.5% to remove 'ies', and 2px from right/top/bottom to remove screenshot borders
$cropX = [int]($bmp.Width * 0.048)
$cropY = 2
$cropWidth = $bmp.Width - $cropX - 4
$cropHeight = $bmp.Height - 4

$cropRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropWidth, $cropHeight)
$croppedBmp = $bmp.Clone($cropRect, $bmp.PixelFormat)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$croppedBmp.Save($destPath, $jpegCodec, $encoderParams)

$bmp.Dispose()
$croppedBmp.Dispose()

Write-Host "Processed pixel-perfect clean hero image ($cropWidth x $cropHeight) to hero_visual_clean.jpg"
