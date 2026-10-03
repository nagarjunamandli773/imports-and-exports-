Add-Type -AssemblyName System.Drawing
foreach ($i in 1..4) {
    $bmp = [System.Drawing.Bitmap]::FromFile("images\scratch\icon_circle$i.png")
    $center = $bmp.GetPixel(21, 21)
    Write-Host "Icon $i center color: R=$($center.R), G=$($center.G), B=$($center.B)"
    $bmp.Dispose()
}
