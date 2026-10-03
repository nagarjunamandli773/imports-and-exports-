Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png")

for ($x = 0; $x -le 160; $x += 10) {
    for ($y = 280; $y -lt $bmp.Height; $y++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 220 -and $c.G -gt 160 -and $c.B -lt 120) {
            Write-Host ("X={0}: Top of swoosh at Y={1}" -f $x, $y)
            break
        }
    }
}
$bmp.Dispose()
