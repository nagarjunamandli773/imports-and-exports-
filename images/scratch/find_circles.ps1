Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Look for gold circle borders (R > 220, G > 160, B < 60) between Y=215 and Y=260
for ($b = 1; $b -le 4; $b++) {
    $minX = ($b - 1) * 105
    $maxX = $b * 110 + 20
    Write-Host "--- Scanning Badge $b ($minX to $maxX) ---"
    $found = @()
    for ($y = 215; $y -le 260; $y++) {
        for ($x = $minX; $x -le $maxX; $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -gt 220 -and $c.G -gt 150 -and $c.B -lt 60) {
                $found += [PSCustomObject]@{ X = $x; Y = $y }
            }
        }
    }
    if ($found.Count -gt 0) {
        $minFoundX = ($found | Measure-Object -Property X -Minimum).Minimum
        $maxFoundX = ($found | Measure-Object -Property X -Maximum).Maximum
        $minFoundY = ($found | Measure-Object -Property Y -Minimum).Minimum
        $maxFoundY = ($found | Measure-Object -Property Y -Maximum).Maximum
        $centerX = ($minFoundX + $maxFoundX) / 2
        $centerY = ($minFoundY + $maxFoundY) / 2
        $w = $maxFoundX - $minFoundX
        $h = $maxFoundY - $minFoundY
        Write-Host "Badge $b circle: Center=($centerX, $centerY), Width=$w, Height=$h"
    } else {
        Write-Host "Badge $b circle: No gold border found (might be solid navy or different color)"
    }
}

$bmp.Dispose()
