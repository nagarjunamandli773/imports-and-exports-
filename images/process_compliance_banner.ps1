Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$destPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
$destPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.png"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

$cropX = 0
$cropY = 5
$cropW = 1019
$cropH = $bmp.Height - $cropY

$rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$croppedBmp = $bmp.Clone($rect, $bmp.PixelFormat)

$croppedBmp.Save($destPng1, [System.Drawing.Imaging.ImageFormat]::Png)
$croppedBmp.Save($destPng2, [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "Row 0 Col 10: $($croppedBmp.GetPixel(10, 0))"
Write-Host "Row 0 Col 500: $($croppedBmp.GetPixel(500, 0))"
Write-Host "Row 0 Col 1000: $($croppedBmp.GetPixel(1000, 0))"

$croppedBmp.Dispose()
$bmp.Dispose()
