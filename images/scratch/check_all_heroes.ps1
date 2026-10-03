$pages = @(
    "index.html",
    "about.html",
    "services.html",
    "products.html",
    "compliance.html",
    "global-presence.html",
    "insights.html",
    "contact.html",
    "dashboard.html",
    "cart.html"
)

foreach ($page in $pages) {
    $path = "c:\Users\Administrator\Pictures\emports and exports\$page"
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        Write-Host "================== $page =================="
        # Find section containing hero
        if ($content -match '<section[^>]*hero[^>]*>([\s\S]*?)</section>') {
            $heroBlock = $matches[0]
            # Extract any <img> tags
            $imgs = [regex]::Matches($heroBlock, '<img[^>]+>')
            foreach ($img in $imgs) {
                Write-Host "IMG: $($img.Value)"
            }
            # Extract h1 or titles
            $titles = [regex]::Matches($heroBlock, '<h[1-3][^>]*>([\s\S]*?)</h[1-3]>')
            foreach ($t in $titles) {
                Write-Host "TITLE: $($t.Value -replace '\s+', ' ')"
            }
        } else {
            Write-Host "No <section ...hero...> found!"
            # check for hero-panorama or banner
            $imgs = [regex]::Matches($content, '<img[^>]+(banner|hero)[^>]+>')
            foreach ($img in $imgs) {
                Write-Host "FOUND IMG: $($img.Value)"
            }
        }
    }
}
