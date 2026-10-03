Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789368286828.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Host "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\dashboard_crop"

# Clean Compliance Earth (no top line)
CropImage 860 460 148 78 "$destDir\compliance_hologram_earth.jpg"

# Crop Full Welcome Banner (X: 165, Y: 56, W: 844, H: 81)
CropImage 165 56 844 81 "$destDir\welcome_full_banner.jpg"

$src.Dispose()
Write-Host "Re-crop done!"
