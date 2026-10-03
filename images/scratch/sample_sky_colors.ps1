Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790300743947.png')

Write-Host "Width: $($src.Width), Height: $($src.Height)"

Write-Host "Sample pixels above text (y=5):"
foreach ($x in @(860, 880, 900, 920, 940, 960, 980, 1000, 1020)) {
    $c = $src.GetPixel($x, 5)
    Write-Host "x=$x, y=5 : R=$($c.R), G=$($c.G), B=$($c.B)"
}

Write-Host "Sample pixels right edge (x=1020):"
foreach ($y in @(5, 20, 40, 60, 80, 100)) {
    $c = $src.GetPixel(1020, $y)
    Write-Host "x=1020, y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
}

Write-Host "Sample pixels between crane and text (x=845):"
foreach ($y in @(5, 20, 40, 60, 80, 95)) {
    $c = $src.GetPixel(845, $y)
    Write-Host "x=845, y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
}

$src.Dispose()
