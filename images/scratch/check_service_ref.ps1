Add-Type -AssemblyName System.Drawing

function Check-File($path) {
    if (Test-Path $path) {
        $b = [System.Drawing.Bitmap]::FromFile($path)
        Write-Host "$path : $($b.Width) x $($b.Height)"
        $b.Dispose()
    } else {
        Write-Host "NOT FOUND: $path"
    }
}

Check-File 'C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790300743947.png'
Check-File 'c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png'
Check-File 'c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg'
Check-File 'c:\Users\Administrator\Pictures\emports and exports\images\hero_banner.jpg'
