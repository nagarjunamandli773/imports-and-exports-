Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png')
Write-Host "product_hero_banner.png size: $($img.Width) x $($img.Height)"

# Check bottom-left corner at x=100, y=$($img.Height - 30)
$c1 = $img.GetPixel(100, $img.Height - 30)
Write-Host "product_hero_banner.png bottom-left (100, Height-30): R=$($c1.R), G=$($c1.G), B=$($c1.B), A=$($c1.A)"

# Check top-left corner
$c2 = $img.GetPixel(20, 20)
Write-Host "product_hero_banner.png top-left (20, 20): R=$($c2.R), G=$($c2.G), B=$($c2.B), A=$($c2.A)"

# Check background color around text
$c3 = $img.GetPixel(500, 300)
Write-Host "product_hero_banner.png text area (500, 300): R=$($c3.R), G=$($c3.G), B=$($c3.B), A=$($c3.A)"

# Check top edge
$cTop = $img.GetPixel(1000, 2)
Write-Host "product_hero_banner.png top edge (1000, 2): R=$($cTop.R), G=$($cTop.G), B=$($cTop.B), A=$($cTop.A)"

# Check bottom edge
$cBot = $img.GetPixel(1000, $img.Height - 2)
Write-Host "product_hero_banner.png bottom edge (1000, Height-2): R=$($cBot.R), G=$($cBot.G), B=$($cBot.B), A=$($cBot.A)"

$img.Dispose()
