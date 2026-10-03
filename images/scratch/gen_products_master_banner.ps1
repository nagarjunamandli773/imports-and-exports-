Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class MasterProductsHeroClean {
    public static void GenerateMasterBanner(string srcPath, string cleanRightPath, string outPng1, string outPng2, string fontSansPath, string fontSerifPath, int scale) {
        using (Bitmap rawSrc = new Bitmap(srcPath))
        using (Bitmap cleanRight = new Bitmap(cleanRightPath)) {
            // First, patch the right region of rawSrc (x >= 835) with the clean sky from cleanRight
            // to completely remove "Global Products for a Better Tomorrow"
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

                    // 1. Draw upscaled base photo panorama (clean sky, ship, planes, cranes, truck, world map, NO quote!)
                    g.DrawImage(patchedSrc, new Rectangle(0, 0, targetW, targetH), srcRect, GraphicsUnit.Pixel);

                    // 2. Define the smooth bottom S-curve wave boundary
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

                    // 3. Inpaint the left text area with rich, luminous NAVY BLUE twilight gradient
                    // Strictly NO black! Corporate Maritime Navy: #184278 to #0b2042
                    int cardRightX = 460 * scale;
                    int fadeStartX = 385 * scale;
                    float fadeWidth = (float)(cardRightX - fadeStartX);

                    // Set clip to exclude the bottom white area so navy gradient NEVER touches below curve
                    Region origClip = g.Clip;
                    g.ExcludeClip(new Region(waveArea));

                    using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                        using (Graphics pg = Graphics.FromImage(patch)) {
                            pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            pg.SmoothingMode = SmoothingMode.HighQuality;

                            // Fill with rich vertical Navy Blue gradient
                            using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                new Rectangle(0, 0, cardRightX, targetH),
                                Color.FromArgb(255, 24, 64, 120),
                                Color.FromArgb(255, 11, 32, 66),
                                LinearGradientMode.Vertical)) {

                                ColorBlend cb = new ColorBlend(4);
                                cb.Positions = new float[] { 0f, 0.28f, 0.70f, 1f };
                                cb.Colors = new Color[] {
                                    Color.FromArgb(255, 24, 64, 120),  // #184078 rich royal maritime navy at top
                                    Color.FromArgb(255, 19, 52, 98),   // #133462
                                    Color.FromArgb(255, 15, 40, 78),   // #0f284e
                                    Color.FromArgb(255, 11, 32, 66)    // #0b2042 deep navy, zero black!
                                };
                                bgBrush.InterpolationColors = cb;
                                pg.FillRectangle(bgBrush, 0, 0, cardRightX, targetH);
                            }

                            // Subtle luminous blue depth accent in upper-left
                            using (GraphicsPath glowPath = new GraphicsPath()) {
                                glowPath.AddEllipse(-30 * scale, -20 * scale, 370 * scale, 220 * scale);
                                using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                    pgb.CenterColor = Color.FromArgb(55, 45, 115, 195);
                                    pgb.SurroundColors = new Color[] { Color.FromArgb(0, 15, 40, 80) };
                                    pg.FillPath(pgb, glowPath);
                                }
                            }

                            // Smooth horizontal cosine fade into the sunset port / world map
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

                    // 4. Fill bottom wave area with pure clean white (eliminates any browser screenshot artifacts)
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillPath(whiteBrush, waveArea);
                    }

                    // 5. Draw elegant gold stroke along the S-curve
                    GraphicsPath strokePath = new GraphicsPath();
                    strokePath.AddCurve(curvePoints, 0.45f);
                    using (LinearGradientBrush goldPenBrush = new LinearGradientBrush(
                        new Point(0, 0), new Point(targetW, 0),
                        Color.FromArgb(245, 205, 85), Color.FromArgb(220, 145, 30))) {
                        using (Pen goldPen = new Pen(goldPenBrush, 1.6f * scale)) {
                            g.DrawPath(goldPen, strokePath);
                        }
                    }

                    // 6. Load custom fonts
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

                    // 7. Draw Left Typography (Ultra-crisp, razor sharp, clear, visible!)
                    float startX = 44f * scale;

                    // Eyebrow: PREMIUM QUALITY  •  GLOBAL SOURCING
                    float eyebrowY = 22f * scale;
                    using (Font eyebrowFont = new Font(famSans, 5.8f * scale, FontStyle.Bold))
                    using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(245, 208, 105))) {
                        string bullet = ((char)0x2022).ToString();
                        string eyebrowText = "PREMIUM QUALITY  " + bullet + "  GLOBAL SOURCING";
                        DrawSpacedString(g, eyebrowText, eyebrowFont, goldEyebrow, startX, eyebrowY, 1.1f * scale);
                    }

                    // Main Heading: Our (Pure Brilliant White) Premium Products (Radiant Gold)
                    float titleY = 34f * scale;
                    using (Font headingFont = new Font(famSerif, 22.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush goldHeading = new SolidBrush(Color.FromArgb(246, 206, 104))) {
                        string ourStr = "Our ";
                        g.DrawString(ourStr, headingFont, whiteHeading, startX, titleY);
                        SizeF ourSize = g.MeasureString(ourStr, headingFont);
                        float premX = startX + ourSize.Width - (5.5f * scale);
                        g.DrawString("Premium Products", headingFont, goldHeading, premX, titleY);
                    }

                    // Description: 2 lines in crisp, high-contrast ice-white
                    float descY = 69f * scale;
                    using (Font descFont = new Font(famSans, 5.6f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(255, 235, 244, 253))) {
                        string l1 = "From farms to industries, we bring you the finest quality products";
                        string l2 = "sourced globally, ensuring trust, purity and excellence in every shipment.";
                        float lineSpacing = 8.5f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, descY);
                        g.DrawString(l2, descFont, descBrush, startX, descY + lineSpacing);
                    }

                    // 8. Draw 4 Feature Badges in a horizontal row (Razor Sharp Vector Icons & Text)
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
                        startX + (92f * scale),
                        startX + (184f * scale),
                        startX + (274f * scale)
                    };

                    using (Pen badgeRing = new Pen(Color.FromArgb(235, 247, 207, 104), 1.25f * scale))
                    using (SolidBrush badgeFill = new SolidBrush(Color.FromArgb(35, 247, 207, 104)))
                    using (SolidBrush iconGold = new SolidBrush(Color.FromArgb(252, 225, 141)))
                    using (Pen iconPen = new Pen(Color.FromArgb(252, 225, 141), 1.15f * scale))
                    using (Font bTitleFont = new Font(famSans, 4.8f * scale, FontStyle.Bold))
                    using (Font bSubFont = new Font(famSans, 4.4f * scale, FontStyle.Regular))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush subBrush = new SolidBrush(Color.FromArgb(215, 230, 245)))
                    using (Pen dividerPen = new Pen(Color.FromArgb(40, 255, 255, 255), 1.0f * scale)) {
                        for (int i = 0; i < 4; i++) {
                            float bx = badgeXOffsets[i];
                            float icx = bx + iconRadius + (2f * scale);
                            float icy = badgeY + iconRadius + (3f * scale);

                            // Draw circle badge with gold ring
                            g.FillEllipse(badgeFill, icx - iconRadius, icy - iconRadius, iconRadius * 2, iconRadius * 2);
                            g.DrawEllipse(badgeRing, icx - iconRadius, icy - iconRadius, iconRadius * 2, iconRadius * 2);

                            // Draw vector icon inside circle
                            DrawBadgeIcon(g, i, icx, icy, iconRadius, iconPen, iconGold);

                            // Draw two lines of text
                            float tx = icx + iconRadius + (6f * scale);
                            g.DrawString(badgeData[i][0], bTitleFont, whiteBrush, tx, icy - (7f * scale));
                            g.DrawString(badgeData[i][1], bSubFont, subBrush, tx, icy + (1.2f * scale));

                            // Divider after items 0, 1, 2
                            if (i < 3) {
                                float divX = badgeXOffsets[i + 1] - (9f * scale);
                                g.DrawLine(dividerPen, divX, badgeY + (2f * scale), divX, badgeY + (20f * scale));
                            }
                        }
                    }
                }

                destBmp.Save(outPng1, ImageFormat.Png);
                destBmp.Save(outPng2, ImageFormat.Png);
            }

            patchedSrc.Dispose();
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
        float s = r * 0.52f;
        switch (index) {
            case 0: // Shield with star dot (Trusted Suppliers)
                GraphicsPath sh1 = new GraphicsPath();
                sh1.AddLine(cx - s * 0.7f, cy - s * 0.75f, cx + s * 0.7f, cy - s * 0.75f);
                sh1.AddLine(cx + s * 0.7f, cy - s * 0.75f, cx + s * 0.7f, cy + s * 0.1f);
                sh1.AddBezier(cx + s * 0.7f, cy + s * 0.1f, cx + s * 0.45f, cy + s * 0.7f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                sh1.AddBezier(cx, cy + s * 0.95f, cx - s * 0.45f, cy + s * 0.7f, cx - s * 0.7f, cy + s * 0.1f, cx - s * 0.7f, cy + s * 0.1f);
                sh1.CloseFigure();
                g.DrawPath(pen, sh1);
                g.FillEllipse(brush, cx - s * 0.22f, cy - s * 0.15f, s * 0.44f, s * 0.44f);
                break;

            case 1: // Quality Assured (Shield with checkmark)
                GraphicsPath sh2 = new GraphicsPath();
                sh2.AddLine(cx - s * 0.7f, cy - s * 0.75f, cx + s * 0.7f, cy - s * 0.75f);
                sh2.AddLine(cx + s * 0.7f, cy - s * 0.75f, cx + s * 0.7f, cy + s * 0.1f);
                sh2.AddBezier(cx + s * 0.7f, cy + s * 0.1f, cx + s * 0.45f, cy + s * 0.7f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                sh2.AddBezier(cx, cy + s * 0.95f, cx - s * 0.45f, cy + s * 0.7f, cx - s * 0.7f, cy + s * 0.1f, cx - s * 0.7f, cy + s * 0.1f);
                sh2.CloseFigure();
                g.DrawPath(pen, sh2);
                using (Pen checkPen = new Pen(brush.Color, pen.Width * 1.35f)) {
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
                g.FillRectangle(brush, cx - s * 0.85f, cy - s * 0.45f, s * 0.92f, s * 0.65f);
                GraphicsPath cab = new GraphicsPath();
                cab.AddLine(cx + s * 0.12f, cy - s * 0.2f, cx + s * 0.45f, cy - s * 0.2f);
                cab.AddLine(cx + s * 0.45f, cy - s * 0.2f, cx + s * 0.78f, cy + s * 0.02f);
                cab.AddLine(cx + s * 0.78f, cy + s * 0.02f, cx + s * 0.78f, cy + s * 0.2f);
                cab.AddLine(cx + s * 0.78f, cy + s * 0.2f, cx + s * 0.12f, cy + s * 0.2f);
                cab.CloseFigure();
                g.FillPath(brush, cab);
                g.FillEllipse(brush, cx - s * 0.6f, cy + s * 0.15f, s * 0.35f, s * 0.35f);
                g.FillEllipse(brush, cx + s * 0.35f, cy + s * 0.15f, s * 0.35f, s * 0.35f);
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

[MasterProductsHeroClean]::GenerateMasterBanner($src, $cleanRight, $outPng1, $outPng2, $fontSans, $fontSerif, 4)
Write-Host "Generated Master Products Banner WITHOUT quotation successfully!"
