Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Finding scientist boundary around X=400-450, Y=50-140:"
for ($y = 60; $y -le 140; $y += 20) {
    Write-Host "--- Y = $y ---"
    for ($x = 400; $x -le 450; $x += 5) {
        $c = $bmp.GetPixel($x, $y)
        Write-Host "X=$x : R=$($c.R) G=$($c.G) B=$($c.B)"
    }
}
$bmp.Dispose()
