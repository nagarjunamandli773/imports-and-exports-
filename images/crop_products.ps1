Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789356081785.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $crop.Dispose()
    Write-Output "Saved $outFile"
}

$destDir = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop"
if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

# Hero visual collage
CropImage 450 56 574 140 "$destDir\product_hero_visual.jpg"

# 10 Product Photos
CropImage 200 270 125 60 "$destDir\prod_basmati.jpg"
CropImage 335 270 125 60 "$destDir\prod_black_pepper.jpg"
CropImage 470 270 125 60 "$destDir\prod_masoor_dal.jpg"
CropImage 605 270 125 60 "$destDir\prod_cashew.jpg"
CropImage 740 270 125 60 "$destDir\prod_coconut_oil.jpg"

CropImage 200 412 125 60 "$destDir\prod_almonds.jpg"
CropImage 335 412 125 60 "$destDir\prod_cardamom.jpg"
CropImage 470 412 125 60 "$destDir\prod_wheat.jpg"
CropImage 605 412 125 60 "$destDir\prod_apricots.jpg"
CropImage 740 412 125 60 "$destDir\prod_green_tea.jpg"

# Right widgets
CropImage 880 240 120 75 "$destDir\widget_bulk.jpg"
CropImage 880 420 120 95 "$destDir\widget_sustainable.jpg"

# Bottom bar background
CropImage 0 528 1024 48 "$destDir\bottom_bar.jpg"

$src.Dispose()
