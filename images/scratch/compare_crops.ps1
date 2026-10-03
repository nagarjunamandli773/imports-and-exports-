Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790300743947.png')
$cleanRight = [System.Drawing.Bitmap]::FromFile('c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg')

# Crop the quote region from media_1790300743947.png (e.g. x: 800..1023, y: 0..151)
$rect1 = New-Object System.Drawing.Rectangle(820, 0, 200, 150)
$crop1 = $src.Clone($rect1, $src.PixelFormat)
$crop1.Save('c:\Users\Administrator\Pictures\emports and exports\images\scratch\user_uploaded_right.png')

# Crop the same region from cleanRight (x: 812..1011, y: 0..148)
$rect2 = New-Object System.Drawing.Rectangle(812, 0, [Math]::Min(199, $cleanRight.Width - 812), [Math]::Min(148, $cleanRight.Height))
$crop2 = $cleanRight.Clone($rect2, $cleanRight.PixelFormat)
$crop2.Save('c:\Users\Administrator\Pictures\emports and exports\images\scratch\clean_right_crop.png')

$src.Dispose()
$cleanRight.Dispose()
$crop1.Dispose()
$crop2.Dispose()

Write-Host "Crops saved."
