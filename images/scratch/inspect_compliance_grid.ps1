Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Let's save a visual grid on top of compliance_hero_banner_user_1x.png to inspect in artifacts
$vis = new-object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
$g = [System.Drawing.Graphics]::FromImage($vis)
$g.DrawImage($bmp, 0, 0)

$penRed = new-object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 255, 0, 0), 1)
$penBlue = new-object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 0, 0, 255), 1)
$font = new-object System.Drawing.Font("Arial", 7)
$brush = new-object System.Drawing.SolidBrush([System.Drawing.Color]::Red)

# Draw grid lines every 50px
for ($x = 0; $x -lt $bmp.Width; $x += 50) {
    $g.DrawLine($penRed, $x, 0, $x, $bmp.Height)
    $g.DrawString("$x", $font, $brush, $x + 2, 2)
}
for ($y = 0; $y -lt $bmp.Height; $y += 25) {
    $g.DrawLine($penBlue, 0, $y, $bmp.Width, $y)
    $g.DrawString("$y", $font, $brush, 2, $y + 2)
}

$g.Dispose()

$artDir = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2"
$visPath = Join-Path $artDir "compliance_grid_inspect.png"
$vis.Save($visPath, [System.Drawing.Imaging.ImageFormat]::Png)
$vis.Dispose()
$bmp.Dispose()

Write-Host "Grid saved to $visPath"
