Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')

Write-Host "Inspecting x=65..75, y=98..110 in service_quote_crop.png:"
for ($x = 65; $x -le 75; $x++) {
    for ($y = 98; $y -le 110; $y++) {
        $c = $src.GetPixel($x, $y)
        Write-Host "x=$x, y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
    }
}

$src.Dispose()
