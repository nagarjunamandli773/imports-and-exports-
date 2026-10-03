Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner_user_1x.png")
Write-Host "Width: $($img.Width), Height: $($img.Height)"
$points = @(
    @{x=20; y=20}, @{x=100; y=20}, @{x=300; y=20},
    @{x=20; y=80}, @{x=20; y=140}, @{x=20; y=200},
    @{x=30; y=100}, @{x=400; y=100}, @{x=430; y=100},
    @{x=450; y=100}, @{x=500; y=100}
)
foreach ($p in $points) {
    $c = $img.GetPixel($p.x, $p.y)
    Write-Host ("x={0}, y={1}: R={2}, G={3}, B={4}" -f $p.x, $p.y, $c.R, $c.G, $c.B)
}
$img.Dispose()
