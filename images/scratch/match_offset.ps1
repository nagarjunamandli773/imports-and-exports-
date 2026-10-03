Add-Type -AssemblyName System.Drawing

$u = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')
$t = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg')

Write-Host "User uploaded: $($u.Width) x $($u.Height)"
Write-Host "Template: $($t.Width) x $($t.Height)"

$bestDiff = [long]::MaxValue
$bestOx = 0
$bestOy = 0
for ($oy = -5; $oy -le 10; $oy++) {
    for ($ox = -5; $ox -le 10; $ox++) {
        $diff = 0L
        for ($y = 20; $y -lt 120; $y += 10) {
            for ($x = 30; $x -lt 500; $x += 20) {
                $ty = $y + $oy
                $tx = $x + $ox
                if ($tx -ge 0 -and $tx -lt $t.Width -and $ty -ge 0 -and $ty -lt $t.Height) {
                    $cu = $u.GetPixel($x, $y)
                    $ct = $t.GetPixel($tx, $ty)
                    $diff += [Math]::Abs($cu.R - $ct.R) + [Math]::Abs($cu.G - $ct.G) + [Math]::Abs($cu.B - $ct.B)
                }
            }
        }
        if ($diff -lt $bestDiff) {
            $bestDiff = $diff
            $bestOx = $ox
            $bestOy = $oy
        }
    }
}

Write-Host "Best offset between template and user image: ox=$bestOx, oy=$bestOy (diff=$bestDiff)"

$u.Dispose()
$t.Dispose()
