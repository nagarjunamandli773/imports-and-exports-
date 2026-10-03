Add-Type -AssemblyName System.Drawing

$flawless = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_flawless.png')
$rect = New-Object System.Drawing.Rectangle(($flawless.Width - 800), 0, 800, 400)
$crop = $flawless.Clone($rect, $flawless.PixelFormat)
$crop.Save('images\scratch\flawless_right_crop.png')
$flawless.Dispose()
$crop.Dispose()
Write-Host "Crop saved"
