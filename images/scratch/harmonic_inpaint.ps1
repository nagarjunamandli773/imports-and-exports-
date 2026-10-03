Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width
$h = $bmp.Height

# Step 1: Create mask for text
$mask = New-Object 'bool[,]' $w, $h

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $mask[$x, $y] = $false
        
        # Only in the quotation region
        if ($x -ge 880 -and $x -le 1015 -and $y -ge 12 -and $y -le 114) {
            $c = $bmp.GetPixel($x, $y)
            
            # White cursive letters
            $isWhite = ($c.R -gt 180 -and $c.G -gt 180 -and $c.B -gt 180) -or
                       ($c.R -gt 160 -and $c.G -gt 160 -and $c.B -gt 170 -and [Math]::Abs($c.R - $c.G) -lt 25)
            
            # Yellow underline swoop
            $isYellow = ($c.R -gt 175 -and $c.G -gt 145 -and $c.B -lt 140)
            
            # Text halo/glow
            $isGlow = ($c.R -gt 150 -and $c.G -gt 150 -and $c.B -gt 165 -and $y -lt 85) -or
                      ($c.R -gt 175 -and $c.G -gt 150 -and $c.B -lt 160 -and $y -ge 80)
            
            if ($isWhite -or $isYellow -or $isGlow) {
                $mask[$x, $y] = $true
            }
        }
    }
}

# Step 2: Dilate mask by 3 pixels to guarantee clean outer edges
$dilated = New-Object 'bool[,]' $w, $h
for ($y = 10; $y -le 116; $y++) {
    for ($x = 878; $x -le 1018; $x++) {
        $found = $false
        for ($dy = -3; $dy -le 3; $dy++) {
            for ($dx = -3; $dx -le 3; $dx++) {
                $nx = $x + $dx
                $ny = $y + $dy
                if ($nx -ge 0 -and $nx -lt $w -and $ny -ge 0 -and $ny -lt $h) {
                    if ($mask[$nx, $ny]) {
                        $found = $true
                        break
                    }
                }
            }
            if ($found) { break }
        }
        $dilated[$x, $y] = $found
    }
}

# Step 3: Fast iterative harmonic inpainting (Laplace diffusion)
# Initialize working color arrays
$rArr = New-Object 'double[,]' $w, $h
$gArr = New-Object 'double[,]' $w, $h
$bArr = New-Object 'double[,]' $w, $h

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $rArr[$x, $y] = [double]$c.R
        $gArr[$x, $y] = [double]$c.G
        $bArr[$x, $y] = [double]$c.B
    }
}

# 120 iterations of 4-neighbor Laplace smoothing inside dilated mask
for ($iter = 0; $iter -lt 120; $iter++) {
    for ($y = 10; $y -le 116; $y++) {
        for ($x = 878; $x -le 1018; $x++) {
            if ($dilated[$x, $y]) {
                $sumR = $rArr[$x - 1, $y] + $rArr[$x + 1, $y] + $rArr[$x, $y - 1] + $rArr[$x, $y + 1]
                $sumG = $gArr[$x - 1, $y] + $gArr[$x + 1, $y] + $gArr[$x, $y - 1] + $gArr[$x, $y + 1]
                $sumB = $bArr[$x - 1, $y] + $bArr[$x + 1, $y] + $bArr[$x, $y - 1] + $bArr[$x, $y + 1]
                
                $rArr[$x, $y] = $sumR / 4.0
                $gArr[$x, $y] = $sumG / 4.0
                $bArr[$x, $y] = $sumB / 4.0
            }
        }
    }
}

# Construct final image
$resBmp = New-Object System.Drawing.Bitmap($w, $h)
for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        if ($dilated[$x, $y]) {
            $nr = [Math]::Max(0, [Math]::Min(255, [int][Math]::Round($rArr[$x, $y])))
            $ng = [Math]::Max(0, [Math]::Min(255, [int][Math]::Round($gArr[$x, $y])))
            $nb = [Math]::Max(0, [Math]::Min(255, [int][Math]::Round($bArr[$x, $y])))
            $resBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($nr, $ng, $nb))
        } else {
            $resBmp.SetPixel($x, $y, $bmp.GetPixel($x, $y))
        }
    }
}

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_banner_clean.jpg", $jpegCodec, $encoderParams)
$resBmp.Save("c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_visual.jpg", $jpegCodec, $encoderParams)

$bmp.Dispose()
$resBmp.Dispose()

Write-Host "Harmonic inpainting complete!"
