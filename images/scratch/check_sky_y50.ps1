Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

for ($x = 150; $x -le 450; $x += 15) {
    $c = $bmp.GetPixel($x, 50)
    Write-Host ("X={0}, Y=50: R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}
$bmp.Dispose()
