Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
if (-not (Test-Path $src)) {
    $src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
}

$bmp = [System.Drawing.Bitmap]::FromFile($src)
Write-Host "Source image: $src"
Write-Host "Width: $($bmp.Width), Height: $($bmp.Height)"

# Check pixel colors at different points on left side
Write-Host "Top-left (10, 10): $($bmp.GetPixel(10, 10))"
Write-Host "Eyebrow area (30, 30): $($bmp.GetPixel(30, 30))"
Write-Host "Heading area (30, 70): $($bmp.GetPixel(30, 70))"
Write-Host "Paragraph area (30, 180): $($bmp.GetPixel(30, 180))"
Write-Host "Badges area (30, 260): $($bmp.GetPixel(30, 260))"
Write-Host "Scientist start X area (500, 150): $($bmp.GetPixel(500, 150))"
Write-Host "Far right (900, 150): $($bmp.GetPixel(900, 150))"

$bmp.Dispose()
