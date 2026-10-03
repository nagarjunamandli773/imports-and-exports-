Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg")
$rect = New-Object System.Drawing.Rectangle(860, 0, 164, 140)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_quote_area.jpg")

$bmp.Dispose()
$crop.Dispose()
Write-Host "Saved service_quote_area.jpg"
