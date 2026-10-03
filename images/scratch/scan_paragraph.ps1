Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("images\scratch\crop_paragraph.png")
Write-Host "Paragraph crop: $($bmp.Width) x $($bmp.Height)"

for ($y = 0; $y -lt $bmp.Height; $y += 2) {
    $line = ""
    for ($x = 20; $x -lt 440; $x += 3) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 150 -and $c.G -lt 150 -and $c.B -lt 170) {
            $line += "#"
        } else {
            $line += " "
        }
    }
    if ($line.Trim().Length -gt 0) {
        $absY = $y + 150
        Write-Host ("Y={0:D3} (abs {1:D3}): {2}" -f $y, $absY, $line)
    }
}
$bmp.Dispose()
