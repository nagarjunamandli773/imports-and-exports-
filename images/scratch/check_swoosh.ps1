Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')

Write-Host "Inspecting y values around swoosh:"
for ($x = 65; $x -le 165; $x += 20) {
    for ($y = 90; $y -le 118; $y += 2) {
        $c = $src.GetPixel($x, $y)
        if ($c.R -gt 160 -and $c.G -gt 120 -and $c.B -lt 110) {
            Write-Host "Gold at x=$x, y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
        }
    }
}

$src.Dispose()
