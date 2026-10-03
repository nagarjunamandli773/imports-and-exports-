Add-Type -AssemblyName System.Drawing

$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$bmp = New-Object System.Drawing.Bitmap(1000, 200)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$pfc = New-Object System.Drawing.Text.PrivateFontCollection
$pfc.AddFontFile($fontSansPath)
$font = New-Object System.Drawing.Font($pfc.Families[0], 43, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)

$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)
$g.Clear([System.Drawing.Color]::White)

# Default DrawString
$g.DrawString("Default: quality, safety,", $font, $brush, 20, 20)

# GenericTypographic DrawString
$sf = [System.Drawing.StringFormat]::GenericTypographic
$g.DrawString("Typographic: quality, safety,", $font, $brush, 20, 100, $sf)

$g.Dispose()
$bmp.Save("C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\test_kerning.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Kerning test saved!"
