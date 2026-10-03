Add-Type -AssemblyName System.Drawing

$p = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($p)
Write-Host "media_1789971937755.jpg size: $($bmp.Width) x $($bmp.Height)"

# Let's save a thumbnail or inspect what is in this image
# Check Y ranges
for ($y = 0; $y -lt $bmp.Height; $y += 50) {
    $c = $bmp.GetPixel(50, $y)
    Write-Host "Y=$y : $($c.R), $($c.G), $($c.B)"
}

$bmp.Dispose()
