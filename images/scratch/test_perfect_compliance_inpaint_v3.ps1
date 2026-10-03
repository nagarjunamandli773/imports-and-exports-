Add-Type -AssemblyName System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class CompliancePerfectInpainter3 {
    public static void Inpaint(string srcPath, string outPath) {
        using (Bitmap src = new Bitmap(srcPath)) {
            int w = src.Width;   // 1024
            int h = src.Height;  // 341

            Bitmap clean = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(clean)) {
                g.DrawImage(src, 0, 0);
            }

            // 1. Fill the core white area with a polygon avoiding the swoosh
            using (Graphics g = Graphics.FromImage(clean)) {
                using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                    GraphicsPath path = new GraphicsPath();
                    PointF[] pts = new PointF[] {
                        new PointF(24, 36),
                        new PointF(330, 36),
                        new PointF(330, 300),
                        new PointF(60, 300),
                        new PointF(40, 292),
                        new PointF(24, 285)
                    };
                    path.AddPolygon(pts);
                    g.FillPath(whiteBrush, path);
                }
            }

            // 2. Identify mask of text/badge pixels in transition zone X: 320 to 455, Y: 35 to 302
            bool[,] mask = new bool[w, h];

            for (int y = 35; y <= 302; y++) {
                for (int x = 320; x <= 455; x++) {
                    Color p = clean.GetPixel(x, y);

                    bool isNotBg = false;
                    // Navy / slate text:
                    if (p.R < 232 || p.G < 235 || p.B < 235) {
                        isNotBg = true;
                    }
                    // Gold text/icons:
                    if (p.R > 210 && p.B < 195) {
                        isNotBg = true;
                    }
                    // In badge area Y: 220 to 302, mask anything not clean white / pale bench:
                    if (y >= 220 && (p.R < 242 || p.G < 244 || p.B < 244)) {
                        isNotBg = true;
                    }
                    if (isNotBg) {
                        mask[x, y] = true;
                    }
                }
            }

            // Dilate mask by 3px
            bool[,] dilated = new bool[w, h];
            for (int y = 30; y <= 306; y++) {
                for (int x = 315; x <= 460; x++) {
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

            // Laplace diffusion arrays
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

            // 1500 iterations for complete seamless blending
            for (int iter = 0; iter < 1500; iter++) {
                for (int y = 30; y <= 306; y++) {
                    for (int x = 315; x <= 460; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }

            // Write back diffused pixels
            for (int y = 30; y <= 306; y++) {
                for (int x = 315; x <= 460; x++) {
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

$outPath = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_compliance_perfect_v3.png"
[CompliancePerfectInpainter3]::Inpaint($src, $outPath)
Write-Host "Perfect clean base v3 saved to $outPath"
