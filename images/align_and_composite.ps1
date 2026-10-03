Add-Type -AssemblyName System.Drawing

$bannerSrc = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$cleanSrc = "c:\Users\Administrator\Pictures\emports and exports\images\hero_collage_crop.jpg"

$bmpBanner = [System.Drawing.Bitmap]::FromFile($bannerSrc)
$bmpClean = [System.Drawing.Bitmap]::FromFile($cleanSrc)

# 1. Base banner cropped top (1020 x 144)
$w = [int]$bmpBanner.Width - 4
$h = 144
$bannerRect = New-Object System.Drawing.Rectangle(2, 2, $w, $h)
$resultBmp = $bmpBanner.Clone($bannerRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# 2. Resize $bmpClean so its features match the scale of $resultBmp
# In $bmpBanner, the ship width is approx 200px (from x=535 to 735), total banner height is 144.
# In $bmpClean, the ship width is approx 195px (from x=155 to 350), total height is 225.
# So $bmpClean scale factor = 144 / 160 = 0.90 (approx) or let's resize to match height of the panorama:
# Let's scale $bmpClean to height = 150
$scale = 144.0 / 225.0
$scaledW = [int]($bmpClean.Width * $scale * 1.05)
$scaledH = 144

$scaledClean = New-Object System.Drawing.Bitmap($scaledW, $scaledH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gScale = [System.Drawing.Graphics]::FromImage($scaledClean)
$gScale.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gScale.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gScale.DrawImage($bmpClean, 0, 0, $scaledW, $scaledH)
$gScale.Dispose()

# Save scaledClean for inspection
$scaledClean.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\scaled_clean_preview.jpg")

Write-Host "Scaled clean size: $scaledW x $scaledH"

# We want the right side of $scaledClean (from x = $scaledW - 170 to $scaledW)
# to overlay on the right side of $resultBmp (from x = $w - 170 to $w)
$destStartX = $w - 175
$srcStartX = $scaledW - 175

$gResult = [System.Drawing.Graphics]::FromImage($resultBmp)
$gResult.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Blend the right sky and cranes with horizontal alpha feathering
for ($x = 0; $x -lt 175; $x++) {
    $alpha = 1.0
    if ($x -lt 25) {
        $alpha = $x / 25.0 # Smooth blend on the left seam
    }
    
    $dx = $destStartX + $x
    $sx = $srcStartX + $x
    
    if ($dx -lt $w -and $sx -lt $scaledW) {
        for ($y = 0; $y -lt 115; $y++) {
            $cSrc = $scaledClean.GetPixel($sx, $y)
            $cDest = $resultBmp.GetPixel($dx, $y)
            
            # Blend
            $r = [int]($cDest.R * (1.0 - $alpha) + $cSrc.R * $alpha)
            $g = [int]($cDest.G * (1.0 - $alpha) + $cSrc.G * $alpha)
            $b = [int]($cDest.B * (1.0 - $alpha) + $cSrc.B * $alpha)
            
            $resultBmp.SetPixel($dx, $y, [System.Drawing.Color]::FromArgb(255, $r, $g, $b))
        }
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$destPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$resultBmp.Save($destPath, $jpegCodec, $encoderParams)
$resultBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg", $jpegCodec, $encoderParams)

$bmpBanner.Dispose()
$bmpClean.Dispose()
$scaledClean.Dispose()
$resultBmp.Dispose()
$gResult.Dispose()

Write-Host "Compositing complete!"
