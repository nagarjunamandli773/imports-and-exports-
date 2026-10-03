Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class PreciseInpaint2 {
    public static Bitmap Inpaint(Bitmap src) {
        int w = src.Width;
        int h = src.Height;

        bool[,] mask = new bool[w, h];

        for (int y = 20; y <= 104; y++) {
            for (int x = 48; x <= 168; x++) {
                // Strictly protect buildings at x <= 73, y >= 103
                if (x <= 73 && y >= 103) continue;

                Color c = src.GetPixel(x, y);

                // Swoosh line
                double swooshY = 108.0 - (x - 65.0) * 0.316;
                bool isNearSwoosh = (x >= 73 && x <= 165 && Math.Abs(y - swooshY) <= 3.6);

                // Text pixels
                bool isWhiteText = (c.R + c.G + c.B > 410) ||
                                   (c.R > 130 && c.G > 140 && c.B > 155) ||
                                   (c.R > 120 && c.G > 130 && c.B > 165) ||
                                   (c.R > 150 && c.G > 145 && c.B > 140);

                // Gold / swoosh
                bool isGold = (c.R > 140 && c.G > 100 && (c.R - c.B) > 25);

                if (isWhiteText || (isNearSwoosh && (isGold || c.R > 130))) {
                    mask[x, y] = true;
                }
            }
        }

        // Dilate mask by 2px (circular)
        bool[,] dilated = new bool[w, h];
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                // Exclude buildings, crane, and outside borders
                if (x <= 46 || (x <= 73 && y >= 103) || y <= 18 || y >= 106 || x >= 172) continue;

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
            for (int y = 19; y < 106; y++) {
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

        Random rand = new Random(13579);
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
            maskBmp.Save("images\\scratch\\test_precise2_mask.png", ImageFormat.Png);
        }

        return res;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$cropBmp = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')
$outBmp = [PreciseInpaint2]::Inpaint($cropBmp)
$outBmp.Save('images\scratch\test_precise2_inpaint.png', [System.Drawing.Imaging.ImageFormat]::Png)

$cropBmp.Dispose()
$outBmp.Dispose()
Write-Host "Precise inpaint 2 complete!"
