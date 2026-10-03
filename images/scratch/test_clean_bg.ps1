Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner_user_1x.png"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

$w = $src.Width
$h = $src.Height
$clean = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($clean)
$g.DrawImage($src, 0, 0)
$g.Dispose()

# Create mask for text in X: 35 to 440, Y: 15 to 240
# We mask any pixel that is NOT the white/sky background
$mask = New-Object "bool[,]" $w, $h

for ($y = 15; $y -le 240; $y++) {
    for ($x = 35; $x -le 440; $x++) {
        $p = $src.GetPixel($x, $y)
        # Background is white/light pastel: R>245, G>245, B>245
        # Any text/badge/divider pixel has R < 235 or G < 235 or B < 235
        # Also check for gold pixels: R>200, B<160
        if ($p.R -lt 238 -or $p.G -lt 238 -or $p.B -lt 238 -or ($p.R -gt 220 -and $p.B -lt 180)) {
            $mask[$x, $y] = $true
        }
    }
}

# Dilate mask by 2px to catch anti-aliasing halos
$dilated = New-Object "bool[,]" $w, $h
for ($y = 15; $y -le 240; $y++) {
    for ($x = 35; $x -le 440; $x++) {
        $found = $false
        for ($dy = -2; $dy -le 2 -and -not $found; $dy++) {
            for ($dx = -2; $dx -le 2 -and -not $found; $dx++) {
                $nx = $x + $dx
                $ny = $y + $dy
                if ($nx -ge 30 -and $nx -le 450 -and $ny -ge 10 -and $ny -le 245) {
                    if ($mask[$nx, $ny]) { $found = $true }
                }
            }
        }
        $dilated[$x, $y] = $found
    }
}

# PDE Laplace inpainting
$rArr = New-Object "double[,]" $w, $h
$gArr = New-Object "double[,]" $w, $h
$bArr = New-Object "double[,]" $w, $h

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $p = $clean.GetPixel($x, $y)
        $rArr[$x, $y] = $p.R
        $gArr[$x, $y] = $p.G
        $bArr[$x, $y] = $p.B
    }
}

for ($iter = 0; $iter -lt 300; $iter++) {
    for ($y = 15; $y -le 240; $y++) {
        for ($x = 35; $x -le 440; $x++) {
            if ($dilated[$x, $y]) {
                $rArr[$x, $y] = ($rArr[$x - 1, $y] + $rArr[$x + 1, $y] + $rArr[$x, $y - 1] + $rArr[$x, $y + 1]) * 0.25
                $gArr[$x, $y] = ($gArr[$x - 1, $y] + $gArr[$x + 1, $y] + $gArr[$x, $y - 1] + $gArr[$x, $y + 1]) * 0.25
                $bArr[$x, $y] = ($bArr[$x - 1, $y] + $bArr[$x + 1, $y] + $bArr[$x, $y - 1] + $bArr[$x, $y + 1]) * 0.25
            }
        }
    }
}

for ($y = 15; $y -le 240; $y++) {
    for ($x = 35; $x -le 440; $x++) {
        if ($dilated[$x, $y]) {
            $r = [Math]::Max(0, [Math]::Min(255, [int][Math]::Round($rArr[$x, $y])))
            $gCol = [Math]::Max(0, [Math]::Min(255, [int][Math]::Round($gArr[$x, $y])))
            $bCol = [Math]::Max(0, [Math]::Min(255, [int][Math]::Round($bArr[$x, $y])))
            $clean.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($r, $gCol, $bCol))
        }
    }
}

$clean.Save("c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_product_hero.png", [System.Drawing.Imaging.ImageFormat]::Png)
$clean.Dispose()
$src.Dispose()
Write-Host "Clean product hero test saved!"
