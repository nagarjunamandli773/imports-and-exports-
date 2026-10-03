Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$b = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Scanning compliance 1x..."

# Scan vertical profile of text in left area X: 20 to 450
for ($y = 0; $y -lt 341; $y += 5) {
    $dark = 0
    for ($x = 20; $x -lt 450; $x++) {
        $p = $b.GetPixel($x, $y)
        if ($p.R -lt 225 -or ($p.R -gt 210 -and $p.B -lt 160)) {
            $dark++
        }
    }
    if ($dark -gt 5) {
        Write-Host "Y=$y has $dark colored pixels"
    }
}

# Scan horizontal boundary where the scientist starts
for ($x = 420; $x -le 600; $x += 10) {
    $p = $b.GetPixel($x, 150)
    Write-Host "X=$x, Y=150 -> R=$($p.R), G=$($p.G), B=$($p.B)"
}

$b.Dispose()
