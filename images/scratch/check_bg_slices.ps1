Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

# Let's inspect the pixels immediately above the heading (Y=82) and below (Y=160)
Write-Host "Y=82 (above heading):"
for ($x = 35; $x -le 380; $x += 30) {
    $c = $bmp.GetPixel($x, 82)
    Write-Host ("X={0}: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "Y=162 (between heading and paragraph):"
for ($x = 35; $x -le 380; $x += 30) {
    $c = $bmp.GetPixel($x, 162)
    Write-Host ("X={0}: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Host "Y=212 (between paragraph and badges):"
for ($x = 35; $x -le 380; $x += 30) {
    $c = $bmp.GetPixel($x, 212)
    Write-Host ("X={0}: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

$bmp.Dispose()
