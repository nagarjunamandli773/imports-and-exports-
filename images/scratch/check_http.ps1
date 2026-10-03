$res = Invoke-WebRequest -Uri 'http://localhost:3000/products.html' -UseBasicParsing
Write-Host "HTTP Status:" $res.StatusCode
Write-Host "Page size:" $res.Content.Length "bytes"

$imgRes = Invoke-WebRequest -Uri 'http://localhost:3000/images/products_crop/product_hero_banner.png' -UseBasicParsing
Write-Host "Banner image status:" $imgRes.StatusCode
Write-Host "Banner image size:" $imgRes.Content.Length "bytes"
