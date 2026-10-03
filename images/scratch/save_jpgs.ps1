Add-Type -AssemblyName System.Drawing

function Save-Jpg($srcPng, $destJpg) {
    $bmp = [System.Drawing.Bitmap]::FromFile($srcPng)
    $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $bmp.Save($destJpg, $codec, $ep)
    $bmp.Dispose()
    Write-Host "Updated JPG: $destJpg"
}

Save-Jpg "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png" "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.jpg"
Save-Jpg "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png" "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.jpg"
Save-Jpg "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png" "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.jpg"
Save-Jpg "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png" "c:\Users\Administrator\Pictures\emports and exports\images\services_hero_banner.jpg"
