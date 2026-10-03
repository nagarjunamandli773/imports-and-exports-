$masterSrc = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_vector_products_banner_4k.png"

$destPaths = @(
    "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png",
    "c:\Users\Administrator\Pictures\emports and exports\images\product_hero_banner.png"
)

foreach ($dest in $destPaths) {
    Copy-Item $masterSrc $dest -Force
    Write-Host "Deployed to: $dest"
}

# Also save high-quality JPEG fallbacks
Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile($masterSrc)

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$jpgPaths = @(
    "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg",
    "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg",
    "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg"
)

foreach ($jpg in $jpgPaths) {
    $bmp.Save($jpg, $jpegCodec, $encoderParams)
    Write-Host "Deployed JPEG to: $jpg"
}

$bmp.Dispose()
Write-Host "All products hero banner assets successfully deployed in 4K crystal-clear fidelity!"
