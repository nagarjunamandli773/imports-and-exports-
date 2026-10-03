Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\984eced1-f394-4a1f-bcf5-919d9d5f0246\.user_uploaded\media_1790331452802.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
Write-Host "Uploaded screenshot: $($bmp.Width) x $($bmp.Height)"

Write-Host "Left boundary (Y=50):"
for ($x = 0; $x -lt 10; $x++) {
    $c = $bmp.GetPixel($x, 50)
    Write-Host "X=$x : R=$($c.R) G=$($c.G) B=$($c.B)"
}

Write-Host "Right boundary (Y=50):"
for ($x = $bmp.Width - 10; $x -lt $bmp.Width; $x++) {
    $c = $bmp.GetPixel($x, 50)
    Write-Host "X=$x : R=$($c.R) G=$($c.G) B=$($c.B)"
}

$bmp.Dispose()
