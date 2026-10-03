Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

$rect = New-Object System.Drawing.Rectangle(20, 40, 440, 130)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\comp_heading_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$bmp.Dispose()
Write-Host "Heading crop saved!"
