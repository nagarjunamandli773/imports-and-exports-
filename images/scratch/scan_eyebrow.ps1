Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("images\scratch\crop_eyebrow_heading.png")

for ($y = 35; $y -le 85; $y += 2) {
    $line = ""
    for ($x = 25; $x -le 160; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 100 -and $c.G -lt 100 -and $c.B -gt 90) {
            $line += "#"
        } elseif ($c.R -gt 200 -and $c.G -gt 130 -and $c.B -lt 80) {
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
