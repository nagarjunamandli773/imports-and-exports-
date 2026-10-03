Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

# Clean crop: remove top white bar (y=0..5) and bottom page edge (y>=158)
$cropX = 0
$cropY = 6
$cropW = 1023
$cropH = 152

$cropRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$cropped = $src.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Upscale by 4x for Ultra-HD 4K fidelity (4092 x 608)
$scale = 4
$targetW = $cropW * $scale
$targetH = $cropH * $scale

$masterBmp = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($masterBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

$g.DrawImage($cropped, 0, 0, $targetW, $targetH)
$g.Dispose()

# Save to both target locations
$outPath1 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png"
$outPath2 = "c:\Users\Administrator\Pictures\emports and exports\images\product_hero_banner.png"

$masterBmp.Save($outPath1, [System.Drawing.Imaging.ImageFormat]::Png)
$masterBmp.Save($outPath2, [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "Successfully generated 4K master banner: $targetW x $targetH"
Write-Host "Saved to: $outPath1"
Write-Host "Saved to: $outPath2"

$masterBmp.Dispose()
$cropped.Dispose()
$src.Dispose()
