Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')

Write-Host "Image size: $($img.Width) x $($img.Height)"

# Let's inspect column 500 (middle of the image) vertically from y=0 to y=159:
for ($y = 0; $y -lt $img.Height; $y++) {
    $c = $img.GetPixel(500, $y)
    if ($y -lt 15 -or $y -gt ($img.Height - 15)) {
        Write-Host "y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
    }
}

# Let's inspect column 50 (left side) vertically:
Write-Host "--- Column 50 (left) ---"
for ($y = 0; $y -lt $img.Height; $y++) {
    $c = $img.GetPixel(50, $y)
    if ($y -lt 15 -or $y -gt ($img.Height - 15)) {
        Write-Host "y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
    }
}

# Let's inspect row 80 (middle horizontal line) horizontally:
Write-Host "--- Left edge at row 80 ---"
for ($x = 0; $x -lt 25; $x++) {
    $c = $img.GetPixel($x, 80)
    Write-Host "x=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

Write-Host "--- Right edge at row 80 ---"
for ($x = $img.Width - 25; $x -lt $img.Width; $x++) {
    $c = $img.GetPixel($x, 80)
    Write-Host "x=$x : R=$($c.R), G=$($c.G), B=$($c.B)"
}

$img.Dispose()
