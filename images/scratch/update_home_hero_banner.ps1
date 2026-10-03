Add-Type -AssemblyName System.Drawing

$bgPath = "c:\Users\Administrator\Pictures\emports and exports\public\images\concept-exim-global-trade-hero-bg-4k.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerifPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"
$outWeb = "c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png"
$outMaster = "c:\Users\Administrator\Pictures\emports and exports\images\home_hero_master_4x.png"

$bgBmp = [System.Drawing.Bitmap]::FromFile($bgPath)
$targetW = 4096
$targetH = 756
$scale = [float]$targetW / 1024.0

$destBmp = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($destBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Draw the 4K panorama image centered and scaled to cover
$bgScale = [Math]::Max([double]$targetW / $bgBmp.Width, [double]$targetH / $bgBmp.Height)
$drawW = [int]($bgBmp.Width * $bgScale)
$drawH = [int]($bgBmp.Height * $bgScale)
$drawX = [int](($targetW - $drawW) / 2)
$drawY = [int](($targetH - $drawH) / 2)

$g.DrawImage($bgBmp, $drawX, $drawY, $drawW, $drawH)

# Subtle dark navy gradient on left 38%
$gradRect = New-Object System.Drawing.Rectangle(0, 0, [int]($targetW * 0.42), $targetH)
$gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($gradRect, [System.Drawing.Color]::FromArgb(215, 7, 25, 47), [System.Drawing.Color]::FromArgb(0, 7, 25, 47), [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
$g.FillRectangle($gradBrush, $gradRect)
$gradBrush.Dispose()

# Subtle gold bottom line
$goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 223, 139, 26), 4.0)
$g.DrawLine($goldPen, 0, $targetH - 2, $targetW, $targetH - 2)
$goldPen.Dispose()

$pfcSans = New-Object System.Drawing.Text.PrivateFontCollection
if (Test-Path $fontSansPath) { $pfcSans.AddFontFile($fontSansPath) }
$famSans = if ($pfcSans.Families.Length -gt 0) { $pfcSans.Families[0] } else { New-Object System.Drawing.FontFamily("Segoe UI") }

$pfcSerif = New-Object System.Drawing.Text.PrivateFontCollection
if (Test-Path $fontSerifPath) { $pfcSerif.AddFontFile($fontSerifPath) }
$famSerif = if ($pfcSerif.Families.Length -gt 0) { $pfcSerif.Families[0] } else { New-Object System.Drawing.FontFamily("Georgia") }

$startX = 56.0 * $scale

# Eyebrow
$eyebrowFont = New-Object System.Drawing.Font($famSans, 6.8 * $scale, [System.Drawing.FontStyle]::Bold)
$goldEyebrow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 195, 82))
$g.DrawString("INTERNATIONAL TRADE & LOGISTICS", $eyebrowFont, $goldEyebrow, $startX, 26.0 * $scale)

# Headline
$headingFont = New-Object System.Drawing.Font($famSerif, 18.5 * $scale, [System.Drawing.FontStyle]::Bold)
$whiteHeading = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
$goldHeading = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 188, 55))
$g.DrawString("Trade Beyond Borders,", $headingFont, $whiteHeading, $startX - (0.5 * $scale), 39.0 * $scale)
$g.DrawString("Built for Growth", $headingFont, $goldHeading, $startX - (0.5 * $scale), 66.0 * $scale)

# Description
$descFont = New-Object System.Drawing.Font($famSans, 5.8 * $scale, [System.Drawing.FontStyle]::Regular)
$descBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(228, 238, 248))
$g.DrawString("CONCEPT EXIM connects businesses worldwide with seamless", $descFont, $descBrush, $startX, 98.0 * $scale)
$g.DrawString("import-export solutions, reliable logistics and trusted partnerships.", $descFont, $descBrush, $startX, (98.0 + 8.6) * $scale)

# Function for rounded rectangle path
function Get-RoundedRect($rect, $radius) {
    $diameter = $radius * 2
    $size = New-Object System.Drawing.Size($diameter, $diameter)
    $arc = New-Object System.Drawing.Rectangle($rect.Location, $size)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    if ($radius -eq 0) { $path.AddRectangle($rect); return $path }
    $path.AddArc($arc, 180, 90)
    $arc.X = $rect.Right - $diameter
    $path.AddArc($arc, 270, 90)
    $arc.Y = $rect.Bottom - $diameter
    $path.AddArc($arc, 0, 90)
    $arc.X = $rect.Left
    $path.AddArc($arc, 90, 90)
    $path.CloseFigure()
    return $path
}

# Button 1: Explore Our Services ->
$btnY = 128.0 * $scale
$btnH = 22.0 * $scale
$btn1W = 106.0 * $scale
$btn1Rect = New-Object System.Drawing.Rectangle([int]$startX, [int]$btnY, [int]$btn1W, [int]$btnH)
$btn1Path = Get-RoundedRect $btn1Rect ([int](5.0 * $scale))
$btn1Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 185, 55))
$g.FillPath($btn1Bg, $btn1Path)
$btnFont = New-Object System.Drawing.Font($famSans, 5.2 * $scale, [System.Drawing.FontStyle]::Bold)
$btn1TextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(7, 25, 47))
$b1Str = "Explore Our Services  " + [char]0x2192
$b1Size = $g.MeasureString($b1Str, $btnFont)
$g.DrawString($b1Str, $btnFont, $btn1TextBrush, $startX + ($btn1W - $b1Size.Width) / 2.0, $btnY + ($btnH - $b1Size.Height) / 2.0)

# Button 2: Get a Custom Quote
$btn2X = $startX + $btn1W + (12.0 * $scale)
$btn2W = 102.0 * $scale
$btn2Rect = New-Object System.Drawing.Rectangle([int]$btn2X, [int]$btnY, [int]$btn2W, [int]$btnH)
$btn2Path = Get-RoundedRect $btn2Rect ([int](5.0 * $scale))
$btn2Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(170, 8, 28, 56))
$btn2Pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 255, 255, 255), 1.2 * $scale)
$g.FillPath($btn2Bg, $btn2Path)
$g.DrawPath($btn2Pen, $btn2Path)
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
$b2Str = "Get a Custom Quote"
$b2Size = $g.MeasureString($b2Str, $btnFont)
$g.DrawString($b2Str, $btnFont, $whiteBrush, $btn2X + ($btn2W - $b2Size.Width) / 2.0, $btnY + ($btnH - $b2Size.Height) / 2.0)

# Right Stats Card
$cardX = [int](868.0 * $scale)
$cardY = [int](18.0 * $scale)
$cardW = [int](144.0 * $scale)
$cardH = [int](153.0 * $scale)
$cardRadius = [int](11.0 * $scale)
$cardRect = New-Object System.Drawing.Rectangle($cardX, $cardY, $cardW, $cardH)
$cardPath = Get-RoundedRect $cardRect $cardRadius

$cardBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($cardRect, [System.Drawing.Color]::FromArgb(240, 10, 32, 64), [System.Drawing.Color]::FromArgb(244, 6, 20, 42), [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillPath($cardBg, $cardPath)
$glassPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(130, 255, 255, 255), 1.2 * $scale)
$g.DrawPath($glassPen, $cardPath)

$statRowH = 34.0 * $scale
$iconCX = $cardX + (22.0 * $scale)
$textStartX = $cardX + (41.0 * $scale)
$iconR = 8.5 * $scale

$numFont = New-Object System.Drawing.Font($famSans, 7.8 * $scale, [System.Drawing.FontStyle]::Bold)
$lblFont = New-Object System.Drawing.Font($famSans, 4.4 * $scale, [System.Drawing.FontStyle]::Regular)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(215, 228, 242))
$iconBgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 245, 185, 55))
$iconBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 245, 185, 55), 1.0 * $scale)
$iconPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 245, 185, 55), 1.3 * $scale)
$divPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(50, 255, 255, 255), 0.8 * $scale)

$nums = @("150+", "2,500+", "500+", "98%")
$lbls = @("Countries Served", "Successful Shipments", "Global Partners", "On-Time Delivery Rate")

for ($i = 0; $i -lt 4; $i++) {
    $rowY = $cardY + (10.0 * $scale) + ($i * $statRowH)
    $cy = $rowY + (10.0 * $scale)
    $g.FillEllipse($iconBgBrush, $iconCX - $iconR, $cy - $iconR, $iconR * 2, $iconR * 2)
    $g.DrawEllipse($iconBorderPen, $iconCX - $iconR, $cy - $iconR, $iconR * 2, $iconR * 2)
    $s = $iconR * 0.55
    $g.DrawEllipse($iconPen, $iconCX - $s, $cy - $s, $s * 2, $s * 2)
    $g.DrawString($nums[$i], $numFont, $whiteBrush, $textStartX, $rowY + (0.5 * $scale))
    $g.DrawString($lbls[$i], $lblFont, $subBrush, $textStartX, $rowY + (9.8 * $scale))
    if ($i -lt 3) {
        $divY = $rowY + $statRowH - (2.0 * $scale)
        $g.DrawLine($divPen, $cardX + (12.0 * $scale), $divY, $cardX + $cardW - (12.0 * $scale), $divY)
    }
}

$destBmp.Save($outWeb, [System.Drawing.Imaging.ImageFormat]::Png)
$destBmp.Save($outMaster, [System.Drawing.Imaging.ImageFormat]::Png)

$bgBmp.Dispose()
$destBmp.Dispose()
$g.Dispose()

Write-Host "Updated home_hero_banner.png successfully with 4K background!"
