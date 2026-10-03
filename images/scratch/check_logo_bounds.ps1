Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo.png')
$minX = $bmp.Width
$maxX = 0
$minY = $bmp.Height
$maxY = 0

for ($y = 0; $y -lt $bmp.Height; $y += 2) {
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 20) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Host "Width: $($bmp.Width), Height: $($bmp.Height)"
Write-Host "Bounds: minX=$minX, maxX=$maxX, minY=$minY, maxY=$maxY"
$bmp.Dispose()
