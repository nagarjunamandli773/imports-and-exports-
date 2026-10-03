Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
Write-Host "Uploaded image: $($bmp.Width) x $($bmp.Height)"

# Sample regions
Write-Host "Top-left corner (0,0): $($bmp.GetPixel(0, 0))"
Write-Host "Top-right corner ($($bmp.Width-1),0): $($bmp.GetPixel($bmp.Width-1, 0))"
Write-Host "Bottom-left corner (0,$($bmp.Height-1)): $($bmp.GetPixel(0, $bmp.Height-1))"
Write-Host "Bottom-right corner ($($bmp.Width-1),$($bmp.Height-1)): $($bmp.GetPixel($bmp.Width-1, $bmp.Height-1))"

# Check where the white background begins / ends on left side
# Let's inspect along Y=100
for ($x = 0; $x -lt $bmp.Width; $x += 40) {
    $c = $bmp.GetPixel($x, 100)
    Write-Host "X=$x, Y=100: R=$($c.R), G=$($c.G), B=$($c.B)"
}

$bmp.Dispose()
