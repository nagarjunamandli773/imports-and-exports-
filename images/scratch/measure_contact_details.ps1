Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "--- Scanning Gold line under GET IN TOUCH ---"
for ($y = 65; $y -le 85; $y++) {
    for ($x = 25; $x -le 180; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 210 -and $c.G -gt 150 -and $c.B -lt 80) {
            Write-Host "Gold line found at ($($x), $($y)): R=$($c.R) G=$($c.G) B=$($c.B)"
            break
        }
    }
}

Write-Host "--- Heading We're Here to (y: 80..130) ---"
$sampleDark = $bmp.GetPixel(75, 105)
Write-Host "Heading Navy Color at (75, 105): R=$($sampleDark.R) G=$($sampleDark.G) B=$($sampleDark.B)"

$sampleGold = $bmp.GetPixel(150, 138)
Write-Host "Heading Gold Color at (150, 138): R=$($sampleGold.R) G=$($sampleGold.G) B=$($sampleGold.B)"

$samplePara = $bmp.GetPixel(60, 175)
Write-Host "Paragraph text color around (60, 175): R=$($samplePara.R) G=$($samplePara.G) B=$($samplePara.B)"

Write-Host "--- Badges vertical dividers ---"
for ($x = 90; $x -le 130; $x++) {
    $c = $bmp.GetPixel($x, 260)
    if ($c.R -lt 240 -and [Math]::Abs($c.R - $c.G) -lt 10 -and [Math]::Abs($c.G - $c.B) -lt 10) {
        Write-Host "Divider 1 near X=$($x): R=$($c.R) G=$($c.G) B=$($c.B)"
    }
}
for ($x = 200; $x -le 240; $x++) {
    $c = $bmp.GetPixel($x, 260)
    if ($c.R -lt 240 -and [Math]::Abs($c.R - $c.G) -lt 10 -and [Math]::Abs($c.G - $c.B) -lt 10) {
        Write-Host "Divider 2 near X=$($x): R=$($c.R) G=$($c.G) B=$($c.B)"
    }
}
for ($x = 300; $x -le 340; $x++) {
    $c = $bmp.GetPixel($x, 260)
    if ($c.R -lt 240 -and [Math]::Abs($c.R - $c.G) -lt 10 -and [Math]::Abs($c.G - $c.B) -lt 10) {
        Write-Host "Divider 3 near X=$($x): R=$($c.R) G=$($c.G) B=$($c.B)"
    }
}

$bmp.Dispose()
