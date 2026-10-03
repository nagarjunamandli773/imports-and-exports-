Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

Write-Host "--- Y=100 around Connect With You right edge ---"
for ($x = 350; $x -le 450; $x += 15) {
    $c = $bmp.GetPixel($x, 100)
    Write-Host ("X={0}, Y=100: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "--- Y=140 around Connect With You right edge ---"
for ($x = 350; $x -le 450; $x += 15) {
    $c = $bmp.GetPixel($x, 140)
    Write-Host ("X={0}, Y=140: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "--- Y=200 around Paragraph right edge ---"
for ($x = 380; $x -le 480; $x += 15) {
    $c = $bmp.GetPixel($x, 200)
    Write-Host ("X={0}, Y=200: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "--- Y=240 around Badge 4 right edge ---"
for ($x = 420; $x -le 500; $x += 15) {
    $c = $bmp.GetPixel($x, 240)
    Write-Host ("X={0}, Y=240: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}
$bmp.Dispose()
