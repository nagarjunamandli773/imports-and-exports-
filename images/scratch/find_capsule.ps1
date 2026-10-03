Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png")

# Let's find dark pixels on the right that correspond to the capsule
for ($x = 700; $x -lt 1000; $x += 20) {
    for ($y = 90; $y -lt 140; $y += 10) {
        $c = $b.GetPixel($x, $y)
        if ($c.R -lt 30 -and $c.G -lt 30 -and $c.B -lt 40) {
            Write-Host "Dark pixel at X=$x, Y=$y : $c"
        }
    }
}

$b.Dispose()
