Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789352957061.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropImage($x, $y, $w, $h, $outFile, $format) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $src.Clone($rect, $src.PixelFormat)
    if ($format -eq "png") {
      $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)
    } else {
      $crop.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }
    $crop.Dispose()
    Write-Output "Done $outFile"
}

CropImage 45 4 155 32 "c:\Users\Administrator\Pictures\emports and exports\images\ref_logo.png" "png"
# Hero visual: x: 412, y: 35, w: 612, h: 224
CropImage 412 35 612 224 "c:\Users\Administrator\Pictures\emports and exports\images\hero_visual_clean.jpg" "jpg"
# Building: x: 0, y: 256, w: 284, h: 168
CropImage 0 256 284 168 "c:\Users\Administrator\Pictures\emports and exports\images\building_clean.jpg" "jpg"
# Handshake: x: 788, y: 271, w: 206, h: 81
CropImage 788 271 206 81 "c:\Users\Administrator\Pictures\emports and exports\images\handshake_clean.jpg" "jpg"
# Footer network: x: 600, y: 526, w: 424, h: 48
CropImage 600 526 424 48 "c:\Users\Administrator\Pictures\emports and exports\images\footer_network_clean.jpg" "jpg"

$src.Dispose()
