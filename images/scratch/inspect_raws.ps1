Add-Type -AssemblyName System.Drawing

Get-ChildItem "images\products_crop\*raw*", "images\products_crop\*crop*", "images\*hero*" | ForEach-Object {
    try {
        $img = [System.Drawing.Bitmap]::FromFile($_.FullName)
        Write-Host "$($_.FullName) : $($img.Width) x $($img.Height)"
        $img.Dispose()
    } catch {}
}
