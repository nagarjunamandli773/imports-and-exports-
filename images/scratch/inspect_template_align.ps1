Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg')

Write-Host "Template size: $($img.Width) x $($img.Height)"

# Check background color outside the banner (e.g. at (10, 10), (10, 50), (2, 2))
Write-Host "Corner (2, 2): $($img.GetPixel(2, 2))"
Write-Host "Margin left (10, 100): $($img.GetPixel(10, 100))"

# Check where the banner starts and ends horizontally around y=50
for ($x = 0; $x -lt 40; $x++) {
    $c = $img.GetPixel($x, 50)
    Write-Host "x=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

Write-Host "--- Banner right edge around y=50 ---"
for ($x = $img.Width - 40; $x -lt $img.Width; $x++) {
    $c = $img.GetPixel($x, 50)
    if ($x % 5 -eq 0 -or $x -gt $img.Width - 10) {
        Write-Host "x=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
    }
}

# Check where the sidebar starts around y=250
Write-Host "--- Sidebar left edge around y=250 ---"
for ($x = 0; $x -lt 40; $x++) {
    $c = $img.GetPixel($x, 250)
    Write-Host "x=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

# Check bottom of banner around x=500
Write-Host "--- Banner bottom edge around x=500 ---"
for ($y = 120; $y -lt 165; $y++) {
    $c = $img.GetPixel(500, $y)
    Write-Host "y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
}

$img.Dispose()
