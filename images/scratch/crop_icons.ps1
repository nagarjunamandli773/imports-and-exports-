Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

function SaveCrop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $crop.Save("images\scratch\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
    Write-Host "Saved $name ($w x $h)"
}

# Icon 1 circle
SaveCrop 50 220 42 42 "icon_circle1"
# Icon 2 circle
SaveCrop 155 220 42 42 "icon_circle2"
# Icon 3 circle
SaveCrop 260 220 42 42 "icon_circle3"
# Icon 4 circle
SaveCrop 366 220 42 42 "icon_circle4"

$bmp.Dispose()
