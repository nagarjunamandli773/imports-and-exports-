Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Let's crop the text region:
# Heading is around y = 80 to 170, x = 30 to 450
# Paragraph is around y = 170 to 230, x = 30 to 450
$rect = New-Object System.Drawing.Rectangle(25, 160, 430, 75)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\comp_desc_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$bmp.Dispose()
Write-Host "Crop saved!"
