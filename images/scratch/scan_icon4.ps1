Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("images\scratch\icon_circle4.png")
for ($y = 0; $y -lt 42; $y += 2) {
    $line = ""
    for ($x = 0; $x -lt 42; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 200 -and $c.G -gt 140 -and $c.B -lt 60) {
            $line += "O" # gold border
        } elseif ($c.R -lt 50 -and $c.B -gt 70) {
            $line += "#" # navy
        } elseif ($c.R -gt 240 -and $c.G -gt 240) {
            $line += "." # white
        } else {
            $line += " "
        }
    }
    Write-Host ("Y={0:D2}: {1}" -f $y, $line)
}
$bmp.Dispose()
