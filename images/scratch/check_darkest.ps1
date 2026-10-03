Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png')
$minR = 255; $minG = 255; $minB = 255
$minLum = 255
for ($y = 0; $y -lt $b.Height; $y += 5) {
    for ($x = 0; $x -lt $b.Width; $x += 5) {
        $c = $b.GetPixel($x, $y)
        $lum = 0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B
        if ($lum -lt $minLum) {
            $minLum = $lum
            $minR = $c.R
            $minG = $c.G
            $minB = $c.B
        }
    }
}
Write-Host "Darkest sampled pixel in entire banner: R=$minR, G=$minG, B=$minB (Luminance=$minLum)"
$b.Dispose()
