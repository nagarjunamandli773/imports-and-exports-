Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class ComplianceInpainter {
    public static void Inpaint(string srcPath, string outPath) {
        using (Bitmap src = new Bitmap(srcPath)) {
            int w = src.Width;
            int h = src.Height;

            Bitmap clean = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(clean)) {
                g.DrawImage(src, 0, 0);
            }

            bool[,] mask = new bool[w, h];

            // Text zone: X from 20 to 445, Y from 30 to 292
            for (int y = 30; y <= 292; y++) {
                for (int x = 20; x <= 445; x++) {
                    // Avoid bottom-left swoosh:
                    // Swoosh curve: X < 35 && y > 270, X < 70 && y > 290
                    if (x < 35 && y > 270) continue;
                    if (x < 70 && y > 290) continue;

                    Color p = src.GetPixel(x, y);

                    // Background is white or near-white / pale sky: R>242, G>244, B>246
                    // Any text, icon, badge, underline or divider pixel deviates from this:
                    bool isNotBg = false;

                    // Text (navy / slate / grey)
                    if (p.R < 235 || p.G < 238 || p.B < 238) {
                        isNotBg = true;
                    }
                    // Gold text / icons: high red & green, low blue
                    if (p.R > 210 && p.B < 190) {
                        isNotBg = true;
                    }

                    if (isNotBg) {
                        mask[x, y] = true;
                    }
                }
            }

            // Dilate mask by 2px to catch anti-aliasing edge halos
            bool[,] dilated = new bool[w, h];
            for (int y = 28; y <= 294; y++) {
                for (int x = 18; x <= 447; x++) {
                    if (x < 35 && y > 270) continue;
                    if (x < 70 && y > 290) continue;

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

            // Laplace PDE diffusion arrays
            double[,] rArr = new double[w, h];
            double[,] gArr = new double[w, h];
            double[,] bArr = new double[w, h];

            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    Color p = clean.GetPixel(x, y);
                    rArr[x, y] = p.R;
                    gArr[x, y] = p.G;
                    bArr[x, y] = p.B;
                }
            }

            // 400 iterations for silky smooth diffusion
            for (int iter = 0; iter < 400; iter++) {
                for (int y = 28; y <= 294; y++) {
                    for (int x = 18; x <= 447; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }

            // Write back diffused pixels
            for (int y = 28; y <= 294; y++) {
                for (int x = 18; x <= 447; x++) {
                    if (dilated[x, y]) {
                        int r = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y])));
                        int gCol = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y])));
                        int bCol = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y])));
                        clean.SetPixel(x, y, Color.FromArgb(r, gCol, bCol));
                    }
                }
            }

            clean.Save(outPath, ImageFormat.Png);
            clean.Dispose();
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$outPath = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_compliance_1x.png"
[ComplianceInpainter]::Inpaint($src, $outPath)
Write-Host "Inpainted base saved to $outPath"
