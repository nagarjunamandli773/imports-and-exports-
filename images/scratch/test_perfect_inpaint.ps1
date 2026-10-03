Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class PerfectInpaint {
    public static Bitmap Inpaint(Bitmap src) {
        int w = src.Width;
        int h = src.Height;

        bool[,] mask = new bool[w, h];

        for (int y = 22; y <= 112; y++) {
            for (int x = 49; x <= 170; x++) {
                // Protect buildings: never mask x <= 73 with y >= 104
                if (x <= 73 && y >= 104) continue;

                Color c = src.GetPixel(x, y);

                // Text letters: White / pale / cyan on twilight sky
                bool isText = (c.R + c.G + c.B > 430) ||
                              (c.R > 135 && c.G > 140 && c.B > 155) ||
                              (c.R > 120 && c.G > 135 && c.B > 165);

                // Swoosh and gold accents
                double swooshY = 108.0 - (x - 65.0) * 0.316;
                bool nearSwoosh = (x >= 74 && Math.Abs(y - swooshY) <= 4.0);
                bool isGold = (c.R > 145 && c.G > 110 && (c.R - c.B) > 25);

                if (isText || (nearSwoosh && (isGold || c.R > 135))) {
                    mask[x, y] = true;
                }
            }
        }

        // Dilate mask by 3px
        bool[,] dilated = new bool[w, h];
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                // Protect crane (x <= 46) and buildings (x <= 73 with y >= 104)
                if (x <= 46 || (x <= 73 && y >= 104) || y <= 19 || y >= 115 || x >= 173) continue;

                bool found = false;
                for (int dy = -3; dy <= 3 && !found; dy++) {
                    for (int dx = -3; dx <= 3 && !found; dx++) {
                        if (dx * dx + dy * dy <= 10) {
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

        // 450 iterations of Laplace diffusion
        for (int iter = 0; iter < 450; iter++) {
            for (int y = 20; y < 114; y++) {
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

        Random rand = new Random(98765);
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

        // Save mask for debugging
        using (Bitmap maskBmp = new Bitmap(w, h)) {
            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    if (dilated[x, y]) maskBmp.SetPixel(x, y, Color.Red);
                    else maskBmp.SetPixel(x, y, src.GetPixel(x, y));
                }
            }
            maskBmp.Save("images\\scratch\\test_perfect_mask.png", ImageFormat.Png);
        }

        return res;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$cropBmp = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')
$outBmp = [PerfectInpaint]::Inpaint($cropBmp)
$outBmp.Save('images\scratch\test_perfect_inpaint.png', [System.Drawing.Imaging.ImageFormat]::Png)

$cropBmp.Dispose()
$outBmp.Dispose()
Write-Host "Perfect inpaint test complete!"
