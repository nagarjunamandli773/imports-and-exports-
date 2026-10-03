Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png')
Write-Host "Sampling bottom rows at x=3500:"
for ($y = 745; $y -lt $b.Height; $y++) {
    Write-Host "y=$y : $($b.GetPixel(3500, $y))"
}
$b.Dispose()
