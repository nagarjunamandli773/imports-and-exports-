Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Sampling background around text:"
for ($x = 20; $x -le 460; $x += 40) {
    # Sample at Y=35 (between top and eyebrow), Y=60 (between eyebrow and title), Y=160 (between title and paragraph), Y=218 (between paragraph and badges)
    $p35 = $bmp.GetPixel($x, 35)
    $p60 = $bmp.GetPixel($x, 60)
    $p160 = $bmp.GetPixel($x, 160)
    $p218 = $bmp.GetPixel($x, 218)
    Write-Host ("X=" + $x + " | Y=35: " + $p35.R + "," + $p35.G + "," + $p35.B + " | Y=60: " + $p60.R + "," + $p60.G + "," + $p60.B + " | Y=160: " + $p160.R + "," + $p160.G + "," + $p160.B + " | Y=218: " + $p218.R + "," + $p218.G + "," + $p218.B)
}

$bmp.Dispose()
