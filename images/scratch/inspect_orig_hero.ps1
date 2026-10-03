Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790298228335.png"
if (Test-Path $src) {
    $bmp = [System.Drawing.Bitmap]::FromFile($src)
    Write-Host "Orig user uploaded media in c8e...: $($bmp.Width) x $($bmp.Height)"
    $bmp.Dispose()
} else {
    Write-Host "File not found: $src"
}

$raw = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\orig_hero_raw.jpg"
if (Test-Path $raw) {
    $bmp = [System.Drawing.Bitmap]::FromFile($raw)
    Write-Host "orig_hero_raw.jpg: $($bmp.Width) x $($bmp.Height)"
    $bmp.Dispose()
}
