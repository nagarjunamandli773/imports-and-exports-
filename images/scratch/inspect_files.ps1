Add-Type -AssemblyName System.Drawing
$targets = @(
    'images/hero_banner.jpg',
    'images/hero_banner_1789192903484.jpg',
    'images/hero_visual_clean.jpg',
    'images/hero_visual_exact.jpg',
    'images/home_hero_banner.png',
    'images/home_hero_master_4x.png',
    'images/scratch/prev_test.png',
    'images/scratch/home_current.png',
    'images/scratch/test_impressive_navy_hero.png',
    'images/dashboard_crop/dashboard_hero_ship_clear.jpg'
)

foreach ($t in $targets) {
    if (Test-Path $t) {
        $img = [System.Drawing.Image]::FromFile((Resolve-Path $t))
        Write-Host "$t -> $($img.Width) x $($img.Height)"
        $img.Dispose()
    } else {
        Write-Host "$t -> NOT FOUND"
    }
}
