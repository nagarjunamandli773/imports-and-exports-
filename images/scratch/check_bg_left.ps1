Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$bmp = [System.Drawing.Bitmap]::FromFile($src)

Write-Host "--- Checking Background Pixels on Left Side ---"
# Check background at various empty spots
$points = @(
    @{X=10; Y=10},
    @{X=100; Y=20},
    @{X=200; Y=30},
    @{X=300; Y=40},
    @{X=10; Y=80},
    @{X=10; Y=140},
    @{X=10; Y=180},
    @{X=10; Y=220},
    @{X=200; Y=210},
    @{X=350; Y=180}
)

foreach ($pt in $points) {
    $c = $bmp.GetPixel($pt.X, $pt.Y)
    Write-Host "Point ($($pt.X), $($pt.Y)): R=$($c.R), G=$($c.G), B=$($c.B)"
}

# Check where the background starts having blue/sky/clouds or the world map
for ($x = 200; $x -le 500; $x += 20) {
    $c = $bmp.GetPixel($x, 30)
    Write-Host "X=$x, Y=30: R=$($c.R), G=$($c.G), B=$($c.B)"
}

$bmp.Dispose()
