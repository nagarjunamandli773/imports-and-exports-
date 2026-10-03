Add-Type -AssemblyName System.Drawing
$uPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790497408227.png"
$bmp = [System.Drawing.Bitmap]::FromFile($uPath)

Write-Host "Top-Left (0,0): $($bmp.GetPixel(0, 0))"
Write-Host "Top-Right (w-1,0): $($bmp.GetPixel($bmp.Width-1, 0))"
Write-Host "Bottom-Left (0,h-1): $($bmp.GetPixel(0, $bmp.Height-1))"
Write-Host "Bottom-Right (w-1,h-1): $($bmp.GetPixel($bmp.Width-1, $bmp.Height-1))"
Write-Host "Bottom-Center (w/2,h-1): $($bmp.GetPixel([int]($bmp.Width/2), $bmp.Height-1))"

$bmp.Dispose()
