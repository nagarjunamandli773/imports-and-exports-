$imgs = @(
    "images/background images/Turmeric Powder.png",
    "images/background images/Sunflower Oil.png",
    "images/background images/Kashmiri Saffron (Kesar).png",
    "images/background images/Yellow Moong Dal.png",
    "images/background images/Golden Raisins (Kishmish).png"
)

foreach ($img in $imgs) {
    $encoded = [System.Uri]::EscapeUriString($img)
    $url = "http://localhost:3000/$encoded"
    try {
        $res = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
        Write-Host "$img -> Status $($res.StatusCode)"
    } catch {
        Write-Host "$img -> Failed: $_"
    }
}
