Add-Type -AssemblyName System.Drawing

$userImgPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f03b0162-5f91-43c8-9d29-d47cc36efbe0\.user_uploaded\media_1790493465970.png"
$currImgPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png"

$u = [System.Drawing.Bitmap]::FromFile($userImgPath)
Write-Host "User uploaded media: $($u.Width) x $($u.Height)"

$c = [System.Drawing.Bitmap]::FromFile($currImgPath)
Write-Host "Current product hero: $($c.Width) x $($c.Height)"

# Sample bottom left corner of user image
Write-Host "User Image: (0, 0) color: $($u.GetPixel(0,0))"
Write-Host "User Image: (10, 10) color: $($u.GetPixel(10,10))"
Write-Host "User Image: (50, 50) color: $($u.GetPixel(50,50))"
Write-Host "User Image: bottom-left (10, $($u.Height - 10)) color: $($u.GetPixel(10, $u.Height - 10))"
Write-Host "User Image: bottom-left (50, $($u.Height - 50)) color: $($u.GetPixel(50, $u.Height - 50))"

# Check corners of user image
Write-Host "User image (0, $($u.Height/2)): $($u.GetPixel(0, [int]($u.Height/2)))"

$u.Dispose()
$c.Dispose()
