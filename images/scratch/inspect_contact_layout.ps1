Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Uploaded Image Size: $($bmp.Width) x $($bmp.Height)"

# Let's save a few crops to inspect them clearly:
function SaveCrop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $crop.Save("images\scratch\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
    Write-Host "Saved $name ($w x $h)"
}

# 1. Eyebrow + Heading area: x: 0 to 450, y: 0 to 160
SaveCrop 0 0 450 160 "crop_eyebrow_heading"

# 2. Paragraph area: x: 0 to 450, y: 150 to 220
SaveCrop 0 150 450 70 "crop_paragraph"

# 3. Badges area: x: 0 to 450, y: 210 to 320
SaveCrop 0 210 450 110 "crop_badges"

# 4. Badge 1 close-up
SaveCrop 25 215 95 85 "crop_badge1"

# 5. Badge 2 close-up
SaveCrop 125 215 95 85 "crop_badge2"

# 6. Badge 3 close-up
SaveCrop 230 215 95 85 "crop_badge3"

# 7. Badge 4 close-up
SaveCrop 335 215 105 85 "crop_badge4"

$bmp.Dispose()
