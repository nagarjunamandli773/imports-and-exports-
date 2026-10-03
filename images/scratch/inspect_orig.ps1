Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
Write-Host "Original dimensions: $($bmp.Width) x $($bmp.Height)"

# Inspect row 120 (badge row) from X=300 to 440
Write-Host "Row 120 (badges):"
for ($x = 300; $x -le 440; $x += 10) {
    $c = $bmp.GetPixel($x, 120)
    Write-Host "X=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

# Inspect row 80 (paragraph row) from X=300 to 440
Write-Host "Row 80 (paragraph):"
for ($x = 300; $x -le 440; $x += 10) {
    $c = $bmp.GetPixel($x, 80)
    Write-Host "X=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

# Inspect row 110 (capsule region) from X=730 to 1010
Write-Host "Row 110 (capsule):"
for ($x = 730; $x -le 1000; $x += 20) {
    $c = $bmp.GetPixel($x, 110)
    Write-Host "X=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

$bmp.Dispose()
