Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\orig_hero_raw.jpg")
Write-Host "Width: $($bmp.Width) Height: $($bmp.Height)"

# Crop the quote area (x: 840 to 1020, y: 10 to 135)
$rect = New-Object System.Drawing.Rectangle(840, 5, 180, 135)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\quote_area.jpg")

$bmp.Dispose()
$crop.Dispose()
