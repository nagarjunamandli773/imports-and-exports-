Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Crop the capsule region X=730 to 1019, Y=80 to 155
$rect = New-Object System.Drawing.Rectangle(730, 80, 289, 75)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\capsule_orig.png", [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$bmp.Dispose()
Write-Host "Saved capsule_orig.png"
