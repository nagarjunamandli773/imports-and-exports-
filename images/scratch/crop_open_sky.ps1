Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg")
$rect = New-Object System.Drawing.Rectangle(360, 0, 180, 110)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\open_sky_patch.jpg")

$bmp.Dispose()
$crop.Dispose()
Write-Host "Saved open_sky_patch.jpg"
