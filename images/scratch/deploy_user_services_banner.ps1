Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790497408227.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# 1. Save original 1x copy
$bmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner_user_1x.png", [System.Drawing.Imaging.ImageFormat]::Png)

# 2. Generate 4K Ultra-Sharp Master Banner (4096 x 1364)
$targetW = 4096
$targetH = [int]($bmp.Height * ($targetW / $bmp.Width)) # 1364

$hires = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($hires)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

$g.DrawImage($bmp, 0, 0, $targetW, $targetH)

# Deploy to all destinations used by the site
$outPath1 = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png"
$outPath2 = "c:\Users\Administrator\Pictures\emports and exports\images\services_hero_banner.png"
$outJpg1  = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.jpg"
$outJpg2  = "c:\Users\Administrator\Pictures\emports and exports\images\services_hero_banner.jpg"

$hires.Save($outPath1, [System.Drawing.Imaging.ImageFormat]::Png)
$hires.Save($outPath2, [System.Drawing.Imaging.ImageFormat]::Png)

# Also save high-quality JPEG fallbacks
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$hires.Save($outJpg1, $jpegCodec, $encoderParams)
$hires.Save($outJpg2, $jpegCodec, $encoderParams)

# Also save a 1200px artifact preview
$artifactPreview = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\services_hero_banner_preview.png"
$prevW = 1200
$prevH = [int]($bmp.Height * ($prevW / $bmp.Width))
$prevBmp = New-Object System.Drawing.Bitmap($prevW, $prevH)
$prevG = [System.Drawing.Graphics]::FromImage($prevBmp)
$prevG.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$prevG.DrawImage($bmp, 0, 0, $prevW, $prevH)
$prevBmp.Save($artifactPreview, [System.Drawing.Imaging.ImageFormat]::Png)

$prevG.Dispose()
$prevBmp.Dispose()
$g.Dispose()
$hires.Dispose()
$bmp.Dispose()

Write-Host "Services hero banner successfully deployed!"
