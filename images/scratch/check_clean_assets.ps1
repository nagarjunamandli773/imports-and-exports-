Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\hero_visual_clean.jpg")
Write-Host "hero_visual_clean Width: $($img.Width) Height: $($img.Height)"
$img.Dispose()

$img2 = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\about_hero_clean.jpg")
Write-Host "about_hero_clean Width: $($img2.Width) Height: $($img2.Height)"
$img2.Dispose()
