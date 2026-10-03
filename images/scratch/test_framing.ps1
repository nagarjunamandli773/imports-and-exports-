Add-Type -AssemblyName System.Drawing

$photoPath = "c:\Users\Administrator\Pictures\emports and exports\images\hero_banner.jpg"
$photo = [System.Drawing.Bitmap]::FromFile($photoPath)

$targetW = 4096
$targetH = 756

$photoDrawW = 2850
$photoDrawH = [int]($photo.Height * ($photoDrawW / $photo.Width)) # 768 * (2850/1376) = 1591
$photoDrawX = $targetW - $photoDrawW # 1246
$photoDrawY = -135 # brings airplane down so it is fully visible!

$dest = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($dest)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$g.Clear([System.Drawing.Color]::FromArgb(255, 7, 26, 54))
$g.DrawImage($photo, $photoDrawX, $photoDrawY, $photoDrawW, $photoDrawH)

$dest.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\framing_test2.png")
$g.Dispose()
$dest.Dispose()
$photo.Dispose()
Write-Host "Framing test 2 saved."
