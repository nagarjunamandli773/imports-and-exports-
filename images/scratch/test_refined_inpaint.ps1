Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class RefinedInpaint {
    public static Bitmap Inpaint(Bitmap src) {
        int w = src.Width;
        int h = src.Height;

        bool[,] mask = new bool[w, h];

        // Mask exclusively the text and swoosh
        for (int y = 14; y < 115; y++) {
            for (int x = 45; x < w - 2; x++) {
                Color c = src.GetPixel(x, y);

                // Swoosh line formula: Y ≈ 108 - (X - 65) * 0.316
                double swooshY = 108.0 - (x - 65.0) * 0.316;
                bool isNearSwoosh = (x >= 63 && x <= 162 && Math.Abs(y - swooshY) <= 3.5);
                bool isGold = isNearSwoosh && (c.R > 140 && c.G > 105 && (c.R - c.B) > 25);

                // Text letters: White / pale cyan cursive on twilight sky
                // Restrict text to y <= 98 to never touch buildings
                bool inTextRegion = (x >= 48 && x <= 170 && y >= 16 && y <= 98);
                bool isText = inTextRegion && (
                    (c.R > 150 && c.G > 155 && c.B > 165) ||
                    (c.R > 185 && c.G > 185 && c.B > 185) ||
                    (c.R > 130 && c.G > 140 && c.B > 175) ||
                    (c.R > 160 && c.G > 150 && c.B > 140 && y >= 70 && y <= 98) // "Partner" warm letters
                );

                if (isGold || isText) {
                    mask[x, y] = true;
                }
            }
        }

        // Dilate mask by 1.5 pixels
        bool[,] dilated = new bool[w, h];
        for (int y = 12; y < 116; y++) {
            for (int x = 43; x < w - 1; x++) {
                bool found = false;
                for (int dy = -2; dy <= 2 && !found; dy++) {
                    for (int dx = -2; dx <= 2 && !found; dx++) {
                        if (Math.Abs(dx) + Math.Abs(dy) <= 3) {
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

        // 350 iterations of Laplace diffusion
        for (int iter = 0; iter < 350; iter++) {
            for (int y = 14; y < 115; y++) {
                for (int x = 44; x < w - 2; x++) {
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

        Random rand = new Random(12345);
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

        // Also save mask visualization for debugging
        using (Bitmap maskBmp = new Bitmap(w, h)) {
            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    if (dilated[x, y]) maskBmp.SetPixel(x, y, Color.Red);
                    else maskBmp.SetPixel(x, y, src.GetPixel(x, y));
                }
            }
            maskBmp.Save("images\\scratch\\test_refined_mask.png", ImageFormat.Png);
        }

        return res;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$cropBmp = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')
$outBmp = [RefinedInpaint]::Inpaint($cropBmp)
$outBmp.Save('images\scratch\test_refined_inpaint.png', [System.Drawing.Imaging.ImageFormat]::Png)

$cropBmp.Dispose()
$outBmp.Dispose()
Write-Host "Refined inpaint test complete!"
