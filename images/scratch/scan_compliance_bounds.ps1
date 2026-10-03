Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Check vertical bounds of text on left:
# Let's inspect column X = 50 for non-white pixels (where text is)
Write-Host "Scanning column X=50 for text bounds:"
for ($y = 0; $y -lt 341; $y += 5) {
    $p = $bmp.GetPixel(50, $y)
    $lum = ($p.R + $p.G + $p.B) / 3.0
    if ($lum -lt 240) {
        Write-Host ("Text found at Y=" + $y + ": R=" + $p.R + " G=" + $p.G + " B=" + $p.B + " Lum=" + $lum)
    }
}

# Check where the scientist image begins by scanning Y=150 from X=400 to 600
Write-Host "`nScanning row Y=150 from X=400 to 600:"
for ($x = 400; $x -le 600; $x += 20) {
    $p = $bmp.GetPixel($x, 150)
    Write-Host "X=$x : R=$($p.R) G=$($p.G) B=$($p.B)"
}

# Check where the badges end horizontally:
Write-Host "`nScanning row Y=280 from X=300 to 600:"
for ($x = 300; $x -le 600; $x += 25) {
    $p = $bmp.GetPixel($x, 280)
    Write-Host "X=$x : R=$($p.R) G=$($p.G) B=$($p.B)"
}

$bmp.Dispose()
