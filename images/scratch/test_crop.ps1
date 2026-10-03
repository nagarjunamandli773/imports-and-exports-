Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

# The user image is 1024 x 160.
# Let's inspect the exact crop:
# Top: row 4 is antialias, row 5 is 100% banner navy.
# Bottom: row 156 is gold border, row 157 is highlight.
$cropX = 0
$cropY = 4
$cropW = $src.Width
$cropH = 153 # from y=4 to y=156 inclusive

Write-Host "Cropping ($cropX, $cropY, $cropW, $cropH) from $($src.Width)x$($src.Height)"

$cropRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$cropped = $src.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Check top row of cropped
$cTopLeft = $cropped.GetPixel(30, 0)
$cTopMid = $cropped.GetPixel(500, 0)
$cTopRight = $cropped.GetPixel(950, 0)
Write-Host "Cropped top row: Left=($($cTopLeft.R),$($cTopLeft.G),$($cTopLeft.B)) Mid=($($cTopMid.R),$($cTopMid.G),$($cTopMid.B)) Right=($($cTopRight.R),$($cTopRight.G),$($cTopRight.B))"

# Check bottom row of cropped
$cBotLeft = $cropped.GetPixel(30, $cropH - 1)
$cBotMid = $cropped.GetPixel(500, $cropH - 1)
$cBotRight = $cropped.GetPixel(950, $cropH - 1)
Write-Host "Cropped bottom row: Left=($($cBotLeft.R),$($cBotLeft.G),$($cBotLeft.B)) Mid=($($cBotMid.R),$($cBotMid.G),$($cBotMid.B)) Right=($($cBotRight.R),$($cBotRight.G),$($cBotRight.B))"

$cropped.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_crop.png")

$cropped.Dispose()
$src.Dispose()
