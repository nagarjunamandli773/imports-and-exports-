Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class VibrantNavyLiteBlueHero {
    public static void GenerateBanner(string srcPath, string cleanRightPath, string outPng1, string outPng2, string fontSansPath, string fontSerifPath, int scale) {
        using (Bitmap rawSrc = new Bitmap(srcPath))
        using (Bitmap cleanRight = new Bitmap(cleanRightPath)) {
            Bitmap patchedSrc = new Bitmap(rawSrc.Width, rawSrc.Height, PixelFormat.Format32bppArgb);
            using (Graphics pg = Graphics.FromImage(patchedSrc)) {
                pg.DrawImage(rawSrc, 0, 0);
            }

            for (int y = 0; y < rawSrc.Height; y++) {
                for (int x = 835; x < rawSrc.Width; x++) {
                    int cx = x - 8;
                    int cy = y - 4;
                    if (cx >= 0 && cx < cleanRight.Width && cy >= 0 && cy < cleanRight.Height) {
                        Color cClean = cleanRight.GetPixel(cx, cy);
                        double alpha = 1.0;
                        if (x < 850) {
                            alpha = (x - 835.0) / 15.0;
                        }
                        Color cOrig = rawSrc.GetPixel(x, y);
                        int r = (int)(cOrig.R * (1 - alpha) + cClean.R * alpha);
                        int gCol = (int)(cOrig.G * (1 - alpha) + cClean.G * alpha);
                        int b = (int)(cOrig.B * (1 - alpha) + cClean.B * alpha);
                        patchedSrc.SetPixel(x, y, Color.FromArgb(r, gCol, b));
                    }
                }
            }

            int cropY = 1;
            int cropH = patchedSrc.Height - cropY;
            Rectangle srcRect = new Rectangle(0, cropY, patchedSrc.Width, cropH);

            int targetW = patchedSrc.Width * scale; // 4096
            int targetH = cropH * scale;            // 612

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw base photo panorama (harbor, cranes, ship, cargo aircraft, world map)
                    g.DrawImage(patchedSrc, new Rectangle(0, 0, targetW, targetH), srcRect, GraphicsUnit.Pixel);

                    // 2. Define smooth S-curve boundary
                    PointF[] curvePoints = new PointF[] {
                        new PointF(0f * scale, (93f - cropY) * scale),
                        new PointF(18f * scale, (107f - cropY) * scale),
                        new PointF(36f * scale, (118f - cropY) * scale),
                        new PointF(58f * scale, (128f - cropY) * scale),
                        new PointF(80f * scale, (134.5f - cropY) * scale),
                        new PointF(105f * scale, (139f - cropY) * scale),
                        new PointF(140f * scale, (143.5f - cropY) * scale),
                        new PointF(180f * scale, (146.5f - cropY) * scale),
                        new PointF(230f * scale, (148.5f - cropY) * scale),
                        new PointF(300f * scale, (150.5f - cropY) * scale),
                        new PointF(420f * scale, (151.5f - cropY) * scale),
                        new PointF(550f * scale, (152.0f - cropY) * scale),
                        new PointF(750f * scale, (153.0f - cropY) * scale),
                        new PointF(1024f * scale, (153.5f - cropY) * scale)
                    };

                    GraphicsPath waveArea = new GraphicsPath();
                    waveArea.AddCurve(curvePoints, 0.45f);
                    waveArea.AddLine(1024f * scale, (153.5f - cropY) * scale, targetW, targetH);
                    waveArea.AddLine(targetW, targetH, 0, targetH);
                    waveArea.CloseFigure();

                    // 3. Left card area: Vibrant Navy Blue into Light Blue gradient with Sky Blue glow accents
                    // ZERO black, ZERO murky dark tones!
                    int cardRightX = 465 * scale;
                    int fadeStartX = 380 * scale;
                    float fadeWidth = (float)(cardRightX - fadeStartX);

                    // Exclude bottom wave so colors never bleed into white curve
                    Region origClip = g.Clip;
                    g.ExcludeClip(new Region(waveArea));

                    using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                        using (Graphics pg = Graphics.FromImage(patch)) {
                            pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            pg.SmoothingMode = SmoothingMode.HighQuality;

                            // Vibrant vertical gradient: Royal Navy at top -> Cerulean Azure -> Light Sky Blue at base
                            using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                new Rectangle(0, 0, cardRightX, targetH),
                                Color.FromArgb(255, 18, 58, 122),
                                Color.FromArgb(255, 45, 160, 240),
                                LinearGradientMode.Vertical)) {

                                ColorBlend cb = new ColorBlend(5);
                                cb.Positions = new float[] { 0f, 0.28f, 0.60f, 0.85f, 1f };
                                cb.Colors = new Color[] {
                                    Color.FromArgb(255, 16, 52, 114),   // #103472 Vibrant corporate royal navy (top)
                                    Color.FromArgb(255, 20, 74, 150),   // #144a96 Rich maritime blue
                                    Color.FromArgb(255, 18, 102, 185),  // #1266b9 Vibrant cerulean
                                    Color.FromArgb(255, 26, 136, 222),  // #1a88de Luminous ocean blue
                                    Color.FromArgb(255, 45, 165, 242)   // #2da5f2 Brilliant light sky blue at base
                                };
                                bgBrush.InterpolationColors = cb;
                                pg.FillRectangle(bgBrush, 0, 0, cardRightX, targetH);
                            }

                            // 1st Light Blue Glow: Ethereal radiant Sky Blue highlight in top-left
                            using (GraphicsPath glowPath = new GraphicsPath()) {
                                glowPath.AddEllipse(-30 * scale, -30 * scale, 450 * scale, 280 * scale);
                                using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                    pgb.CenterColor = Color.FromArgb(95, 80, 195, 255); // #50c3ff bright sky blue
                                    pgb.SurroundColors = new Color[] { Color.FromArgb(0, 16, 52, 114) };
                                    pg.FillPath(pgb, glowPath);
                                }
                            }

                            // 2nd Light Blue Accent: Lower luminous cyan/sky ambient wash behind feature badges
                            using (GraphicsPath badgeGlow = new GraphicsPath()) {
                                badgeGlow.AddEllipse(20 * scale, 75 * scale, 380 * scale, 130 * scale);
                                using (PathGradientBrush bpgb = new PathGradientBrush(badgeGlow)) {
                                    bpgb.CenterColor = Color.FromArgb(70, 125, 215, 255); // #7dd7ff soft light blue
                                    bpgb.SurroundColors = new Color[] { Color.FromArgb(0, 18, 102, 185) };
                                    pg.FillPath(bpgb, badgeGlow);
                                }
                            }

                            // Smooth cosine fade into the sunset port / world map on right
                            for (int y = 0; y < targetH; y++) {
                                for (int x = fadeStartX; x < cardRightX; x++) {
                                    float f = (float)(x - fadeStartX) / fadeWidth;
                                    float alpha = 0.5f * (1f + (float)Math.Cos(f * Math.PI));
                                    Color orig = patch.GetPixel(x, y);
                                    patch.SetPixel(x, y, Color.FromArgb((int)(orig.A * alpha), orig.R, orig.G, orig.B));
                                }
                            }
                        }

                        g.DrawImage(patch, 0, 0);
                    }

                    // Restore clip
                    g.Clip = origClip;

                    // 4. Fill bottom wave area with pure clean white
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillPath(whiteBrush, waveArea);
                    }

                    // 5. Draw elegant gold stroke along the S-curve
                    GraphicsPath strokePath = new GraphicsPath();
                    strokePath.AddCurve(curvePoints, 0.45f);
                    using (LinearGradientBrush goldPenBrush = new LinearGradientBrush(
                        new Point(0, 0), new Point(targetW, 0),
                        Color.FromArgb(250, 215, 95), Color.FromArgb(225, 150, 35))) {
                        using (Pen goldPen = new Pen(goldPenBrush, 1.8f * scale)) {
                            g.DrawPath(goldPen, strokePath);
                        }
                    }

                    // 6. Custom fonts
                    PrivateFontCollection pfcSans = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontSansPath) && System.IO.File.Exists(fontSansPath)) {
                        pfcSans.AddFontFile(fontSansPath);
                    }
                    FontFamily famSans = pfcSans.Families.Length > 0 ? pfcSans.Families[0] : new FontFamily("Segoe UI");

                    PrivateFontCollection pfcSerif = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontSerifPath) && System.IO.File.Exists(fontSerifPath)) {
                        pfcSerif.AddFontFile(fontSerifPath);
                    }
                    FontFamily famSerif = pfcSerif.Families.Length > 0 ? pfcSerif.Families[0] : new FontFamily("Georgia");

                    // 7. Left Typography
                    float startX = 44f * scale;

                    // Eyebrow: PREMIUM QUALITY  •  GLOBAL SOURCING
                    float eyebrowY = 22f * scale;
                    using (Font eyebrowFont = new Font(famSans, 5.8f * scale, FontStyle.Bold))
                    using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(255, 215, 115))) {
                        string bullet = ((char)0x2022).ToString();
                        string eyebrowText = "PREMIUM QUALITY  " + bullet + "  GLOBAL SOURCING";
                        DrawSpacedString(g, eyebrowText, eyebrowFont, goldEyebrow, startX, eyebrowY, 1.1f * scale);
                    }

                    // Main Heading: Our (Crisp White) Premium Products (Warm Radiant Gold)
                    float titleY = 34f * scale;
                    using (Font headingFont = new Font(famSerif, 22.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush goldHeading = new SolidBrush(Color.FromArgb(252, 212, 108))) {
                        string ourStr = "Our ";
                        g.DrawString(ourStr, headingFont, whiteHeading, startX, titleY);
                        SizeF ourSize = g.MeasureString(ourStr, headingFont);
                        float premX = startX + ourSize.Width - (5.5f * scale);
                        g.DrawString("Premium Products", headingFont, goldHeading, premX, titleY);
                    }

                    // Description: 2 lines in crisp ice-white
                    float descY = 69f * scale;
                    using (Font descFont = new Font(famSans, 5.6f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(255, 240, 248, 255))) {
                        string l1 = "From farms to industries, we bring you the finest quality products";
                        string l2 = "sourced globally, ensuring trust, purity and excellence in every shipment.";
                        float lineSpacing = 8.5f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, descY);
                        g.DrawString(l2, descFont, descBrush, startX, descY + lineSpacing);
                    }

                    // 8. 4 Feature Badges with Gold Icons & Sky-Blue Tinted Subtitles
                    float badgeY = 96f * scale;
                    float iconRadius = 8.5f * scale;

                    string[][] badgeData = new string[][] {
                        new string[] { "Trusted", "Suppliers" },
                        new string[] { "Quality", "Assured" },
                        new string[] { "Global", "Sourcing" },
                        new string[] { "On-Time", "Delivery" }
                    };

                    float[] badgeXOffsets = new float[] {
                        startX,
                        startX + (78f * scale),
                        startX + (156f * scale),
                        startX + (234f * scale)
                    };

                    using (Font fLine1 = new Font(famSans, 4.4f * scale, FontStyle.Bold))
                    using (Font fLine2 = new Font(famSans, 4.2f * scale, FontStyle.Regular))
                    using (SolidBrush textLine1Brush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush textLine2Brush = new SolidBrush(Color.FromArgb(225, 240, 255)))
                    using (Pen iconCirclePen = new Pen(Color.FromArgb(252, 212, 108), 1.35f * scale))
                    using (SolidBrush iconCircleFill = new SolidBrush(Color.FromArgb(45, 252, 212, 108)))
                    using (Pen badgeSepPen = new Pen(Color.FromArgb(90, 255, 255, 255), 1f * scale)) {

                        for (int i = 0; i < 4; i++) {
                            float bx = badgeXOffsets[i];
                            float cx = bx + iconRadius;
                            float cy = badgeY + iconRadius;

                            // Icon Circle
                            g.FillEllipse(iconCircleFill, cx - iconRadius, cy - iconRadius, iconRadius * 2, iconRadius * 2);
                            g.DrawEllipse(iconCirclePen, cx - iconRadius, cy - iconRadius, iconRadius * 2, iconRadius * 2);

                            // Draw Vector Icon inside
                            DrawVectorIcon(g, i, cx, cy, iconRadius * 0.58f, iconCirclePen, iconCircleFill);

                            // Feature text
                            float tx = cx + iconRadius + (5f * scale);
                            g.DrawString(badgeData[i][0], fLine1, textLine1Brush, tx, badgeY + (0.5f * scale));
                            g.DrawString(badgeData[i][1], fLine2, textLine2Brush, tx, badgeY + (8.2f * scale));

                            // Divider between items (except last)
                            if (i < 3) {
                                float sepX = bx + (72f * scale);
                                g.DrawLine(badgeSepPen, sepX, badgeY + (1.5f * scale), sepX, badgeY + (16.5f * scale));
                            }
                        }
                    }
                }

                destBmp.Save(outPng1, ImageFormat.Png);
                destBmp.Save(outPng2, ImageFormat.Png);
            }
        }
    }

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraSpacing) {
        float currentX = x;
        foreach (char c in text) {
            string s = c.ToString();
            g.DrawString(s, font, brush, currentX, y);
            SizeF sz = g.MeasureString(s, font);
            currentX += sz.Width - (font.Size * 0.38f) + extraSpacing;
        }
    }

    private static void DrawVectorIcon(Graphics g, int iconIndex, float cx, float cy, float s, Pen pen, Brush brush) {
        switch (iconIndex) {
            case 0: // Trusted Suppliers (Shield with Checkmark)
                GraphicsPath sh = new GraphicsPath();
                sh.AddLine(cx - s * 0.8f, cy - s * 0.65f, cx + s * 0.8f, cy - s * 0.65f);
                sh.AddLine(cx + s * 0.8f, cy - s * 0.65f, cx + s * 0.8f, cy + s * 0.1f);
                sh.AddBezier(cx + s * 0.8f, cy + s * 0.1f, cx + s * 0.5f, cy + s * 0.75f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                sh.AddBezier(cx, cy + s * 0.95f, cx - s * 0.5f, cy + s * 0.75f, cx - s * 0.8f, cy + s * 0.1f, cx - s * 0.8f, cy + s * 0.1f);
                sh.CloseFigure();
                g.DrawPath(pen, sh);
                using (Pen checkPen = new Pen(pen.Color, pen.Width * 1.35f)) {
                    checkPen.StartCap = LineCap.Round;
                    checkPen.EndCap = LineCap.Round;
                    g.DrawLine(checkPen, cx - s * 0.4f, cy + s * 0.05f, cx - s * 0.1f, cy + s * 0.35f);
                    g.DrawLine(checkPen, cx - s * 0.1f, cy + s * 0.35f, cx + s * 0.45f, cy - s * 0.25f);
                }
                break;

            case 1: // Quality Assured (Badge Ribbon)
                GraphicsPath sh2 = new GraphicsPath();
                sh2.AddLine(cx - s * 0.75f, cy - s * 0.75f, cx + s * 0.75f, cy - s * 0.75f);
                sh2.AddLine(cx + s * 0.75f, cy - s * 0.75f, cx + s * 0.75f, cy + s * 0.2f);
                sh2.AddBezier(cx + s * 0.75f, cy + s * 0.2f, cx + s * 0.45f, cy + s * 0.85f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                sh2.AddBezier(cx, cy + s * 0.95f, cx - s * 0.45f, cy + s * 0.85f, cx - s * 0.75f, cy + s * 0.2f, cx - s * 0.75f, cy + s * 0.2f);
                sh2.CloseFigure();
                g.DrawPath(pen, sh2);
                using (Pen checkPen = new Pen(pen.Color, pen.Width * 1.35f)) {
                    checkPen.StartCap = LineCap.Round;
                    checkPen.EndCap = LineCap.Round;
                    g.DrawLine(checkPen, cx - s * 0.35f, cy + s * 0.05f, cx - s * 0.08f, cy + s * 0.38f);
                    g.DrawLine(checkPen, cx - s * 0.08f, cy + s * 0.38f, cx + s * 0.42f, cy - s * 0.22f);
                }
                break;

            case 2: // Global Sourcing (Globe)
                g.DrawEllipse(pen, cx - s * 0.85f, cy - s * 0.85f, s * 1.7f, s * 1.7f);
                g.DrawLine(pen, cx - s * 0.85f, cy, cx + s * 0.85f, cy);
                g.DrawLine(pen, cx, cy - s * 0.85f, cx, cy + s * 0.85f);
                g.DrawEllipse(pen, cx - s * 0.4f, cy - s * 0.85f, s * 0.8f, s * 1.7f);
                break;

            case 3: // On-Time Delivery (Cargo Truck)
                using (SolidBrush solidGold = new SolidBrush(pen.Color)) {
                    // Truck trailer outline and fill
                    g.DrawRectangle(pen, cx - s * 0.82f, cy - s * 0.45f, s * 0.90f, s * 0.62f);
                    // Truck cab
                    GraphicsPath cab = new GraphicsPath();
                    cab.AddLine(cx + s * 0.12f, cy - s * 0.2f, cx + s * 0.45f, cy - s * 0.2f);
                    cab.AddLine(cx + s * 0.45f, cy - s * 0.2f, cx + s * 0.78f, cy + s * 0.05f);
                    cab.AddLine(cx + s * 0.78f, cy + s * 0.05f, cx + s * 0.78f, cy + s * 0.17f);
                    cab.AddLine(cx + s * 0.78f, cy + s * 0.17f, cx + s * 0.12f, cy + s * 0.17f);
                    cab.CloseFigure();
                    g.DrawPath(pen, cab);
                    // Wheels
                    g.DrawEllipse(pen, cx - s * 0.60f, cy + s * 0.15f, s * 0.32f, s * 0.32f);
                    g.DrawEllipse(pen, cx + s * 0.35f, cy + s * 0.15f, s * 0.32f, s * 0.32f);
                    g.FillEllipse(solidGold, cx - s * 0.52f, cy + s * 0.23f, s * 0.16f, s * 0.16f);
                    g.FillEllipse(solidGold, cx + s * 0.43f, cy + s * 0.23f, s * 0.16f, s * 0.16f);
                }
                break;
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790298228335.png"
$cleanRight = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_cropped_clean.jpg"
$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\products_crop\product_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\product_hero_banner.png"

[VibrantNavyLiteBlueHero]::GenerateBanner($src, $cleanRight, $outPng1, $outPng2, $fontSans, $fontSerif, 4)
Write-Host "Generated Vibrant Navy & Light Blue Master Products Banner successfully!"
