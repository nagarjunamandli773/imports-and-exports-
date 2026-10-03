Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\home_hero_master_4x.png')
Write-Host "Sample pixels along bottom row (y=755):"
for ($x = 3000; $x -lt 4096; $x += 200) {
    Write-Host "x=$x : $($b.GetPixel($x, 755))"
}
Write-Host "Sample pixels at y=750:"
for ($x = 3000; $x -lt 4096; $x += 200) {
    Write-Host "x=$x : $($b.GetPixel($x, 750))"
}
$b.Dispose()
