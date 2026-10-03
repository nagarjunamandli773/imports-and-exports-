Add-Type -AssemblyName System.Drawing

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class IconTester {
    public static void RenderIcons(string outPath) {
        int w = 800;
        int h = 200;
        using (Bitmap bmp = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
            using (Graphics g = Graphics.FromImage(bmp)) {
                g.Clear(Color.White);
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;

                Color gold = Color.FromArgb(255, 235, 155, 22);
                Color navy = Color.FromArgb(255, 7, 37, 78);
                using (Pen goldPen = new Pen(gold, 8f))
                using (SolidBrush navyBrush = new SolidBrush(navy))
                using (Pen navyPen = new Pen(navy, 5f))
                using (SolidBrush whiteBrush = new SolidBrush(Color.White))
                {
                    navyPen.StartCap = LineCap.Round;
                    navyPen.EndCap = LineCap.Round;
                    navyPen.LineJoin = LineJoin.Round;

                    // 4 centers: 100, 300, 500, 700. Y = 100. Radius = 65
                    float[] centers = { 100f, 300f, 500f, 700f };
                    float cy = 100f;
                    float r = 65f;

                    // 1. Badge 1: Chat bubble with 3 dots
                    {
                        float cx = centers[0];
                        g.FillEllipse(whiteBrush, cx - r, cy - r, r * 2, r * 2);
                        g.DrawEllipse(goldPen, cx - r, cy - r, r * 2, r * 2);

                        // Chat bubble
                        float bw = 54f;
                        float bh = 42f;
                        float bx = cx - bw / 2f;
                        float by = cy - bh / 2f - 4f;
                        using (GraphicsPath path = new GraphicsPath()) {
                            float cr = 10f;
                            path.AddArc(bx, by, cr * 2, cr * 2, 180, 90);
                            path.AddArc(bx + bw - cr * 2, by, cr * 2, cr * 2, 270, 90);
                            path.AddArc(bx + bw - cr * 2, by + bh - cr * 2, cr * 2, cr * 2, 0, 90);
                            // tail at bottom-left
                            path.AddLine(bx + bw - cr * 2, by + bh, bx + 16f, by + bh);
                            path.AddLine(bx + 16f, by + bh, bx + 8f, by + bh + 10f);
                            path.AddLine(bx + 8f, by + bh + 10f, bx + 10f, by + bh);
                            path.AddArc(bx, by + bh - cr * 2, cr * 2, cr * 2, 90, 90);
                            path.CloseFigure();
                            g.DrawPath(navyPen, path);
                        }
                        // 3 dots
                        float dotR = 3.5f;
                        g.FillEllipse(navyBrush, cx - 14f - dotR, cy - 4f - dotR, dotR * 2, dotR * 2);
                        g.FillEllipse(navyBrush, cx - dotR, cy - 4f - dotR, dotR * 2, dotR * 2);
                        g.FillEllipse(navyBrush, cx + 14f - dotR, cy - 4f - dotR, dotR * 2, dotR * 2);
                    }

                    // 2. Badge 2: 3 People / Support Team
                    {
                        float cx = centers[1];
                        g.FillEllipse(whiteBrush, cx - r, cy - r, r * 2, r * 2);
                        g.DrawEllipse(goldPen, cx - r, cy - r, r * 2, r * 2);

                        // Center person head
                        g.FillEllipse(navyBrush, cx - 10f, cy - 26f, 20f, 20f);
                        // Center body
                        g.FillPie(navyBrush, cx - 22f, cy - 2f, 44f, 44f, 180, 180);

                        // Left person head
                        g.FillEllipse(navyBrush, cx - 28f, cy - 18f, 16f, 16f);
                        // Left body
                        g.FillPie(navyBrush, cx - 38f, cy + 2f, 32f, 32f, 180, 180);

                        // Right person head
                        g.FillEllipse(navyBrush, cx + 12f, cy - 18f, 16f, 16f);
                        // Right body
                        g.FillPie(navyBrush, cx + 6f, cy + 2f, 32f, 32f, 180, 180);
                    }

                    // 3. Badge 3: Globe with grid
                    {
                        float cx = centers[2];
                        g.FillEllipse(whiteBrush, cx - r, cy - r, r * 2, r * 2);
                        g.DrawEllipse(goldPen, cx - r, cy - r, r * 2, r * 2);

                        float gr = 26f;
                        g.DrawEllipse(navyPen, cx - gr, cy - gr, gr * 2, gr * 2);
                        // Horizontal line
                        g.DrawLine(navyPen, cx - gr, cy, cx + gr, cy);
                        // Latitude curves
                        g.DrawArc(navyPen, cx - gr + 4f, cy - gr - 8f, (gr - 4f) * 2, gr * 2, 35, 110);
                        g.DrawArc(navyPen, cx - gr + 4f, cy - gr + 16f, (gr - 4f) * 2, gr * 2, 215, 110);
                        // Longitude ellipse
                        g.DrawEllipse(navyPen, cx - gr * 0.45f, cy - gr, gr * 0.9f, gr * 2);
                    }

                    // 4. Badge 4: Shield with Checkmark
                    {
                        float cx = centers[3];
                        g.FillEllipse(whiteBrush, cx - r, cy - r, r * 2, r * 2);
                        g.DrawEllipse(goldPen, cx - r, cy - r, r * 2, r * 2);

                        // Shield shape
                        using (GraphicsPath shield = new GraphicsPath()) {
                            float sw = 50f;
                            float sh = 56f;
                            float sx = cx - sw / 2f;
                            float sy = cy - sh / 2f + 2f;

                            shield.AddLine(sx, sy, sx + sw, sy);
                            shield.AddLine(sx + sw, sy, sx + sw, sy + sh * 0.4f);
                            shield.AddBezier(sx + sw, sy + sh * 0.4f, sx + sw * 0.8f, sy + sh * 0.8f, sx, sy + sh, sx, sy + sh);
                            shield.AddBezier(sx, sy + sh, sx - sw * 0.8f, sy + sh * 0.8f, sx, sy + sh * 0.4f, sx, sy + sh * 0.4f);
                            shield.CloseFigure();

                            g.FillPath(navyBrush, shield);
                        }

                        // White checkmark inside shield
                        using (Pen checkPen = new Pen(Color.White, 6f)) {
                            checkPen.StartCap = LineCap.Round;
                            checkPen.EndCap = LineCap.Round;
                            checkPen.LineJoin = LineJoin.Round;
                            PointF p1 = new PointF(cx - 12f, cy);
                            PointF p2 = new PointF(cx - 3f, cy + 9f);
                            PointF p3 = new PointF(cx + 13f, cy - 7f);
                            g.DrawLines(checkPen, new PointF[] { p1, p2, p3 });
                        }
                    }
                }
            }
            bmp.Save(outPath, ImageFormat.Png);
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing
[IconTester]::RenderIcons("images\scratch\icons_vector.png")
Write-Host "Saved icons_vector.png"
