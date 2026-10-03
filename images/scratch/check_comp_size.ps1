Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
Write-Host "Uploaded Banner Dimensions: $($bmp.Width) x $($bmp.Height)"
$bmp.Dispose()
