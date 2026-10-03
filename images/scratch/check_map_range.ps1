Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Checking for any map or non-white background pixels between X=20 and X=330, Y=60 to 220:"
$nonWhiteCount = 0
for ($y = 60; $y -le 220; $y += 5) {
    for ($x = 20; $x -le 330; $x += 5) {
        $p = $bmp.GetPixel($x, $y)
        # Background pixel (excluding text which is dark navy or gold)
        # Is there any faint map grey (e.g., R=230..245, G=230..245, B=230..245)?
        if ($p.R -gt 220 -and $p.R -lt 250 -and [Math]::Abs($p.R - $p.G) -lt 5 -and [Math]::Abs($p.G - $p.B) -lt 5) {
            # This might be faint map grey
            # Write-Host "Possible map pixel at ($x, $y): R=$($p.R) G=$($p.G) B=$($p.B)"
            $nonWhiteCount++
        }
    }
}
Write-Host "Total possible map pixels found in X=20..330: $nonWhiteCount"

$bmp.Dispose()
