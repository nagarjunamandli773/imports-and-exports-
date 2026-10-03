Add-Type -AssemblyName System.Drawing

$s = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png")
Write-Host "Services banner bottom-left (50, $($s.Height - 10)): $($s.GetPixel(50, $s.Height - 10))"
$s.Dispose()

$c = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png")
Write-Host "Compliance banner bottom-left (50, $($c.Height - 10)): $($c.GetPixel(50, $c.Height - 10))"
$c.Dispose()
