Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789368286828.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Width: $($src.Width) Height: $($src.Height)"

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Host "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\dashboard_crop"
if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

# 1. Welcome banner right visual (Vessel, sunset, airplane, "Trade Without Boundaries" calligraphy)
CropImage 600 55 410 82 "$destDir\welcome_banner_visual.jpg"

# 2. Sidebar promo image (Container ship at sunset)
CropImage 14 268 135 70 "$destDir\sidebar_promo_ship.jpg"

# 3. Global Trade World Map
CropImage 172 260 240 148 "$destDir\dashboard_world_map.jpg"

# 4. Compliance Hologram Earth with Leaves
CropImage 860 455 145 78 "$destDir\compliance_hologram_earth.jpg"

# 5. Admin Avatar
CropImage 912 12 28 28 "$destDir\admin_avatar.jpg"

$src.Dispose()
Write-Host "All dashboard crops completed!"
