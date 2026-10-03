Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\f655749b-d2b5-4f5e-871e-bde76c48124e\.user_uploaded\media_1790153176150.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "Finding white/bright border of the capsule:"
# Capsule border has alpha or white outline (R,G,B > 80, close to equal)
for ($y = 95; $y -le 148; $y++) {
    for ($x = 735; $x -le 760; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 100 -and $c.G -gt 100 -and $c.B -gt 100) {
            # Check if it's the capsule left edge
            # Write-Host "Bright pixel at X=$x, Y=$y : $($c.R) $($c.G) $($c.B)"
        }
    }
}

# Find vertical divider lines inside the capsule (between Safety, Integrity, Excellence, Sustainability)
Write-Host "Checking vertical dividers across Y=115-135:"
for ($x = 750; $x -le 990; $x++) {
    $brightCount = 0
    for ($y = 110; $y -le 140; $y++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 60 -and $c.G -gt 80 -and $c.B -gt 100) { $brightCount++ }
    }
    if ($brightCount -gt 20) {
        Write-Host "Potential divider or icon column at X=$x (brightCount=$brightCount)"
    }
}

$bmp.Dispose()
