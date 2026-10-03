Add-Type -AssemblyName System.Drawing

$b = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')
for ($x = 135; $x -le 145; $x++) {
    for ($y = 25; $y -le 35; $y++) {
        $c = $b.GetPixel($x, $y)
        if ($c.R -gt 150) {
            Write-Host "x=$x, y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
        }
    }
}
$b.Dispose()
