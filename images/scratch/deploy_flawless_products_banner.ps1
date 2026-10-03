Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class MasterProductsHeroFull {
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

                    // 1. Draw base photo panorama
                    g.DrawImage(patchedSrc, new Rectangle(0, 0, targetW, targetH), srcRect, GraphicsUnit.Pixel);

                    // 2. Inpaint left text area with Corporate Deep Maritime Navy Gradient - all the way to bottom!
                    int cardRightX = 465 * scale;
                    int fadeStartX = 385 * scale;
                    float fadeWidth = (float)(cardRightX - fadeStartX);

                    using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                        using (Graphics pg = Graphics.FromImage(patch)) {
                            pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            pg.SmoothingMode = SmoothingMode.HighQuality;

                            // Vertical Navy gradient from rich royal maritime navy at top to deep solid navy at bottom
                            using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                new Rectangle(0, 0, cardRightX, targetH),
                                Color.FromArgb(255, 20, 56, 105),
                                Color.FromArgb(255, 7, 24, 52),
                                LinearGradientMode.Vertical)) {

                                ColorBlend cb = new ColorBlend(4);
                                cb.Positions = new float[] { 0f, 0.30f, 0.70f, 1f };
                                cb.Colors = new Color[] {
                                    Color.FromArgb(255, 20, 56, 105), // #143869 top corporate navy
                                    Color.FromArgb(255, 15, 45, 86),  // #0f2d56
                                    Color.FromArgb(255, 10, 32, 65),  // #0a2041
                                    Color.FromArgb(255, 6, 20, 44)    // #06142c deep midnight maritime navy
                                };
                                bgBrush.InterpolationColors = cb;
                                pg.FillRectangle(bgBrush, 0, 0, cardRightX, targetH);
                            }

                            // Subtle luminous blue depth accent in upper-left
                            using (GraphicsPath glowPath = new GraphicsPath()) {
                                glowPath.AddEllipse(-40 * scale, -30 * scale, 390 * scale, 240 * scale);
                                using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                    pgb.CenterColor = Color.FromArgb(50, 45, 115, 195);
                                    pgb.SurroundColors = new Color[] { Color.FromArgb(0, 10, 30, 65) };
                                    pg.FillPath(pgb, glowPath);
                                }
                            }

                            // Smooth cosine fade into the sunset port / world map
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

                    // 3. Elegant slim gold baseline across the entire banner bottom
                    using (LinearGradientBrush goldLineBrush = new LinearGradientBrush(
                        new Point(0, targetH - 6), new Point(targetW, targetH - 6),
                        Color.FromArgb(245, 205, 85), Color.FromArgb(215, 140, 25))) {
                        using (Pen goldPen = new Pen(goldLineBrush, 2.0f * scale)) {
                            g.DrawLine(goldPen, 0, targetH - (1.2f * scale), targetW, targetH - (1.2f * scale));
                        }
                    }

                    // 4. Load fonts
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

                    // 5. Draw Left Typography
                    float startX = 46f * scale;

                    // Eyebrow: PREMIUM QUALITY • GLOBAL SOURCING
                    float eyebrowY = 24f * scale;
                    using (Font eyebrowFont = new Font(famSans, 5.8f * scale, FontStyle.Bold))
                    using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(245, 208, 105))) {
                        string bullet = ((char)0x2022).ToString();
                        string eyebrowText = "PREMIUM QUALITY  " + bullet + "  GLOBAL SOURCING";
                        DrawSpacedString(g, eyebrowText, eyebrowFont, goldEyebrow, startX, eyebrowY, 1.1f * scale);
                    }

                    // Main Heading: Our Premium Products
                    float titleY = 38f * scale;
                    using (Font headingFont = new Font(famSerif, 23.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush goldHeading = new SolidBrush(Color.FromArgb(248, 208, 106))) {
                        string ourStr = "Our ";
                        g.DrawString(ourStr, headingFont, whiteHeading, startX, titleY);
                        SizeF ourSize = g.MeasureString(ourStr, headingFont);
                        float premX = startX + ourSize.Width - (5.5f * scale);
                        g.DrawString("Premium Products", headingFont, goldHeading, premX, titleY);
                    }

                    // Description: 2 lines
                    float descY = 74f * scale;
                    using (Font descFont = new Font(famSans, 5.7f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(255, 232, 242, 252))) {
                        string l1 = "From farms to industries, we bring you the finest quality products";
                        string l2 = "sourced globally, ensuring trust, purity and excellence in every shipment.";
                        float lineSpacing = 8.8f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, descY);
                        g.DrawString(l2, descFont, descBrush, startX, descY + lineSpacing);
                    }

                    // 6. Draw 4 Feature Badges in horizontal row
                    float badgeY = 104f * scale;
                    float iconRadius = 8.8f * scale;

                    string[][] badgeData = new string[][] {
                        new string[] { "Trusted", "Suppliers" },
                        new string[] { "Quality", "Assured" },
                        new string[] { "Global", "Sourcing" },
                        new string[] { "On-Time", "Delivery" }
                    };

                    float[] badgeXOffsets = new float[] {
                        startX,
                        startX + 84f * scale,
                        startX + 168f * scale,
                        startX + 252f * scale
                    };

                    using (Font badgeFont = new Font(famSans, 4.8f * scale, FontStyle.Bold))
                    using (Font badgeSubFont = new Font(famSans, 4.5f * scale, FontStyle.Regular))
                    using (SolidBrush iconGoldBrush = new SolidBrush(Color.FromArgb(245, 205, 95)))
                    using (SolidBrush textWhiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush textMutedBrush = new SolidBrush(Color.FromArgb(215, 228, 242)))
                    using (Pen iconGoldPen = new Pen(Color.FromArgb(245, 205, 95), 1.3f * scale)) {
                        for (int i = 0; i < 4; i++) {
                            float bx = badgeXOffsets[i];
                            float icx = bx + iconRadius;
                            float icy = badgeY + iconRadius;

                            // Draw circle border
                            g.DrawEllipse(iconGoldPen, icx - iconRadius, icy - iconRadius, iconRadius * 2, iconRadius * 2);

                            // Draw symbol
                            DrawBadgeSymbol(g, i, icx, icy, iconRadius * 0.55f, iconGoldPen, iconGoldBrush);

                            // Text next to circle
                            float tx = icx + iconRadius + (6.5f * scale);
                            g.DrawString(badgeData[i][0], badgeFont, textWhiteBrush, tx, badgeY + (1.2f * scale));
                            g.DrawString(badgeData[i][1], badgeSubFont, textMutedBrush, tx, badgeY + (8.5f * scale));
                        }
                    }
                }

                destBmp.Save(outPng1, ImageFormat.Png);
                destBmp.Save(outPng2, ImageFormat.Png);
            }
        }
    }

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraLetterSpace) {
        float cx = x;
        for (int i = 0; i < text.Length; i++) {
            string s = text[i].ToString();
            g.DrawString(s, font, brush, cx, y);
            SizeF sz = g.MeasureString(s, font);
            cx += sz.Width + extraLetterSpace - (font.SizeInPoints * 0.45f);
        }
    }

    private static void DrawBadgeSymbol(Graphics g, int type, float cx, float cy, float s, Pen pen, Brush brush) {
        switch (type) {
            case 0: // Trusted Suppliers (Shield)
                GraphicsPath sh = new GraphicsPath();
                sh.AddLine(cx - s * 0.8f, cy - s * 0.8f, cx + s * 0.8f, cy - s * 0.8f);
                sh.AddLine(cx + s * 0.8f, cy - s * 0.8f, cx + s * 0.8f, cy + s * 0.1f);
                sh.AddBezier(cx + s * 0.8f, cy + s * 0.1f, cx + s * 0.5f, cy + s * 0.85f, cx, cy + s * 1.05f, cx, cy + s * 1.05f);
                sh.AddBezier(cx, cy + s * 1.05f, cx - s * 0.5f, cy + s * 0.85f, cx - s * 0.8f, cy + s * 0.1f, cx - s * 0.8f, cy + s * 0.1f);
                sh.CloseFigure();
                g.DrawPath(pen, sh);
                using (Font chk = new Font("Arial", s * 0.85f, FontStyle.Bold)) {
                    g.DrawString("✓", chk, brush, cx - s * 0.48f, cy - s * 0.65f);
                }
                break;

            case 1: // Quality Assured (Check inside Shield)
                GraphicsPath sh2 = new GraphicsPath();
                sh2.AddLine(cx - s * 0.8f, cy - s * 0.8f, cx + s * 0.8f, cy - s * 0.8f);
                sh2.AddLine(cx + s * 0.8f, cy - s * 0.8f, cx + s * 0.8f, cy + s * 0.1f);
                sh2.AddBezier(cx + s * 0.8f, cy + s * 0.1f, cx + s * 0.5f, cy + s * 0.85f, cx, cy + s * 1.05f, cx, cy + s * 1.05f);
                sh2.AddBezier(cx, cy + s * 1.05f, cx - s * 0.5f, cy + s * 0.85f, cx - s * 0.8f, cy + s * 0.1f, cx - s * 0.8f, cy + s * 0.1f);
                sh2.CloseFigure();
                g.DrawPath(pen, sh2);
                using (Pen checkPen = new Pen(brush, pen.Width * 1.35f)) {
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

[MasterProductsHeroFull]::GenerateBanner($src, $cleanRight, $outPng1, $outPng2, $fontSans, $fontSerif, 4)
Write-Host "Flawless Master Products Banner generated and deployed to both paths successfully!"
