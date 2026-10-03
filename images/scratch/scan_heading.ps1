Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("images\scratch\crop_eyebrow_heading.png")
Write-Host "Eyebrow/Heading crop: $($bmp.Width) x $($bmp.Height)"

# Find dark pixels
for ($y = 20; $y -lt 160; $y += 4) {
    $line = ""
    for ($x = 20; $x -lt 380; $x += 4) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 50 -and $c.B -gt 50) {
            $line += "#"
        } elseif ($c.R -gt 200 -and $c.G -gt 130 -and $c.B -lt 60) {
            $line += "="
        } else {
            $line += " "
        }
    }
    if ($line.Trim().Length -gt 0) {
        Write-Host ("Y={0:D3}: {1}" -f $y, $line)
    }
}
$bmp.Dispose()
