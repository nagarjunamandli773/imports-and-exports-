Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789359957474.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Output "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop"
if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

# 1. Hero Lab Visual (Scientist, microscopes, grains, text Quality Today. A Healthier Tomorrow, and 4 badges)
CropImage 348 56 676 130 "$destDir\hero_lab_visual.jpg"

# 2. Certification Logos (6 logos)
CropImage 235 208 85 40 "$destDir\cert_iso.jpg"
CropImage 342 208 80 40 "$destDir\cert_haccp.jpg"
CropImage 445 208 72 40 "$destDir\cert_fssai.jpg"
CropImage 544 208 64 40 "$destDir\cert_usda.jpg"
CropImage 640 208 64 40 "$destDir\cert_gmp.jpg"
CropImage 740 208 72 40 "$destDir\cert_globalgap.jpg"

# 3. Sustainable Compliance Card (Hand holding green growing globe)
CropImage 840 197 146 126 "$destDir\card_sustainability.jpg"

# 4. Quality Process Left Card (Blue digital globe with lines)
CropImage 18 332 248 94 "$destDir\card_quality_process.jpg"

# 5. Bottom Sunset Cargo Vessel
CropImage 775 491 249 85 "$destDir\bottom_ship_sunset.jpg"

$src.Dispose()
Write-Output "All compliance crops completed successfully!"
