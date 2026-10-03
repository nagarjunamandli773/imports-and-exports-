Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789362703708.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Output "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop"
if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

# 1. Hero visual collage (Customer support specialist with headset, container ship at sunset, script text)
CropImage 350 56 674 135 "$destDir\hero_contact_visual.jpg"

# 2. World network map with connecting flight/shipping arcs
CropImage 560 205 250 110 "$destDir\contact_world_map.jpg"

# 3. Cargo vessel top photo for Need a Custom Solution? widget
CropImage 818 200 152 55 "$destDir\contact_vessel.jpg"

$src.Dispose()
Write-Output "All contact crops completed successfully!"
