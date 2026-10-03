Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class PreciseInpaint3 {
    public static Bitmap Inpaint(Bitmap src) {
        int w = src.Width;
        int h = src.Height;

        bool[,] mask = new bool[w, h];

        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                // Strictly protect buildings
                if (x <= 74 && y >= 104) continue;

                Color c = src.GetPixel(x, y);

                // 1. "Your" (strictly x: 64..118, y: 25..46)
                bool inYour = (x >= 64 && x <= 118 && y >= 25 && y <= 46);
                bool isYour = inYour && (
                    (c.R + c.G + c.B > 430) ||
                    (c.R > 135 && c.G > 145 && c.B > 160) ||
                    (c.R > 120 && c.G > 130 && c.B > 168)
                );

                // 2. "Global Trade" (strictly x: 50..168, y: 44..76)
                bool inGlobalTrade = (x >= 50 && x <= 168 && y >= 44 && y <= 76);
                bool isGlobalTrade = inGlobalTrade && (
                    (c.R + c.G + c.B > 425) ||
                    (c.R > 135 && c.G > 145 && c.B > 160) ||
                    (c.R > 120 && c.G > 130 && c.B > 168) ||
                    (c.R > 155 && c.G > 150 && c.B > 140)
                );

                // 3. "Partner" (strictly x: 64..142, y: 72..98)
                bool inPartner = (x >= 64 && x <= 142 && y >= 72 && y <= 98);
                bool isPartner = inPartner && (
                    (c.R + c.G + c.B > 430) ||
                    (c.R > 150 && c.G > 150 && c.B > 145) ||
                    (c.R > 170 && c.G > 165 && c.B > 135) ||
                    (c.R > 140 && c.G > 140 && c.B > 160)
                );

                // 4. Gold Swoosh (strictly near line, strictly gold)
                double swooshY = 108.0 - (x - 65.0) * 0.316;
                bool isNearSwoosh = (x >= 74 && x <= 162 && Math.Abs(y - swooshY) <= 3.2);
                bool isGold = isNearSwoosh && (
                    (c.R > 165 && c.G > 125 && c.B < 135 && (c.R - c.B) > 40) ||
                    (c.R > 190 && c.G > 150 && c.B < 145)
                );

                if (isYour || isGlobalTrade || isPartner || isGold) {
                    mask[x, y] = true;
                }
            }
        }

        // Dilate mask by 2px (circular)
        bool[,] dilated = new bool[w, h];
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                // Strictly exclude buildings, crane, and borders
                if (x <= 46 || (x <= 74 && y >= 104) || y <= 21 || y >= 106 || x >= 172) continue;

                bool found = false;
                for (int dy = -2; dy <= 2 && !found; dy++) {
                    for (int dx = -2; dx <= 2 && !found; dx++) {
                        if (dx * dx + dy * dy <= 5) {
                            int nx = x + dx;
                            int ny = y + dy;
                            if (nx >= 0 && nx < w && ny >= 0 && ny < h) {
                                if (mask[nx, ny]) found = true;
                            }
                        }
                    }
                }
                dilated[x, y] = found;
            }
        }

        // Color arrays for Laplace PDE diffusion
        double[,] rArr = new double[w, h];
        double[,] gArr = new double[w, h];
        double[,] bArr = new double[w, h];

        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                Color c = src.GetPixel(x, y);
                rArr[x, y] = c.R;
                gArr[x, y] = c.G;
                bArr[x, y] = c.B;
            }
        }

        // 400 iterations of Laplace diffusion
        for (int iter = 0; iter < 400; iter++) {
            for (int y = 22; y < 106; y++) {
                for (int x = 47; x < 172; x++) {
                    if (dilated[x, y]) {
                        double avgR = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                        double avgG = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                        double avgB = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;

                        rArr[x, y] = avgR;
                        gArr[x, y] = avgG;
                        bArr[x, y] = avgB;
                    }
                }
            }
        }

        Random rand = new Random(24680);
        Bitmap res = new Bitmap(w, h, PixelFormat.Format32bppArgb);
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                if (dilated[x, y]) {
                    int grain = rand.Next(-1, 2);
                    int r = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y] + grain)));
                    int g = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y] + grain)));
                    int b = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y] + grain)));
                    res.SetPixel(x, y, Color.FromArgb(r, g, b));
                } else {
                    res.SetPixel(x, y, src.GetPixel(x, y));
                }
            }
        }

        using (Bitmap maskBmp = new Bitmap(w, h)) {
            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    if (dilated[x, y]) maskBmp.SetPixel(x, y, Color.Red);
                    else maskBmp.SetPixel(x, y, src.GetPixel(x, y));
                }
            }
            maskBmp.Save("images\\scratch\\test_precise3_mask.png", ImageFormat.Png);
        }

        return res;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$cropBmp = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')
$outBmp = [PreciseInpaint3]::Inpaint($cropBmp)
$outBmp.Save('images\scratch\test_precise3_inpaint.png', [System.Drawing.Imaging.ImageFormat]::Png)

$cropBmp.Dispose()
$outBmp.Dispose()
Write-Host "Precise inpaint 3 complete!"
