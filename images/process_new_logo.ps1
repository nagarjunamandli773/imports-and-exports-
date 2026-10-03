Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\68b66b9b-2f54-4177-89bf-c32635ad52cc\.user_uploaded\media_1789795169490.png"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)

Write-Output "Source Logo Dimensions: $($src.Width) x $($src.Height)"

# Create a transparent background version
$transparentBmp = New-Object System.Drawing.Bitmap($src.Width, $src.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($x = 0; $x -lt $src.Width; $x++) {
    for ($y = 0; $y -lt $src.Height; $y++) {
        $pixel = $src.GetPixel($x, $y)
        # If pixel is near pure white, make it transparent
        if ($pixel.R -gt 242 -and $pixel.G -gt 242 -and $pixel.B -gt 242) {
            $transparentBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        } else {
            # Smooth edge antialiasing for near-white boundary pixels
            if ($pixel.R -gt 220 -and $pixel.G -gt 220 -and $pixel.B -gt 220) {
                $avg = ($pixel.R + $pixel.G + $pixel.B) / 3.0
                $alpha = [int](255 * (255 - $avg) / 35.0)
                if ($alpha -lt 0) { $alpha = 0 }
                if ($alpha -gt 255) { $alpha = 255 }
                $transparentBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, $pixel.R, $pixel.G, $pixel.B))
            } else {
                $transparentBmp.SetPixel($x, $y, $pixel)
            }
        }
    }
}

# Save full transparent logo
$fullOut = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo_full.png"
$transparentBmp.Save($fullOut, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Saved $fullOut"

# Crop the main top brand logo (excluding the bottom 5-icon service strip if desired, or preserving full branding)
# Let's crop from y = 10 to y = [int]($src.Height * 0.72) for the primary header logo
$headerH = [int]($src.Height * 0.72)
$rectHeader = New-Object System.Drawing.Rectangle(10, 10, ($src.Width - 20), ($headerH - 10))
$headerLogo = $transparentBmp.Clone($rectHeader, $transparentBmp.PixelFormat)

$logoOut = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo.png"
$headerLogo.Save($logoOut, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Saved $logoOut"

$logoOut3x = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo@3x.png"
$headerLogo.Save($logoOut3x, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Saved $logoOut3x"

# Also save full version as concept_exim_logo_banner.png
$bannerOut = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo_banner.png"
$src.Save($bannerOut, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Saved $bannerOut"

# Create White Inverted Version for Dark Footers
$whiteBmp = New-Object System.Drawing.Bitmap($headerLogo.Width, $headerLogo.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
for ($x = 0; $x -lt $headerLogo.Width; $x++) {
    for ($y = 0; $y -lt $headerLogo.Height; $y++) {
        $p = $headerLogo.GetPixel($x, $y)
        if ($p.A -gt 10) {
            # Check if it's golden or dark navy
            # Gold colors: R > 150, G > 100, B < 100
            if ($p.R -gt 150 -and $p.G -gt 100 -and $p.B -lt 120) {
                # Keep golden color
                $whiteBmp.SetPixel($x, $y, $p)
            } else {
                # Turn navy/dark to bright white
                $whiteBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, 255, 255, 255))
            }
        } else {
            $whiteBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$whiteOut = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo_white.png"
$whiteBmp.Save($whiteOut, [System.Drawing.Imaging.ImageFormat]::Png)
$whiteOut3x = "c:\Users\Administrator\Pictures\emports and exports\images\concept_exim_logo_white@3x.png"
$whiteBmp.Save($whiteOut3x, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Saved $whiteOut and $whiteOut3x"

$whiteBmp.Dispose()
$headerLogo.Dispose()
$transparentBmp.Dispose()
$src.Dispose()

Write-Output "All logo assets processed successfully!"
