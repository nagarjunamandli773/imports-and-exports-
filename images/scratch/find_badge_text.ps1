Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

for ($y = 260; $y -le 315; $y++) {
    $darkCount = 0
    for ($x = 25; $x -le 115; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 100 -and $c.G -lt 100 -and $c.B -lt 100) {
            $darkCount++
        }
    }
    if ($darkCount -gt 5) {
        Write-Host "Dark text pixels found at Y=$y (count=$darkCount)"
    }
}
$bmp.Dispose()
