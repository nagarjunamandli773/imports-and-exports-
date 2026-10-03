Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class TestLaplaceInpaint {
    public static Bitmap Inpaint(Bitmap src) {
        int w = src.Width;
        int h = src.Height;

        // Mask for text and gold swoosh
        bool[,] mask = new bool[w, h];

        // The text is roughly in local x: 45 to w-2, y: 15 to 118
        for (int y = 14; y < 120; y++) {
            for (int x = 45; x < w - 2; x++) {
                Color c = src.GetPixel(x, y);

                // White / pale cursive text
                bool isWhite = (c.R > 135 && c.G > 140 && c.B > 150) ||
                               (c.R > 170 && c.G > 170 && c.B > 170) ||
                               (c.R > 120 && c.G > 130 && c.B > 165);

                // Gold swoosh line
                bool isGold = (c.R > 155 && c.G > 120 && c.B < 115) ||
                              (c.R > 180 && c.G > 150 && c.B < 135);

                // Text edge halo
                bool isHalo = (c.R > 115 && c.G > 125 && c.B > 165 && y < 85 && (c.R + c.G + c.B) > 420);

                if (isWhite || isGold || isHalo) {
                    mask[x, y] = true;
                }
            }
        }

        // Dilate mask by 2px for clean boundary
        bool[,] dilated = new bool[w, h];
        for (int y = 10; y < 125; y++) {
            for (int x = 40; x < w - 1; x++) {
                bool found = false;
                for (int dy = -2; dy <= 2 && !found; dy++) {
                    for (int dx = -2; dx <= 2 && !found; dx++) {
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

        // 300 iterations of Laplace diffusion
        for (int iter = 0; iter < 300; iter++) {
            for (int y = 12; y < 123; y++) {
                for (int x = 42; x < w - 2; x++) {
                    if (dilated[x, y]) {
                        // Weighted 4-neighbor average
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

        Random rand = new Random(42);
        Bitmap res = new Bitmap(w, h, PixelFormat.Format32bppArgb);
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                if (dilated[x, y]) {
                    int grain = rand.Next(-2, 3);
                    int r = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y] + grain)));
                    int g = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y] + grain)));
                    int b = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y] + grain)));
                    res.SetPixel(x, y, Color.FromArgb(r, g, b));
                } else {
                    res.SetPixel(x, y, src.GetPixel(x, y));
                }
            }
        }

        return res;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$cropBmp = [System.Drawing.Bitmap]::FromFile('images\scratch\service_quote_crop.png')
$outBmp = [TestLaplaceInpaint]::Inpaint($cropBmp)
$outBmp.Save('images\scratch\test_laplace_crop_out.png', [System.Drawing.Imaging.ImageFormat]::Png)

$cropBmp.Dispose()
$outBmp.Dispose()
Write-Host "Laplace test saved!"
