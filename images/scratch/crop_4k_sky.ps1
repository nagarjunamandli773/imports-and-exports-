Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\hero_banner.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$rect = New-Object System.Drawing.Rectangle(800, 30, 450, 250)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\sky_sample_4k.jpg")

$bmp.Dispose()
$crop.Dispose()
Write-Host "Saved sky_sample_4k.jpg"
