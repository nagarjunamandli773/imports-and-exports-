Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790503971818.png"
if (-not (Test-Path $src)) {
    $src = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png"
}

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class InsightsCleanInpainter2 {
    public static void Inpaint(string srcPath, string outPath) {
        using (Bitmap src = new Bitmap(srcPath)) {
            int w = src.Width;   // 1024
            int h = src.Height;  // 341

            Bitmap clean = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(clean)) {
                g.DrawImage(src, 0, 0);
            }

            // 1. Fill core white area down to Y=292, avoiding the bottom-left swoosh
            using (Graphics g = Graphics.FromImage(clean)) {
                using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                    GraphicsPath path = new GraphicsPath();
                    PointF[] pts = new PointF[] {
                        new PointF(24, 45),
                        new PointF(350, 45),
                        new PointF(350, 292),
                        new PointF(100, 292),
                        new PointF(50, 290),
                        new PointF(35, 282),
                        new PointF(24, 270)
                    };
                    path.AddPolygon(pts);
                    g.FillPath(whiteBrush, path);
                }
            }

            // 2. Identify mask of text/badge pixels in transition zone X: 330 to 455, Y: 45 to 295
            bool[,] mask = new bool[w, h];
            for (int y = 45; y <= 295; y++) {
                for (int x = 330; x <= 455; x++) {
                    Color p = clean.GetPixel(x, y);
                    bool isNotBg = false;
                    if (p.R < 232 || p.G < 235 || p.B < 235) isNotBg = true;
                    if (p.R > 210 && p.B < 195) isNotBg = true;
                    if (y >= 210 && (p.R < 242 || p.G < 244 || p.B < 244)) isNotBg = true;
                    if (isNotBg) mask[x, y] = true;
                }
            }

            // Dilate mask by 3px
            bool[,] dilated = new bool[w, h];
            for (int y = 40; y <= 300; y++) {
                for (int x = 325; x <= 460; x++) {
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

            // Laplace diffusion
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

            for (int iter = 0; iter < 1500; iter++) {
                for (int y = 40; y <= 300; y++) {
                    for (int x = 325; x <= 460; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }

            for (int y = 40; y <= 300; y++) {
                for (int x = 325; x <= 460; x++) {
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

$outPath = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_insights_2_1x.png"
[InsightsCleanInpainter2]::Inpaint($src, $outPath)
Write-Host "Inpainted clean insights base v2 saved to $outPath"
