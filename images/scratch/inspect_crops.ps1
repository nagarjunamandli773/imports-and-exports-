Add-Type -AssemblyName System.Drawing

function InspectImg($path) {
    if (Test-Path $path) {
        $bmp = [System.Drawing.Bitmap]::FromFile($path)
        Write-Host "File: $path ($($bmp.Width) x $($bmp.Height))"
        # Sample left side Y=50
        $c = $bmp.GetPixel(50, 50)
        Write-Host "  Pixel (50, 50): $($c.R), $($c.G), $($c.B)"
        # Sample bottom left Y=H-10
        $cBottom = $bmp.GetPixel(50, $bmp.Height - 10)
        Write-Host "  Pixel (50, H-10): $($cBottom.R), $($cBottom.G), $($cBottom.B)"
        # Sample bottom right
        $cBR = $bmp.GetPixel($bmp.Width - 50, $bmp.Height - 10)
        Write-Host "  Pixel (W-50, H-10): $($cBR.R), $($cBR.G), $($cBR.B)"
        $bmp.Dispose()
    }
}

InspectImg "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\orig_hero_raw.jpg"
InspectImg "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
InspectImg "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg"
InspectImg "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\scaled_clean_preview.jpg"
