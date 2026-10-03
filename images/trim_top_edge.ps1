Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

# Fill top 5px across x=870 to width with the deep blue sky color (R=24, G=58, B=98)
for ($x = 850; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt 6; $y++) {
        $skyCol = $bmp.GetPixel($x, 7)
        $bmp.SetPixel($x, $y, $skyCol)
    }
}

# Also fill far right 2px
for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = ($bmp.Width - 3); $x -lt $bmp.Width; $x++) {
        $bmp.SetPixel($x, $y, $bmp.GetPixel($bmp.Width - 4, $y))
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$bmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg", $jpegCodec, $encoderParams)
$bmp.Save($srcPath, $jpegCodec, $encoderParams)

# Also update product_hero_visual.jpg
$bmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
Write-Host "Edges polished perfectly!"
