Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Checking swoosh boundary at X=40, 60, 80, 100 across Y=270 to 320:"
for ($y = 270; $y -le 320; $y += 5) {
    $p40 = $bmp.GetPixel(40, $y)
    $p60 = $bmp.GetPixel(60, $y)
    $p80 = $bmp.GetPixel(80, $y)
    $p100 = $bmp.GetPixel(100, $y)
    Write-Host ("Y=" + $y + " | X=40: (" + $p40.R + "," + $p40.G + "," + $p40.B + ") | X=60: (" + $p60.R + "," + $p60.G + "," + $p60.B + ") | X=80: (" + $p80.R + "," + $p80.G + "," + $p80.B + ") | X=100: (" + $p100.R + "," + $p100.G + "," + $p100.B + ")")
}

$bmp.Dispose()
