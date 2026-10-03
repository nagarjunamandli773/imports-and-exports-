Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789365771431.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Host "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\login_crop"

# Re-crop card script decal
CropImage 890 80 100 70 "$destDir\card_script_decal.jpg"

# Crop clean vessel and ocean backdrop
CropImage 250 185 390 175 "$destDir\clean_vessel_ocean.jpg"

# Crop clean airplane in sky
CropImage 465 110 135 65 "$destDir\clean_airplane.jpg"

# Crop clean digital globe
CropImage 0 230 220 180 "$destDir\clean_digital_globe.jpg"

$src.Dispose()
Write-Host "Re-crop done!"
