Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

Write-Host "--- Scanning between heading and world map (X=360..450, Y=70..150) ---"
for ($y = 70; $y -le 150; $y += 10) {
    for ($x = 360; $x -le 460; $x += 10) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 240 -or $c.G -lt 240 -or $c.B -lt 240) {
            Write-Host ("Graphic pixel at ({0}, {1}): R={2} G={3} B={4}" -f $x, $y, $c.R, $c.G, $c.B)
            break
        }
    }
}
$bmp.Dispose()
