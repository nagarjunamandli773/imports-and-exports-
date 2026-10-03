Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("images\scratch\crop_badge1.png")
Write-Host "Badge 1 crop: $($bmp.Width) x $($bmp.Height)"
for ($y = 40; $y -lt $bmp.Height; $y += 2) {
    $line = ""
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 50 -and $c.G -lt 50) {
            $line += "#"
        } elseif ($c.R -lt 150 -and $c.G -lt 150) {
            $line += "."
        } else {
            $line += " "
        }
    }
    if ($line.Trim().Length -gt 0) {
        $absY = $y + 215
        Write-Host ("Y={0:D3} (abs {1:D3}): {2}" -f $y, $absY, $line)
    }
}
$bmp.Dispose()
