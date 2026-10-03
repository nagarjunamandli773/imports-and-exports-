Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png')
$yellowCount = 0
for ($y = 740; $y -lt $b.Height; $y++) {
    for ($x = 0; $x -lt $b.Width; $x += 10) {
        $c = $b.GetPixel($x, $y)
        # Yellow has high R and G, low B
        if ($c.R -gt 150 -and $c.G -gt 130 -and $c.B -lt 100) {
            Write-Host "Found yellow at x=$x, y=$($y): $c"
            $yellowCount++
            if ($yellowCount -gt 10) { break }
        }
    }
    if ($yellowCount -gt 10) { break }
}
if ($yellowCount -eq 0) {
    Write-Host "ZERO yellow pixels in the bottom region!"
}
$b.Dispose()
