Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789974234398.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

# In media_1789974234398.jpg (1024 x 528):
# 8 Service Cards:
# Row 1: y = 197 to 242 (height approx 45px, width approx 140px)
# Card 1: Import Solutions (x: 198, y: 198, w: 140, h: 48)
# Card 2: Export Management (x: 348, y: 198, w: 140, h: 48)
# Card 3: Global Sourcing (x: 498, y: 198, w: 140, h: 48)
# Card 4: Logistics Coordination (x: 648, y: 198, w: 140, h: 48)
# Row 2: y = 313 to 358 (height approx 45px, width approx 140px)
# Card 5: Customs Support (x: 198, y: 314, w: 140, h: 48)
# Card 6: Trade Consulting (x: 348, y: 314, w: 140, h: 48)
# Card 7: Value Added Services (x: 498, y: 314, w: 140, h: 48)
# Card 8: Digital Trade Solutions (x: 648, y: 314, w: 140, h: 48)

function SaveCrop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\$name", $jpegCodec, $encoderParams)
    $crop.Dispose()
    Write-Host "Saved $name"
}

SaveCrop 198 198 142 50 "srv_import.jpg"
SaveCrop 348 198 142 50 "srv_export.jpg"
SaveCrop 498 198 142 50 "srv_sourcing.jpg"
SaveCrop 648 198 142 50 "srv_logistics.jpg"
SaveCrop 198 314 142 50 "srv_customs.jpg"
SaveCrop 348 314 142 50 "srv_consulting.jpg"
SaveCrop 498 314 142 50 "srv_value_added.jpg"
SaveCrop 648 314 142 50 "srv_digital.jpg"

# Right widgets:
# Handshake image (x: 805, y: 314, w: 172, h: 36)
SaveCrop 805 314 172 36 "srv_handshake.jpg"

# Custom solution widget (x: 27, y: 340, w: 150, h: 75)
SaveCrop 27 340 150 75 "widget_custom_solution.jpg"

# Service impact map background (x: 805, y: 153, w: 172, h: 148)
SaveCrop 805 153 172 148 "widget_impact.jpg"

$bmp.Dispose()
Write-Host "All crops saved successfully!"
