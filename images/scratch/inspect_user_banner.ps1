Add-Type -AssemblyName System.Drawing

$userImg = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')
$currImg = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png')

Write-Host "User Image: $($userImg.Width) x $($userImg.Height), aspect ratio = $([double]$userImg.Width / $userImg.Height)"
Write-Host "Current Image: $($currImg.Width) x $($currImg.Height), aspect ratio = $([double]$currImg.Width / $currImg.Height)"

# Check corners and borders of user image
Write-Host "User Top-Left: $($userImg.GetPixel(0, 0))"
Write-Host "User Top-Right: $($userImg.GetPixel($userImg.Width - 1, 0))"
Write-Host "User Bottom-Left: $($userImg.GetPixel(0, $userImg.Height - 1))"
Write-Host "User Bottom-Right: $($userImg.GetPixel($userImg.Width - 1, $userImg.Height - 1))"

# Check sample navy background on user image (e.g. x=100, y=50)
Write-Host "User Navy sample (100, 50): $($userImg.GetPixel(100, 50))"
Write-Host "User Title gold sample (200, 50): $($userImg.GetPixel(200, 50))"

# Check bottom edge color across width of user image
$bottomColors = @()
for ($x = 0; $x -lt $userImg.Width; $x += 100) {
    $c = $userImg.GetPixel($x, $userImg.Height - 1)
    $bottomColors += "$($x): R=$($c.R),G=$($c.G),B=$($c.B)"
}
Write-Host "Bottom row sample colors: $($bottomColors -join ' | ')"

# Check top edge color across width of user image
$topColors = @()
for ($x = 0; $x -lt $userImg.Width; $x += 100) {
    $c = $userImg.GetPixel($x, 0)
    $topColors += "$($x): R=$($c.R),G=$($c.G),B=$($c.B)"
}
Write-Host "Top row sample colors: $($topColors -join ' | ')"

$userImg.Dispose()
$currImg.Dispose()
