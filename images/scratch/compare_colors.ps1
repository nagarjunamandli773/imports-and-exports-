Add-Type -AssemblyName System.Drawing

$user = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')
$curr = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png')

# Let's check colors of both at corresponding proportional positions:
# e.g., in user: ship is around x=600, y=80 (600/1024 = 0.586, 80/160 = 0.5)
# In curr: x = 0.586 * 4096 = 2400, y = 0.5 * 612 = 306

$testPoints = @(
    @{ name="Navy bg"; ux=100; uy=50; cx=400; cy=190 },
    @{ name="Title Gold"; ux=220; uy=65; cx=880; cy=250 },
    @{ name="Sky blue"; ux=500; uy=30; cx=2000; cy=115 },
    @{ name="Sunset orange"; ux=720; uy=80; cx=2880; cy=306 },
    @{ name="Ship container red"; ux=610; uy=75; cx=2440; cy=287 },
    @{ name="Bottom swoosh border"; ux=200; uy=148; cx=800; cy=565 }
)

foreach ($tp in $testPoints) {
    $cu = $user.GetPixel($tp.ux, $tp.uy)
    $cc = $curr.GetPixel($tp.cx, $tp.cy)
    Write-Host "$($tp.name):"
    Write-Host "   User:    R=$($cu.R) G=$($cu.G) B=$($cu.B)"
    Write-Host "   Current: R=$($cc.R) G=$($cc.G) B=$($cc.B)"
}

$user.Dispose()
$curr.Dispose()
