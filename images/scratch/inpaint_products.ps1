Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\orig_hero_raw.jpg"
$out1 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$out2 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg"
$out3 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg"

[Inpainter]::InpaintQuotation($src, $out1)
[Inpainter]::InpaintQuotation($src, $out2)
[Inpainter]::InpaintQuotation($src, $out3)

Write-Host "Products hero banner inpainting complete!"
