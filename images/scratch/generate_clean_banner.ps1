Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')

# Precise crop:
# x: 0 to 1023 (width 1024)
# y: 6 to 157 (height 152)
$cropRect = New-Object System.Drawing.Rectangle(0, 6, 1023, 152)
$cropped = $src.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Save 1x clean crop
$cropped.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\banner_1x.png")

# Upscale to 2x (2046 x 304) and 3x (3069 x 456) using high quality bicubic
$scale = 3
$w3 = 1023 * $scale
$h3 = 152 * $scale
$scaled3 = New-Object System.Drawing.Bitmap($w3, $h3, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($scaled3)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.DrawImage($cropped, 0, 0, $w3, $h3)
$g.Dispose()

$scaled3.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\banner_3x.png")

Write-Host "Created banner_1x.png and banner_3x.png ($w3 x $h3)"

$cropped.Dispose()
$scaled3.Dispose()
$src.Dispose()
