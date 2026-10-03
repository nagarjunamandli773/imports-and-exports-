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
if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

# 1. Full Left Hero Canvas Background (vessel, airplane, sunset sea, port, glowing network globe)
CropImage 0 46 660 480 "$destDir\login_hero_backdrop.jpg"

# 2. Card corner script calligraphy ("Global Trade Starts Here" with faint world map)
CropImage 868 115 125 56 "$destDir\card_script_decal.jpg"

# 3. Security Shield / Lock Watermark Tech Graphic
CropImage 890 415 85 50 "$destDir\security_badge_graphic.jpg"

# 4. Footer Digital Network Globe
CropImage 885 520 139 56 "$destDir\footer_network_globe.jpg"

# 5. Vessel & Cranes Golden Horizon
CropImage 250 185 400 200 "$destDir\vessel_golden_sunset.jpg"

# 6. Digital Network Globe Wireframe
CropImage 0 230 225 180 "$destDir\digital_globe_wireframe.jpg"

$src.Dispose()
Write-Host "All login crops completed!"
