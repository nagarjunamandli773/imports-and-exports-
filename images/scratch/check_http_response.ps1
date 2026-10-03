try {
    $r = Invoke-WebRequest -Uri 'http://localhost:3000/contact.html' -UseBasicParsing
    Write-Host "contact.html status: $($r.StatusCode)"
    $rImg = Invoke-WebRequest -Uri 'http://localhost:3000/images/contact_crop/contact_hero_banner.png' -UseBasicParsing
    Write-Host "contact_hero_banner.png status: $($rImg.StatusCode) ($($rImg.RawContentLength) bytes)"
} catch {
    Write-Host "Error: $_"
}
