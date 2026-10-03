Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789358428899.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Output "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop"
if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

# Hero composite visual
CropImage 390 56 634 140 "$destDir\service_hero_visual.jpg"

# 8 Services photos
CropImage 206 264 135 55 "$destDir\srv_import.jpg"
CropImage 359 264 135 55 "$destDir\srv_export.jpg"
CropImage 512 264 135 55 "$destDir\srv_sourcing.jpg"
CropImage 665 264 135 55 "$destDir\srv_logistics.jpg"

CropImage 206 384 135 55 "$destDir\srv_customs.jpg"
CropImage 359 384 135 55 "$destDir\srv_consulting.jpg"
CropImage 512 384 135 55 "$destDir\srv_value_added.jpg"
CropImage 665 384 135 55 "$destDir\srv_digital.jpg"

# Right widgets
CropImage 822 215 170 160 "$destDir\widget_impact.jpg"
CropImage 822 384 170 42 "$destDir\srv_handshake.jpg"

# Left widget
CropImage 32 411 160 78 "$destDir\widget_custom_solution.jpg"

$src.Dispose()
