Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class QuoteRemover {
    public static Bitmap RemoveQuote(Bitmap src) {
        int w = src.Width;
        int h = src.Height;

        bool[,] mask = new bool[w, h];
        int offsetX = 840;

        // Step 1: Detect quote text and underline swoosh
        for (int y = 14; y <= 120; y++) {
            for (int x = offsetX + 50; x < w - 3; x++) {
                Color c = src.GetPixel(x, y);

                // Text pixels (cool white / cyan-white / gold swoosh on twilight sky)
                bool isWhiteText = (c.B >= 140 && c.G >= 135 && c.R >= 125 && (c.B - c.R) >= -22);
                bool isBright = (c.R > 180 && c.G > 180 && c.B > 180);

                // Swoosh line
                double expectedSwooshY = 108.0 - (x - (offsetX + 66.0)) * 0.33;
                bool isNearSwoosh = (x >= (offsetX + 60) && x <= (offsetX + 160) && Math.Abs(y - expectedSwooshY) <= 4.0);
                bool isSwooshColor = (isNearSwoosh && c.R > 125 && c.G > 105 && (c.R + c.G) > (c.B * 1.5));

                // Swoosh container touch
                bool isContainerSwoosh = (x >= (offsetX + 60) && x <= (offsetX + 72) && y >= 104 && y <= 112 && c.R > 90 && c.G > 45);

                // Upper curved arc near crane
                bool isUpperArc = (x >= (offsetX + 50) && x <= (offsetX + 115) && y >= 14 && y <= 40 && c.R > 150 && c.G > 130 && c.B < 120);

                if (isWhiteText || isBright || isSwooshColor || isContainerSwoosh || isUpperArc) {
                    mask[x, y] = true;
                }
            }
        }

        // Step 2: Dilate mask by 2px (only for x >= offsetX + 48)
        bool[,] dilated = new bool[w, h];
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                if (mask[x, y]) {
                    for (int dy = -2; dy <= 2; dy++) {
                        for (int dx = -2; dx <= 2; dx++) {
                            int nx = x + dx;
                            int ny = y + dy;
                            if (nx >= (offsetX + 48) && nx < w && ny >= 10 && ny <= 122) {
                                dilated[nx, ny] = true;
                            }
                        }
                    }
                }
            }
        }

        Random rand = new Random(54321);
        Bitmap res = new Bitmap(src);

        // Pass 1: Container pillar vertical edge (x = offsetX + 64..68, y = 104..111)
        for (int x = offsetX + 64; x <= offsetX + 68; x++) {
            Color topCol = src.GetPixel(x, 103);
            Color botCol = src.GetPixel(x, 112);
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
        for (int y = 10; y <= 122; y++) {
            for (int x = offsetX + 48; x < w - 2; x++) {
                if (!dilated[x, y]) continue;

                int minAllowedX = (y >= 98) ? (offsetX + 69) : (offsetX + 47);

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
                while (ty >= 8 && dilated[x, ty]) { ty--; }
                if (ty < 8) ty = 8;
                Color cT = res.GetPixel(x, ty);

                int by = y + 1;
                while (by <= 124 && dilated[x, by]) { by++; }
                if (by > 124) by = 124;
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

        return res;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$srcPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790298228335.png"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$clean = [QuoteRemover]::RemoveQuote($src)
$clean.Save("images\scratch\test_inpaint_quote.png", [System.Drawing.Imaging.ImageFormat]::Png)
$src.Dispose()
$clean.Dispose()
Write-Host "Test inpaint saved!"
