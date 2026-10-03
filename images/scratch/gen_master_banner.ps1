Add-Type -AssemblyName System.Drawing

$fontPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class PerfectServicesHero {
    public static void GenerateMasterBanner(string srcPath, string outPath, string fontPath, int scale) {
        using (Bitmap srcBmp = new Bitmap(srcPath)) {
            int targetW = srcBmp.Width * scale;
            int targetH = srcBmp.Height * scale;

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled base photo panorama
                    g.DrawImage(srcBmp, 0, 0, targetW, targetH);

                    // 2. Define the smooth bottom-left curve points
                    // This creates the exact curved cutout on the bottom left (X=0 to ~100 in 1x scale)
                    PointF[] curvePoints = new PointF[] {
                        new PointF(0 * scale, 105f * scale),
                        new PointF(18f * scale, 122f * scale),
                        new PointF(40f * scale, 135f * scale),
                        new PointF(66f * scale, 142f * scale),
                        new PointF(92f * scale, 147.5f * scale),
                        new PointF(105f * scale, 149.0f * scale)
                    };

                    // 3. Create the navy blue background patch for the text card
                    // It covers X=0 to X=375*scale
                    // Fully opaque up to X=332*scale, then smoothly fades out from 332 to 375*scale
                    int cardRightX = 375 * scale;
                    int fadeStartX = 332 * scale;
                    float fadeWidth = (float)(cardRightX - fadeStartX);

                    using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                        using (Graphics pg = Graphics.FromImage(patch)) {
                            pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            pg.SmoothingMode = SmoothingMode.HighQuality;

                            // Fill with rich vertical navy gradient matching the master palette
                            using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                new Rectangle(0, 0, cardRightX, targetH),
                                Color.FromArgb(255, 9, 32, 60),
                                Color.FromArgb(255, 3, 16, 35),
                                LinearGradientMode.Vertical)) {
                                
                                ColorBlend cb = new ColorBlend(4);
                                cb.Positions = new float[] { 0f, 0.22f, 0.70f, 1f };
                                cb.Colors = new Color[] {
                                    Color.FromArgb(255, 12, 36, 66),
                                    Color.FromArgb(255, 6, 24, 48),
                                    Color.FromArgb(255, 3, 16, 35),
                                    Color.FromArgb(255, 2, 12, 26)
                                };
                                bgBrush.InterpolationColors = cb;
                                pg.FillRectangle(bgBrush, 0, 0, cardRightX, targetH);
                            }

                            // Horizontal right fade mask for seamless transition into the port skyline
                            for (int y = 0; y < targetH; y++) {
                                for (int x = fadeStartX; x < cardRightX; x++) {
                                    float f = (float)(x - fadeStartX) / fadeWidth;
                                    // Smooth cosine falloff
                                    float alpha = 0.5f * (1f + (float)Math.Cos(f * Math.PI));
                                    Color orig = patch.GetPixel(x, y);
                                    patch.SetPixel(x, y, Color.FromArgb((int)(orig.A * alpha), orig.R, orig.G, orig.B));
                                }
                            }
                        }

                        // Clip drawing of patch so it stays strictly ABOVE the bottom-left curve
                        GraphicsPath clipPath = new GraphicsPath();
                        clipPath.AddLine(0, 0, cardRightX, 0);
                        clipPath.AddLine(cardRightX, 0, cardRightX, targetH);
                        clipPath.AddLine(cardRightX, targetH, 105f * scale, targetH);
                        PointF[] revPoints = new PointF[curvePoints.Length];
                        for (int i = 0; i < curvePoints.Length; i++) {
                            revPoints[i] = curvePoints[curvePoints.Length - 1 - i];
                        }
                        clipPath.AddCurve(revPoints, 0.45f);
                        clipPath.AddLine(0, 105f * scale, 0, 0);
                        clipPath.CloseFigure();

                        Region oldClip = g.Clip;
                        g.SetClip(clipPath);
                        g.DrawImage(patch, 0, 0);
                        g.Clip = oldClip;
                    }

                    // 4. Fill the bottom-left corner below the curve with pure white
                    GraphicsPath whiteCornerPath = new GraphicsPath();
                    whiteCornerPath.AddCurve(curvePoints, 0.45f);
                    whiteCornerPath.AddLine(105f * scale, targetH, 0, targetH);
                    whiteCornerPath.AddLine(0, targetH, 0, 105f * scale);
                    whiteCornerPath.CloseFigure();

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                        g.FillPath(whiteBrush, whiteCornerPath);
                    }

                    // Draw golden curved border stroke (ONLY on the bottom-left curve!)
                    using (Pen goldOuter = new Pen(Color.FromArgb(238, 178, 48), 2.5f * scale)) {
                        goldOuter.StartCap = LineCap.Round;
                        goldOuter.EndCap = LineCap.Round;
                        g.DrawCurve(goldOuter, curvePoints, 0.45f);
                    }
                    using (Pen goldInner = new Pen(Color.FromArgb(255, 225, 120), 1.1f * scale)) {
                        g.DrawCurve(goldInner, curvePoints, 0.45f);
                    }

                    // 5. Load brand font Plus Jakarta Sans
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    // 6. Draw Typography
                    float startX = 38f * scale;

                    // Eyebrow: OUR SERVICES (Gold, uppercase, elegant tracking)
                    using (Font eyebrowFont = new Font(fam, 7.3f * scale, FontStyle.Bold))
                    using (SolidBrush goldBrush = new SolidBrush(Color.FromArgb(243, 202, 101))) {
                        DrawSpacedString(g, "OUR SERVICES", eyebrowFont, goldBrush, startX, 13.5f * scale, 1.4f * scale);
                    }

                    // Heading: End-to-End Trade (White) & Solutions (Gold) - Prominent, Bold, Punchy!
                    using (Font titleFont = new Font(fam, 20.2f * scale, FontStyle.Bold))
                    using (SolidBrush whiteTitle = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush goldTitle = new SolidBrush(Color.FromArgb(245, 185, 62))) {
                        g.DrawString("End-to-End Trade", titleFont, whiteTitle, startX - (0.5f * scale), 23.5f * scale);
                        g.DrawString("Solutions", titleFont, goldTitle, startX - (0.5f * scale), 45.5f * scale);
                    }

                    // Paragraph: 3 sentences (Crisp readable light blue-white)
                    using (Font descFont = new Font(fam, 6.0f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(226, 237, 248))) {
                        string l1 = "From sourcing to delivery, we handle the complexities";
                        string l2 = "so you can focus on growth. Our comprehensive services";
                        string l3 = "ensure seamless, secure and efficient global trade.";

                        float lineSpacing = 8.6f * scale;
                        float descStartY = 72.5f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, descStartY);
                        g.DrawString(l2, descFont, descBrush, startX, descStartY + lineSpacing);
                        g.DrawString(l3, descFont, descBrush, startX, descStartY + lineSpacing * 2);
                    }

                    // 7. Draw 4 Feature Badges (Horizontal Row at Y ~ 103..133 in 1x scale)
                    float badgeY = 103f * scale;
                    float circleRadius = 10.2f * scale;
                    float circleDiam = circleRadius * 2f;

                    float[] badgeX = new float[] {
                        40f * scale,
                        116f * scale,
                        191f * scale,
                        266f * scale
                    };

                    string[][] badgeTexts = new string[][] {
                        new string[] { "Global", "Network" },
                        new string[] { "Expert", "Support" },
                        new string[] { "Secure", "& Reliable" },
                        new string[] { "On-Time", "Delivery" }
                    };

                    using (Pen circlePen = new Pen(Color.FromArgb(238, 188, 72), 1.4f * scale))
                    using (SolidBrush circleFill = new SolidBrush(Color.FromArgb(55, 243, 202, 101)))
                    using (SolidBrush iconBrush = new SolidBrush(Color.FromArgb(250, 218, 125)))
                    using (Pen iconPen = new Pen(Color.FromArgb(250, 218, 125), 1.2f * scale))
                    using (Font badgeFont = new Font(fam, 5.25f * scale, FontStyle.Bold))
                    using (SolidBrush textWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush textBlue = new SolidBrush(Color.FromArgb(215, 230, 246))) {
                        for (int i = 0; i < 4; i++) {
                            float bx = badgeX[i];
                            float cy = badgeY + circleRadius;
                            float cx = bx + circleRadius;

                            // Draw circle
                            g.FillEllipse(circleFill, bx, badgeY, circleDiam, circleDiam);
                            g.DrawEllipse(circlePen, bx, badgeY, circleDiam, circleDiam);

                            // Draw Icon inside circle
                            DrawBadgeIcon(g, i, cx, cy, circleRadius, iconPen, iconBrush);

                            // Draw 2-line text beside circle
                            float tx = bx + circleDiam + (3.4f * scale);
                            g.DrawString(badgeTexts[i][0], badgeFont, textWhite, tx, badgeY + (1.2f * scale));
                            g.DrawString(badgeTexts[i][1], badgeFont, textBlue, tx, badgeY + (8.2f * scale));
                        }
                    }
                }

                destBmp.Save(outPath, ImageFormat.Png);
            }
        }
    }

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraSpacing) {
        float currentX = x;
        foreach (char c in text) {
            string s = c.ToString();
            g.DrawString(s, font, brush, currentX, y);
            SizeF size = g.MeasureString(s, font);
            currentX += size.Width - (font.Size * 0.18f) + extraSpacing;
        }
    }

    private static void DrawBadgeIcon(Graphics g, int index, float cx, float cy, float r, Pen pen, SolidBrush brush) {
        float s = r * 0.58f;
        switch (index) {
            case 0: // Globe
                g.DrawEllipse(pen, cx - s, cy - s, s * 2, s * 2);
                g.DrawLine(pen, cx - s, cy, cx + s, cy);
                g.DrawLine(pen, cx, cy - s, cx, cy + s);
                g.DrawEllipse(pen, cx - s * 0.46f, cy - s, s * 0.92f, s * 2);
                break;
            case 1: // Expert Support (Team silhouette: center user + 2 side users)
                // Center head & body
                float chr = s * 0.32f;
                g.FillEllipse(brush, cx - chr, cy - s * 0.85f, chr * 2, chr * 2);
                GraphicsPath cBody = new GraphicsPath();
                cBody.AddArc(cx - s * 0.55f, cy - s * 0.1f, s * 1.1f, s * 1.2f, 200, 140);
                cBody.CloseFigure();
                g.FillPath(brush, cBody);

                // Left assistant
                float lhr = s * 0.23f;
                g.FillEllipse(brush, cx - s * 0.70f - lhr, cy - s * 0.55f, lhr * 2, lhr * 2);
                GraphicsPath lBody = new GraphicsPath();
                lBody.AddArc(cx - s * 0.95f, cy + s * 0.05f, s * 0.65f, s * 0.8f, 200, 140);
                lBody.CloseFigure();
                g.FillPath(brush, lBody);

                // Right assistant
                g.FillEllipse(brush, cx + s * 0.70f - lhr, cy - s * 0.55f, lhr * 2, lhr * 2);
                GraphicsPath rBody = new GraphicsPath();
                rBody.AddArc(cx + s * 0.30f, cy + s * 0.05f, s * 0.65f, s * 0.8f, 200, 140);
                rBody.CloseFigure();
                g.FillPath(brush, rBody);
                break;
            case 2: // Secure & Reliable (Shield with checkmark)
                GraphicsPath shield = new GraphicsPath();
                shield.AddLine(cx - s * 0.72f, cy - s * 0.80f, cx + s * 0.72f, cy - s * 0.80f);
                shield.AddLine(cx + s * 0.72f, cy - s * 0.80f, cx + s * 0.72f, cy + s * 0.10f);
                shield.AddBezier(cx + s * 0.72f, cy + s * 0.10f, cx + s * 0.50f, cy + s * 0.70f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                shield.AddBezier(cx, cy + s * 0.95f, cx - s * 0.50f, cy + s * 0.70f, cx - s * 0.72f, cy + s * 0.10f, cx - s * 0.72f, cy + s * 0.10f);
                shield.CloseFigure();
                g.DrawPath(pen, shield);

                using (Pen checkPen = new Pen(brush.Color, pen.Width * 1.25f)) {
                    checkPen.StartCap = LineCap.Round;
                    checkPen.EndCap = LineCap.Round;
                    g.DrawLine(checkPen, cx - s * 0.35f, cy + s * 0.05f, cx - s * 0.05f, cy + s * 0.38f);
                    g.DrawLine(checkPen, cx - s * 0.05f, cy + s * 0.38f, cx + s * 0.42f, cy - s * 0.25f);
                }
                break;
            case 3: // On-Time Delivery (Stopwatch / Clock with tick perimeter)
                g.DrawEllipse(pen, cx - s * 0.80f, cy - s * 0.80f, s * 1.6f, s * 1.6f);
                // 8 small tick marks on perimeter
                for (int a = 0; a < 8; a++) {
                    double rad = a * Math.PI / 4.0;
                    float tx1 = cx + (float)(Math.Cos(rad) * s * 0.80f);
                    float ty1 = cy + (float)(Math.Sin(rad) * s * 0.80f);
                    float tx2 = cx + (float)(Math.Cos(rad) * s * 0.95f);
                    float ty2 = cy + (float)(Math.Sin(rad) * s * 0.95f);
                    g.DrawLine(pen, tx1, ty1, tx2, ty2);
                }
                // Clock hands pointing to 10:10
                using (Pen handPen = new Pen(brush.Color, pen.Width * 1.15f)) {
                    handPen.StartCap = LineCap.Round;
                    handPen.EndCap = LineCap.Round;
                    g.DrawLine(handPen, cx, cy, cx - s * 0.36f, cy - s * 0.36f);
                    g.DrawLine(handPen, cx, cy, cx + s * 0.44f, cy - s * 0.22f);
                }
                break;
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png"
$masterOut = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_master_4x.png"

[PerfectServicesHero]::GenerateMasterBanner($src, $masterOut, $fontPath, 4)
Write-Host "Generated services_hero_master_4x.png successfully!"
