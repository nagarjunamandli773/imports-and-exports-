Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790300743947.png')

$w = $src.Width - 830
$rect = New-Object System.Drawing.Rectangle(830, 0, $w, 150)
$crop = $src.Clone($rect, $src.PixelFormat)
$crop.Save('images\scratch\service_quote_crop.png')

$src.Dispose()
$crop.Dispose()
Write-Host "Saved service_quote_crop.png successfully"
