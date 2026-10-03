Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class MasterBannerRemover {
    public static void ProcessMasterBanner(string masterSourcePath, string outPng1, string outPng2, string outJpg1, string outJpg2, string outJpg3) {
        using (Bitmap masterSrc = new Bitmap(masterSourcePath)) {
            Rectangle rect = new Rectangle(7, 5, 1011, 149);
            using (Bitmap bannerBmp = masterSrc.Clone(rect, masterSrc.PixelFormat)) {
                int w = bannerBmp.Width;
                int h = bannerBmp.Height;

                bool[,] mask = new bool[w, h];
                int offsetX = 840;

                // Step 1: Detect quote text and underline swoosh
                for (int y = 14; y <= 116; y++) {
                    for (int x = offsetX + 55; x < w - 3; x++) {
                        Color c = bannerBmp.GetPixel(x, y);

                        // Text pixels (cool white / cyan-white on twilight sky)
                        bool isWhiteText = (c.B >= 145 && c.G >= 140 && c.R >= 130 && (c.B - c.R) >= -18);
                        bool isBright = (c.R > 185 && c.G > 185 && c.B > 185);

                        // Swoosh line
                        double expectedSwooshY = 108.0 - (x - (offsetX + 66.0)) * 0.33;
                        bool isNearSwoosh = (x >= (offsetX + 66) && x <= (offsetX + 155) && Math.Abs(y - expectedSwooshY) <= 3.5);
                        bool isSwooshColor = (isNearSwoosh && c.R > 130 && c.G > 110 && (c.R + c.G) > (c.B * 1.6));

                        // Swoosh container touch
                        bool isContainerSwoosh = (x >= (offsetX + 66) && x <= (offsetX + 68) && y >= 106 && y <= 109 && c.R > 100 && c.G > 50);

                        if (isWhiteText || isBright || isSwooshColor || isContainerSwoosh) {
                            mask[x, y] = true;
                        }
                    }
                }

                // Step 2: Dilate mask by 2px (only for x >= offsetX + 54)
                bool[,] dilated = new bool[w, h];
                for (int y = 0; y < h; y++) {
                    for (int x = 0; x < w; x++) {
                        if (mask[x, y]) {
                            for (int dy = -2; dy <= 2; dy++) {
                                for (int dx = -2; dx <= 2; dx++) {
                                    int nx = x + dx;
                                    int ny = y + dy;
                                    if (nx >= (offsetX + 54) && nx < w && ny >= 12 && ny <= 118) {
                                        dilated[nx, ny] = true;
                                    }
                                }
                            }
                        }
                    }
                }

                Random rand = new Random(54321);

                using (Bitmap res = new Bitmap(bannerBmp)) {
                    // Pass 1: Container pillar vertical edge (x = offsetX + 64..68, y = 104..111)
                    for (int x = offsetX + 64; x <= offsetX + 68; x++) {
                        Color topCol = bannerBmp.GetPixel(x, 103);
                        Color botCol = bannerBmp.GetPixel(x, 112);
                        for (int y = 104; y <= 111; y++) {
                            if (dilated[x, y]) {
                                double t = (double)(y - 103) / 9.0;
                                int cr = (int)(topCol.R * (1 - t) + botCol.R * t);
                                int cg = (int)(topCol.G * (1 - t) + botCol.G * t);
                                int cb = (int)(topCol.B * (1 - t) + botCol.B * t);
                                res.SetPixel(x, y, Color.FromArgb(cr, cg, cb));
                                dilated[x, y] = false;
                            }
                        }
                    }

                    // Pass 2: Sky inpainting
                    for (int y = 12; y <= 118; y++) {
                        for (int x = offsetX + 54; x < w - 2; x++) {
                            if (!dilated[x, y]) continue;

                            int minAllowedX = (y >= 98) ? (offsetX + 69) : (offsetX + 53);

                            // Left sky sample
                            int lx = x - 1;
                            while (lx >= minAllowedX && dilated[lx, y]) { lx--; }
                            bool hasLeftSky = (lx >= minAllowedX);
                            Color cL = hasLeftSky ? res.GetPixel(lx, y) : Color.Black;

                            // Right sky sample
                            int rx = x + 1;
                            while (rx < w && dilated[rx, y]) { rx++; }
                            if (rx >= w) rx = w - 1;
                            Color cR = res.GetPixel(rx, y);

                            // Vertical sky samples
                            int ty = y - 1;
                            while (ty >= 10 && dilated[x, ty]) { ty--; }
                            if (ty < 10) ty = 10;
                            Color cT = res.GetPixel(x, ty);

                            int by = y + 1;
                            while (by <= 120 && dilated[x, by]) { by++; }
                            if (by > 120) by = 120;
                            Color cB = res.GetPixel(x, by);

                            double tyNorm = (by > ty) ? (double)(y - ty) / (by - ty) : 0.5;
                            double vR = cT.R * (1 - tyNorm) + cB.R * tyNorm;
                            double vG = cT.G * (1 - tyNorm) + cB.G * tyNorm;
                            double vB = cT.B * (1 - tyNorm) + cB.B * tyNorm;

                            double finalR, finalG, finalB;

                            if (hasLeftSky) {
                                double tx = (double)(x - lx) / (rx - lx);
                                double hR = cL.R * (1 - tx) + cR.R * tx;
                                double hG = cL.G * (1 - tx) + cR.G * tx;
                                double hB = cL.B * (1 - tx) + cR.B * tx;

                                finalR = hR * 0.75 + vR * 0.25;
                                finalG = hG * 0.75 + vG * 0.25;
                                finalB = hB * 0.75 + vB * 0.25;
                            } else {
                                double tx = Math.Min(1.0, (double)(x - minAllowedX) / (rx - minAllowedX));
                                finalR = vR * (1 - tx * 0.5) + cR.R * (tx * 0.5);
                                finalG = vG * (1 - tx * 0.5) + cR.G * (tx * 0.5);
                                finalB = vB * (1 - tx * 0.5) + cR.B * (tx * 0.5);
                            }

                            int grain = rand.Next(-1, 2);
                            int rOut = Math.Max(0, Math.Min(255, (int)Math.Round(finalR + grain)));
                            int gOut = Math.Max(0, Math.Min(255, (int)Math.Round(finalG + grain)));
                            int bOut = Math.Max(0, Math.Min(255, (int)Math.Round(finalB + grain)));

                            res.SetPixel(x, y, Color.FromArgb(rOut, gOut, bOut));
                        }
                    }

                    // Save PNG files
                    res.Save(outPng1, ImageFormat.Png);
                    res.Save(outPng2, ImageFormat.Png);

                    // Save JPEG files at 100% quality
                    EncoderParameters ep = new EncoderParameters(1);
                    ep.Param[0] = new EncoderParameter(Encoder.Quality, 100L);
                    ImageCodecInfo jpegCodec = null;
                    foreach (var c in ImageCodecInfo.GetImageEncoders()) {
                        if (c.MimeType == "image/jpeg") { jpegCodec = c; break; }
                    }

                    res.Save(outJpg1, jpegCodec, ep);
                    res.Save(outJpg2, jpegCodec, ep);
                    res.Save(outJpg3, jpegCodec, ep);
                }
            }
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$masterSrc = 'C:\Users\Administrator\.gemini\antigravity-ide\brain\ea21af82-ae3e-4d35-a07d-c2f3baf39539\.user_uploaded\media_1789971937755.jpg'
$outPng1 = 'c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png'
$outPng2 = 'c:\Users\Administrator\Pictures\emports and exports\images\product_hero_banner.png'
$outJpg1 = 'c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped.jpg'
$outJpg2 = 'c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg'
$outJpg3 = 'c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_visual.jpg'

[MasterBannerRemover]::ProcessMasterBanner($masterSrc, $outPng1, $outPng2, $outJpg1, $outJpg2, $outJpg3)
Write-Host "Master banner cleaned and all formats saved successfully!"
