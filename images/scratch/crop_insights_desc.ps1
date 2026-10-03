Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790503971818.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Uploaded size: $($bmp.Width) x $($bmp.Height)"

# Crop paragraph area: x: 25 to 450, y: 170 to 230
$rect = New-Object System.Drawing.Rectangle(25, 170, 430, 60)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\insights_desc_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$bmp.Dispose()
Write-Host "Insights desc crop saved!"
