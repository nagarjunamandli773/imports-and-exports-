Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png"
$dest = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\new_products_hero_banner_preview.png"

$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = [Math]::Min(2400, $bmp.Width)
$rect = New-Object System.Drawing.Rectangle(0, 0, $w, $bmp.Height)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)

# Scale down to 1200x306 for crisp artifact preview display
$scaleW = 1200
$scaleH = [int]($bmp.Height * ($scaleW / $w))
$preview = New-Object System.Drawing.Bitmap($scaleW, $scaleH)
$g = [System.Drawing.Graphics]::FromImage($preview)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($crop, 0, 0, $scaleW, $scaleH)

$preview.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$preview.Dispose()
$crop.Dispose()
$bmp.Dispose()

Write-Host "Preview generated successfully at $dest"
