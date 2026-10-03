Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')

Write-Host "Uploaded image: $($img.Width) x $($img.Height)"

# Let's check top edge row by row
for ($y = 0; $y -le 10; $y++) {
    $cMid = $img.GetPixel(300, $y)
    $cLeft = $img.GetPixel(30, $y)
    $cRight = $img.GetPixel(900, $y)
    Write-Host "Row $y : Left=($($cLeft.R),$($cLeft.G),$($cLeft.B)) Mid=($($cMid.R),$($cMid.G),$($cMid.B)) Right=($($cRight.R),$($cRight.G),$($cRight.B))"
}

# Let's check bottom edge row by row
for ($y = $img.Height - 10; $y -lt $img.Height; $y++) {
    $cMid = $img.GetPixel(500, $y)
    $cLeft = $img.GetPixel(30, $y)
    $cRight = $img.GetPixel(900, $y)
    Write-Host "Row $y : Left=($($cLeft.R),$($cLeft.G),$($cLeft.B)) Mid=($($cMid.R),$($cMid.G),$($cMid.B)) Right=($($cRight.R),$($cRight.G),$($cRight.B))"
}

# Let's check left edge col by col
for ($x = 0; $x -le 10; $x++) {
    $c = $img.GetPixel($x, 70)
    Write-Host "Col $x : ($($c.R),$($c.G),$($c.B))"
}

# Let's check right edge col by col
for ($x = $img.Width - 10; $x -lt $img.Width; $x++) {
    $c = $img.GetPixel($x, 70)
    Write-Host "Col $x : ($($c.R),$($c.G),$($c.B))"
}

$img.Dispose()
