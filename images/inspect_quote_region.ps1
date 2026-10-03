Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Image size: $($bmp.Width) x $($bmp.Height)"

# Let's crop just the quote area to see exact coordinates
$w = 170
$h = 130
$x = $bmp.Width - $w
$y = 0

$quoteRect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
$quoteBmp = $bmp.Clone($quoteRect, $bmp.PixelFormat)

$quoteBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\quote_region_preview.jpg")

$quoteBmp.Dispose()
$bmp.Dispose()

Write-Host "Saved quote region preview from x=$x, y=$y, w=$w, h=$h"
