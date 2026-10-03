Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Finding capsule top border around X=800, Y=80-110:"
for ($y = 85; $y -le 110; $y++) {
    $c = $bmp.GetPixel(850, $y)
    Write-Host "Y=$y : R=$($c.R) G=$($c.G) B=$($c.B)"
}

Write-Host "`nFinding capsule bottom border around X=850, Y=135-155:"
for ($y = 135; $y -le 153; $y++) {
    $c = $bmp.GetPixel(850, $y)
    Write-Host "Y=$y : R=$($c.R) G=$($c.G) B=$($c.B)"
}

Write-Host "`nFinding capsule left border around Y=120, X=720-760:"
for ($x = 720; $x -le 760; $x += 2) {
    $c = $bmp.GetPixel($x, 120)
    Write-Host "X=$x : R=$($c.R) G=$($c.G) B=$($c.B)"
}

Write-Host "`nFinding capsule right border around Y=120, X=970-1010:"
for ($x = 970; $x -le 1015; $x += 2) {
    $c = $bmp.GetPixel($x, 120)
    Write-Host "X=$x : R=$($c.R) G=$($c.G) B=$($c.B)"
}

$bmp.Dispose()
