Add-Type -AssemblyName System.Drawing

function CheckBanner($path, $name) {
    $bmp = [System.Drawing.Bitmap]::FromFile($path)
    Write-Host "=== $name ($($bmp.Width) x $($bmp.Height)) ==="
    # check where non-white starts from bottom at X=50
    for ($y = $bmp.Height - 1; $y -ge 0; $y -= 5) {
        $p = $bmp.GetPixel(50, $y)
        if ($p.R -lt 240 -or $p.G -lt 240 -or $p.B -lt 240) {
            Write-Host "X=50 non-white at Y=$y (color: $($p.R), $($p.G), $($p.B))"
            break
        }
    }
    # check X=0
    for ($y = $bmp.Height - 1; $y -ge 0; $y -= 5) {
        $p = $bmp.GetPixel(0, $y)
        if ($p.R -lt 240 -or $p.G -lt 240 -or $p.B -lt 240) {
            Write-Host "X=0 non-white at Y=$y (color: $($p.R), $($p.G), $($p.B))"
            break
        }
    }
    $bmp.Dispose()
}

CheckBanner "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png" "Products"
CheckBanner "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png" "Services"
CheckBanner "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png" "Compliance"
CheckBanner "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner.png" "Contact"
