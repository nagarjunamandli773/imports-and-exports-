Add-Type -AssemblyName System.Drawing

$banners = @{
    "products"   = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png"
    "services"   = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png"
    "compliance" = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
    "insights"   = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png"
    "contact"    = "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner.png"
}

foreach ($key in $banners.Keys) {
    $src = $banners[$key]
    if (Test-Path $src) {
        $bmp = [System.Drawing.Bitmap]::FromFile($src)
        Write-Host "$key Banner: $($bmp.Width) x $($bmp.Height)"
        $out = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\banner_${key}_preview.png"
        $prevH = [int]($bmp.Height * (1200.0 / $bmp.Width))
        $prevBmp = New-Object System.Drawing.Bitmap(1200, $prevH)
        $g = [System.Drawing.Graphics]::FromImage($prevBmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.DrawImage($bmp, 0, 0, 1200, $prevH)
        $prevBmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
        $g.Dispose()
        $prevBmp.Dispose()
        $bmp.Dispose()
        Write-Host "Saved preview: $out"
    } else {
        Write-Host "MISSING: $src"
    }
}
