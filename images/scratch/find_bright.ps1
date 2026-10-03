Add-Type -AssemblyName System.Drawing

$b = [System.Drawing.Bitmap]::FromFile('images\scratch\test_precise_inpaint.png')
for ($x = 100; $x -lt $b.Width; $x++) {
    for ($y = 10; $y -lt 50; $y++) {
        $c = $b.GetPixel($x, $y)
        if ($c.R -gt 150 -or $c.G -gt 150 -or $c.B -gt 180) {
            Write-Host "Bright pixel at x=$x, y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
        }
    }
}
$b.Dispose()
