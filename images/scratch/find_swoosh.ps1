Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

Write-Host "--- Scanning Golden Swoosh at bottom left ---"
for ($y = 280; $y -lt $bmp.Height; $y += 5) {
    for ($x = 0; $x -lt 200; $x += 5) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 220 -and $c.G -gt 160 -and $c.B -lt 100) {
            Write-Host ("Swoosh pixel at ({0}, {1}): R={2} G={3} B={4}" -f $x, $y, $c.R, $c.G, $c.B)
            break
        }
    }
}
$bmp.Dispose()
