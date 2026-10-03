Add-Type -AssemblyName System.Drawing
$uPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790497408227.png"
$cPath = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png"

$u = [System.Drawing.Bitmap]::FromFile($uPath)
$c = [System.Drawing.Bitmap]::FromFile($cPath)

Write-Host "Uploaded: $($u.Width) x $($u.Height) - PixelFormat: $($u.PixelFormat)"
Write-Host "Current:  $($c.Width) x $($c.Height) - PixelFormat: $($c.PixelFormat)"

$u.Dispose()
$c.Dispose()
