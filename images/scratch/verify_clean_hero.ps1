Add-Type -AssemblyName System.Drawing

$p = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_product_hero.png"
$bmp = [System.Drawing.Bitmap]::FromFile($p)
Write-Host "Banner dimensions: $($bmp.Width) x $($bmp.Height)"

Write-Host "Checking bottom-left corner pixels (should be solid navy blue, NOT white!):"
for ($y = $bmp.Height - 60; $y -lt $bmp.Height; $y += 10) {
    $c = $bmp.GetPixel(50, $y)
    Write-Host "Y=$y : R=$($c.R), G=$($c.G), B=$($c.B)"
}

$bmp.Dispose()
