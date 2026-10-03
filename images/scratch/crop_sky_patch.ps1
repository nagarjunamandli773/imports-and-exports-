Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg")
$rect = New-Object System.Drawing.Rectangle(760, 0, 105, 105)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\clean_sky_patch.jpg")

$bmp.Dispose()
$crop.Dispose()
Write-Host "Saved clean_sky_patch.jpg"
