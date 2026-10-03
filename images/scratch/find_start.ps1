Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('C:\Users\Administrator\.gemini\antigravity-ide\brain\984eced1-f394-4a1f-bcf5-919d9d5f0246\.user_uploaded\media_1790328141521.png')

# Find first non-white pixel in screenshot
$firstX = -1
for ($x = 0; $x -lt 50; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.R -lt 240 -or $p.G -lt 240 -or $p.B -lt 240) {
            $firstX = $x
            break
        }
    }
    if ($firstX -ne -1) { break }
}
Write-Host "First non-white pixel in screenshot is at x=$firstX"

# Find C in CONCEPT
for ($x = 30; $x -lt 70; $x += 5) {
    Write-Host "x=$x"
}
$bmp.Dispose()
