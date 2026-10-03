Add-Type -AssemblyName System.Drawing

$p = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg"
if (Test-Path $p) {
    $bmp = [System.Drawing.Bitmap]::FromFile($p)
    Write-Host "Found media_1789971937755.jpg: $($bmp.Width) x $($bmp.Height)"
    $bmp.Dispose()
} else {
    Write-Host "Not found: $p"
}
