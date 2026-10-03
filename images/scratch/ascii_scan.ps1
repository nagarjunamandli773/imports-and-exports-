Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('C:\Users\Administrator\.gemini\antigravity-ide\brain\984eced1-f394-4a1f-bcf5-919d9d5f0246\.user_uploaded\media_1790328141521.png')

# Print row y=35 (middle of navbar text) from x=160 to x=220
Write-Host "Row y=35 (text baseline):"
$line = ""
for ($x = 160; $x -lt 225; $x++) {
    $p = $bmp.GetPixel($x, 35)
    if ($p.R -lt 100 -and $p.G -lt 100 -and $p.B -lt 100) {
        $line += "#"
    } else {
        $line += "."
    }
}
Write-Host "x=160: $line :x=224"

# Print row y=42 (bottom of EXIM letters)
Write-Host "Row y=42:"
$line2 = ""
for ($x = 160; $x -lt 225; $x++) {
    $p = $bmp.GetPixel($x, 42)
    if ($p.R -lt 100 -and $p.G -lt 100 -and $p.B -lt 100) {
        $line2 += "#"
    } else {
        $line2 += "."
    }
}
Write-Host "x=160: $line2 :x=224"
$bmp.Dispose()
