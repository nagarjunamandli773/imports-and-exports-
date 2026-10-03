Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

for ($x = 20; $x -le 350; $x += 20) {
    for ($y = 60; $y -le 220; $y += 20) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.R -lt 250) {
            Write-Host "($x, $y): R=$($p.R) G=$($p.G) B=$($p.B)"
        }
    }
}

$bmp.Dispose()
