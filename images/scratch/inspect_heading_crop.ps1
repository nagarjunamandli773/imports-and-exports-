Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

# Let's crop the heading from test_contact_4k.png
$test4k = [System.Drawing.Bitmap]::FromFile("images\scratch\test_contact_4k.png")
$rect = New-Object System.Drawing.Rectangle(120, 320, 1400, 340)
$cropOrig = $test4k.Clone($rect, $test4k.PixelFormat)
$cropOrig.Save("images\scratch\heading_upscaled.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropOrig.Dispose()
$test4k.Dispose()

Write-Host "Saved heading_upscaled.png"
