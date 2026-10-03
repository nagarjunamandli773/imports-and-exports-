Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

Write-Host "--- Scanning original image Y=100 (X=300..450) ---"
for ($x = 320; $x -le 440; $x += 10) {
    $c = $bmp.GetPixel($x, 100)
    Write-Host ("X={0}: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "--- Scanning original image Y=140 (X=350..450) ---"
for ($x = 350; $x -le 440; $x += 5) {
    $c = $bmp.GetPixel($x, 140)
    Write-Host ("X={0}: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "--- Scanning original image Y=180 (X=350..450) ---"
for ($x = 350; $x -le 440; $x += 10) {
    $c = $bmp.GetPixel($x, 180)
    Write-Host ("X={0}: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

$bmp.Dispose()
