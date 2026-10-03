Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png")
Write-Host "Width: $($b.Width) Height: $($b.Height)"
Write-Host "Left background color (10, 10): $($b.GetPixel(10, 10))"
Write-Host "Left background color (20, 50): $($b.GetPixel(20, 50))"
Write-Host "Left background color (50, 100): $($b.GetPixel(50, 100))"
Write-Host "Center-left boundary (350, 75): $($b.GetPixel(350, 75))"
Write-Host "Scientist start (420, 75): $($b.GetPixel(420, 75))"
Write-Host "Bottom curve (10, 140): $($b.GetPixel(10, 140))"
Write-Host "Bottom curve (500, 150): $($b.GetPixel(500, 150))"
$b.Dispose()
