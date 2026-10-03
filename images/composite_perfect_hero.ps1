Add-Type -AssemblyName System.Drawing

$bannerSrc = "c:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
$cleanRightSrc = "c:\Users\Administrator\Pictures\emports and exports\images\hero_collage_crop.jpg"

$bmpBanner = [System.Drawing.Bitmap]::FromFile($bannerSrc)
$bmpClean = [System.Drawing.Bitmap]::FromFile($cleanRightSrc)

Write-Host "Banner dimensions: $($bmpBanner.Width) x $($bmpBanner.Height)"
Write-Host "Clean visual dimensions: $($bmpClean.Width) x $($bmpClean.Height)"

# Crop the banner top section (0, 0, 1020, 144)
$w = [int]$bmpBanner.Width - 4
$h = 144
$bannerRect = New-Object System.Drawing.Rectangle(2, 2, $w, $h)
$heroBmp = $bmpBanner.Clone($bannerRect, $bmpBanner.PixelFormat)

# We want to replace the right region of $heroBmp (specifically the sky and cranes where the text was: x >= 850, y from 0 to 120)
# using the clean pixels from $bmpClean!
# Let's find the scale factor between $bmpClean and $heroBmp:
# In $bmpClean, width is 620, height is 252 (or similar)
# Let's scale $bmpClean to match the height of $heroBmp or match feature alignment (the crane top and airplane position)

Write-Host "Clean visual aspect ratio: $([double]$bmpClean.Width / $bmpClean.Height)"

$bmpBanner.Dispose()
$bmpClean.Dispose()
$heroBmp.Dispose()
