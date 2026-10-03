Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789974234398.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

function SaveCleanCrop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\$name", $jpegCodec, $encoderParams)
    $crop.Dispose()
}

SaveCleanCrop 202 206 136 47 "srv_import.jpg"
SaveCleanCrop 353 206 136 47 "srv_export.jpg"
SaveCleanCrop 504 206 136 47 "srv_sourcing.jpg"
SaveCleanCrop 655 206 136 47 "srv_logistics.jpg"

SaveCleanCrop 202 322 136 47 "srv_customs.jpg"
SaveCleanCrop 353 322 136 47 "srv_consulting.jpg"
SaveCleanCrop 504 322 136 47 "srv_value_added.jpg"
SaveCleanCrop 655 322 136 47 "srv_digital.jpg"

SaveCleanCrop 808 322 168 32 "srv_handshake.jpg"
SaveCleanCrop 27 346 148 68 "widget_custom_solution.jpg"

$bmp.Dispose()
Write-Host "Precision crops saved!"
