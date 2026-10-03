Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo.png')

Write-Host "Logo original: $($bmp.Width) x $($bmp.Height)"

# Find where the M in EXIM ends
for ($x = $bmp.Width - 1; $x -ge 0; $x -= 5) {
    $c = 0
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 20) { $c++ }
    }
    if ($c -gt 5) {
        Write-Host "Last non-transparent column: x=$x (count=$c)"
        break
    }
}
$bmp.Dispose()
