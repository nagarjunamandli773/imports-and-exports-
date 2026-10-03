Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Finding gold circles around Y=115-125..."
# Gold color has high R (~200+), high G (~170+), lower B (~50-90)
for ($x = 20; $x -lt 450; $x++) {
    for ($y = 110; $y -lt 130; $y++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 180 -and $c.G -gt 150 -and $c.B -lt 100) {
            Write-Host "Gold pixel at X=$x, Y=$y : R=$($c.R) G=$($c.G) B=$($c.B)"
            break
        }
    }
}

$bmp.Dispose()
