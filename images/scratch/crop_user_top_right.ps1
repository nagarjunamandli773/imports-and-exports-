Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\984eced1-f394-4a1f-bcf5-919d9d5f0246\.user_uploaded\media_1790331452802.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
Write-Host "Uploaded screenshot size: $($bmp.Width) x $($bmp.Height)"

# Crop top right region X: 800 to 1024, Y: 0 to 150
$rect = New-Object System.Drawing.Rectangle(800, 0, ($bmp.Width - 800), [Math]::Min(150, $bmp.Height))
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$crop.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\user_top_right.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$bmp.Dispose()
Write-Host "Saved user_top_right.png"
