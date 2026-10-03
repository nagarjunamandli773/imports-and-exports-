Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790298228335.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "media_1790298228335.png bounds: $($bmp.Width) x $($bmp.Height)"

Write-Host "Checking bottom-left pixels:"
for ($y = 80; $y -lt $bmp.Height; $y += 10) {
    $c0 = $bmp.GetPixel(0, $y)
    $c50 = $bmp.GetPixel(50, $y)
    $c100 = $bmp.GetPixel(100, $y)
    Write-Host "Y=$y : (0)=$($c0.R),$($c0.G),$($c0.B)  (50)=$($c50.R),$($c50.G),$($c50.B)  (100)=$($c100.R),$($c100.G),$($c100.B)"
}

$bmp.Dispose()
