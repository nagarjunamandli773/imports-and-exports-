Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\68b66b9b-2f54-4177-89bf-c32635ad52cc\.user_uploaded\media_1789795169490.png"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

# 1. Convert to 32bpp Argb with transparency for white background
$bmp = New-Object System.Drawing.Bitmap($src.Width, $src.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($x = 0; $x -lt $src.Width; $x++) {
    for ($y = 0; $y -lt $src.Height; $y++) {
        $p = $src.GetPixel($x, $y)
        if ($p.R -gt 240 -and $p.G -gt 240 -and $p.B -gt 240) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        } else {
            # Smooth antialiasing
            if ($p.R -gt 215 -and $p.G -gt 215 -and $p.B -gt 215) {
                $avg = ($p.R + $p.G + $p.B) / 3.0
                $alpha = [int](255 * (255 - $avg) / 40.0)
                if ($alpha -lt 0) { $alpha = 0 }
                if ($alpha -gt 255) { $alpha = 255 }
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, $p.R, $p.G, $p.B))
            } else {
                $bmp.SetPixel($x, $y, $p)
            }
        }
    }
}

# 2. Strict bounding box excluding lower service icons (cutoff at y = 236)
$maxYForHeader = 236
$minX = $src.Width
$maxX = 0
$minY = $src.Height
$maxY = 0

for ($x = 0; $x -lt $src.Width; $x++) {
    for ($y = 0; $y -lt $maxYForHeader; $y++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 20) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

Write-Output "Clean Tight Logo Bounding Box: X=[$minX, $maxX], Y=[$minY, $maxY], Width=$($maxX - $minX + 1), Height=$($maxY - $minY + 1)"

$cropX = [Math]::Max(0, $minX - 1)
$cropY = [Math]::Max(0, $minY - 1)
$cropW = [Math]::Min($src.Width - $cropX, ($maxX - $minX + 3))
$cropH = [Math]::Min($src.Height - $cropY, ($maxY - $minY + 3))

$tightRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$tightLogo = $bmp.Clone($tightRect, $bmp.PixelFormat)

$logoOut = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo.png"
$tightLogo.Save($logoOut, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Saved clean tight $logoOut"

$logoOut3x = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo@3x.png"
$tightLogo.Save($logoOut3x, [System.Drawing.Imaging.ImageFormat]::Png)

# White inverted logo
$whiteBmp = New-Object System.Drawing.Bitmap($tightLogo.Width, $tightLogo.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
for ($x = 0; $x -lt $tightLogo.Width; $x++) {
    for ($y = 0; $y -lt $tightLogo.Height; $y++) {
        $p = $tightLogo.GetPixel($x, $y)
        if ($p.A -gt 15) {
            if ($p.R -gt 145 -and $p.G -gt 95 -and $p.B -lt 115) {
                $whiteBmp.SetPixel($x, $y, $p)
            } else {
                $whiteBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, 255, 255, 255))
            }
        } else {
            $whiteBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}
$whiteOut = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo_white.png"
$whiteBmp.Save($whiteOut, [System.Drawing.Imaging.ImageFormat]::Png)
$whiteOut3x = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo_white@3x.png"
$whiteBmp.Save($whiteOut3x, [System.Drawing.Imaging.ImageFormat]::Png)

$whiteBmp.Dispose()
$tightLogo.Dispose()
$bmp.Dispose()
$src.Dispose()

Write-Output "Clean logo processing complete!"
