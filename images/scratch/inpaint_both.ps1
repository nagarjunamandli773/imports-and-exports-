$csharp = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class Inpainter {
    public static void InpaintQuotation(string srcPath, string outPath) {
        using (Bitmap bmp = new Bitmap(srcPath)) {
            int w = bmp.Width;
            int h = bmp.Height;
            
            bool[,] mask = new bool[w, h];
            
            // Step 1: Detect text
            for (int y = 10; y <= 122; y++) {
                for (int x = 860; x <= 1020; x++) {
                    Color c = bmp.GetPixel(x, y);
                    
                    bool isWhite = (c.R > 180 && c.G > 180 && c.B > 180) ||
                                   (c.R > 155 && c.G > 155 && c.B > 165 && Math.Abs(c.R - c.G) < 25);
                    bool isYellow = (c.R > 170 && c.G > 140 && c.B < 140);
                    bool isGlow = (c.R > 145 && c.G > 145 && c.B > 160 && y < 85) ||
                                  (c.R > 170 && c.G > 145 && c.B < 160 && y >= 80);
                                  
                    if (isWhite || isYellow || isGlow) {
                        mask[x, y] = true;
                    }
                }
            }
            
            // Step 2: Dilate mask by 3px
            bool[,] dilated = new bool[w, h];
            for (int y = 8; y <= 124; y++) {
                for (int x = 855; x <= 1022; x++) {
                    bool found = false;
                    for (int dy = -3; dy <= 3 && !found; dy++) {
                        for (int dx = -3; dx <= 3 && !found; dx++) {
                            int nx = x + dx;
                            int ny = y + dy;
                            if (nx >= 0 && nx < w && ny >= 0 && ny < h) {
                                if (mask[nx, ny]) found = true;
                            }
                        }
                    }
                    dilated[x, y] = found;
                }
            }
            
            // Step 3: Laplace diffusion (400 iterations)
            double[,] rArr = new double[w, h];
            double[,] gArr = new double[w, h];
            double[,] bArr = new double[w, h];
            
            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    Color c = bmp.GetPixel(x, y);
                    rArr[x, y] = c.R;
                    gArr[x, y] = c.G;
                    bArr[x, y] = c.B;
                }
            }
            
            for (int iter = 0; iter < 400; iter++) {
                for (int y = 8; y <= 124; y++) {
                    for (int x = 855; x <= 1022; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }
            
            // Step 4: Write to new bitmap
            using (Bitmap resBmp = new Bitmap(w, h)) {
                for (int y = 0; y < h; y++) {
                    for (int x = 0; x < w; x++) {
                        if (dilated[x, y]) {
                            int nr = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y])));
                            int ng = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y])));
                            int nb = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y])));
                            resBmp.SetPixel(x, y, Color.FromArgb(nr, ng, nb));
                        } else {
                            resBmp.SetPixel(x, y, bmp.GetPixel(x, y));
                        }
                    }
                }
                
                EncoderParameters ep = new EncoderParameters(1);
                ep.Param[0] = new EncoderParameter(Encoder.Quality, 100L);
                ImageCodecInfo jpegCodec = null;
                foreach (var c in ImageCodecInfo.GetImageEncoders()) {
                    if (c.MimeType == "image/jpeg") { jpegCodec = c; break; }
                }
                
                resBmp.Save(outPath, jpegCodec, ep);
            }
        }
    }
}
"@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

# Process Services Hero Banner
$srvSrc = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_raw.jpg"
$srvOut1 = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_banner_clean.jpg"
$srvOut2 = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\service_hero_visual.jpg"
[Inpainter]::InpaintQuotation($srvSrc, $srvOut1)
[Inpainter]::InpaintQuotation($srvSrc, $srvOut2)

# Process Products Hero Banner
$prodSrc = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\orig_hero_raw.jpg"
$prodOut1 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg"
$prodOut2 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg"
$prodOut3 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg"
[Inpainter]::InpaintQuotation($prodSrc, $prodOut1)
[Inpainter]::InpaintQuotation($prodSrc, $prodOut2)
[Inpainter]::InpaintQuotation($prodSrc, $prodOut3)

Write-Host "Both Services & Products banners successfully cleaned and saved!"
