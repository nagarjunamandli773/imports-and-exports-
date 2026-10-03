Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$destTmp = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\temp_clean.jpg"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

# Clean top 4px across entire image
for ($x = 0; $x -lt $bmp.Width; $x++) {
    $c = $bmp.GetPixel($x, 4)
    for ($y = 0; $y -lt 4; $y++) {
        $bmp.SetPixel($x, $y, $c)
    }
}

# Clean right 3px across entire height
for ($y = 0; $y -lt $bmp.Height; $y++) {
    $c = $bmp.GetPixel($bmp.Width - 4, $y)
    for ($x = ($bmp.Width - 3); $x -lt $bmp.Width; $x++) {
        $bmp.SetPixel($x, $y, $c)
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$bmp.Save($destTmp, $jpegCodec, $encoderParams)
$bmp.Dispose()

Copy-Item $destTmp $srcPath -Force
Copy-Item $destTmp "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg" -Force
Remove-Item $destTmp -Force

Write-Host "Border cleaned seamlessly!"
