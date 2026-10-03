Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner_user_1x.png")
$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0;
for ($y = 20; $y -lt 240; $y++) {
    for ($x = 20; $x -lt 480; $x++) {
        $c = $img.GetPixel($x, $y)
        # Text pixels are distinctly darker (R < 220 or G < 220 or B < 220)
        # while background is > 240
        if ($c.R -lt 210 -or $c.G -lt 210 -or $c.B -lt 210) {
            # Exclude bottom-left blue swoosh (y > 180 and x < 150)
            if ($y -gt 180 -and $x -lt 100) { continue }
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Host ("Text Bounding Box: X=[{0}, {1}], Y=[{2}, {3}]" -f $minX, $maxX, $minY, $maxY)
$img.Dispose()
