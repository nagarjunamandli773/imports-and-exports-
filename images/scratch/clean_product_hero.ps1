Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class ProductHeroCleaner {
    public static void CleanAndScale(string srcPath, string out1xClean, string out4kClean) {
        using (Bitmap src = new Bitmap(srcPath)) {
            int w = src.Width;
            int h = src.Height;
            Bitmap clean1x = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(clean1x)) {
                g.DrawImage(src, 0, 0);
            }

            // Identify text area: X from 35 to 450, Y from 15 to 240
            bool[,] mask = new bool[w, h];
            for (int y = 15; y <= 240; y++) {
                for (int x = 35; x <= 450; x++) {
                    Color p = src.GetPixel(x, y);
                    // Any pixel darker than background or colored
                    if (p.R < 238 || p.G < 238 || p.B < 238 || (p.R > 210 && p.B < 170)) {
                        mask[x, y] = true;
                    }
                }
            }

            // Dilate mask by 3px
            bool[,] dilated = new bool[w, h];
            for (int y = 12; y <= 243; y++) {
                for (int x = 32; x <= 453; x++) {
                    bool found = false;
                    for (int dy = -3; dy <= 3 && !found; dy++) {
                        for (int dx = -3; dx <= 3 && !found; dx++) {
                            if (dx * dx + dy * dy <= 9) {
                                int nx = x + dx;
                                int ny = y + dy;
                                if (nx >= 35 && nx <= 450 && ny >= 15 && ny <= 240) {
                                    if (mask[nx, ny]) found = true;
                                }
                            }
                        }
                    }
                    dilated[x, y] = found;
                }
            }

            // Laplace PDE diffusion
            double[,] rArr = new double[w, h];
            double[,] gArr = new double[w, h];
            double[,] bArr = new double[w, h];
            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    Color p = src.GetPixel(x, y);
                    rArr[x, y] = p.R;
                    gArr[x, y] = p.G;
                    bArr[x, y] = p.B;
                }
            }

            for (int iter = 0; iter < 400; iter++) {
                for (int y = 12; y <= 243; y++) {
                    for (int x = 32; x <= 453; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }

            for (int y = 12; y <= 243; y++) {
                for (int x = 32; x <= 453; x++) {
                    if (dilated[x, y]) {
                        int r = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y])));
                        int gCol = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y])));
                        int b = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y])));
                        clean1x.SetPixel(x, y, Color.FromArgb(r, gCol, b));
                    }
                }
            }

            clean1x.Save(out1xClean, ImageFormat.Png);

            // Scale to 4K (4096 x 1364)
            int targetW = 4096;
            int targetH = (int)(h * (4096.0 / w));
            using (Bitmap hires = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics gHires = Graphics.FromImage(hires)) {
                    gHires.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    gHires.SmoothingMode = SmoothingMode.HighQuality;
                    gHires.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    gHires.CompositingQuality = CompositingQuality.HighQuality;
                    gHires.DrawImage(clean1x, 0, 0, targetW, targetH);
                }
                hires.Save(out4kClean, ImageFormat.Png);
            }

            clean1x.Dispose();
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies "System.Drawing"

$src = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner_user_1x.png"
$clean1x = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_1x.png"
$clean4k = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_4k.png"

[ProductHeroCleaner]::CleanAndScale($src, $clean1x, $clean4k)
Write-Host "Cleaned banners generated successfully!"
