Add-Type -AssemblyName System.Drawing
$files = @(
    'c:\Users\Administrator\Pictures\emports and exports\images\hero_banner.jpg',
    'c:\Users\Administrator\Pictures\emports and exports\images\home_hero_master_4x.png',
    'c:\Users\Administrator\Pictures\emports and exports\images\hero_visual_clean.jpg',
    'c:\Users\Administrator\Pictures\emports and exports\images\hero_collage_crop.jpg'
)
foreach ($f in $files) {
    if (Test-Path $f) {
        $b = [System.Drawing.Bitmap]::FromFile($f)
        Write-Host "$f -> $($b.Width)x$($b.Height)"
        $b.Dispose()
    }
}
