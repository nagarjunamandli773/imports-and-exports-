Add-Type -AssemblyName System.Drawing
$b1 = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\0921fc65-e3f3-491a-9881-1d5b2c7e09fa\.user_uploaded\media_1790412093581.png')
$b2 = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png')
Write-Host "b1 size: $($b1.Width)x$($b1.Height)"
Write-Host "b2 size: $($b2.Width)x$($b2.Height)"
Write-Host "b1 top-left (50, 50): $($b1.GetPixel(50, 50))"
Write-Host "b2 top-left (200, 200): $($b2.GetPixel(200, 200))"
Write-Host "b1 ship hull (450, 130): $($b1.GetPixel(450, 130))"
Write-Host "b2 ship hull (1800, 500): $($b2.GetPixel(1800, 500))"
Write-Host "b1 right card (900, 100): $($b1.GetPixel(900, 100))"
Write-Host "b2 right card (3600, 400): $($b2.GetPixel(3600, 400))"
$b1.Dispose()
$b2.Dispose()
