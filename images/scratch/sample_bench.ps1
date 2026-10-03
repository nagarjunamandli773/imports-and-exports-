Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Sampling lab bench at X=460 to 520 across Y=270 to 310:"
for ($y = 270; $y -le 310; $y += 5) {
    $p460 = $bmp.GetPixel(460, $y)
    $p480 = $bmp.GetPixel(480, $y)
    $p500 = $bmp.GetPixel(500, $y)
    Write-Host ("Y=" + $y + " | X=460: " + $p460.R + "," + $p460.G + "," + $p460.B + " | X=480: " + $p480.R + "," + $p480.G + "," + $p480.B + " | X=500: " + $p500.R + "," + $p500.G + "," + $p500.B)
}

$bmp.Dispose()
