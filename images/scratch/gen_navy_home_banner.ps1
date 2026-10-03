Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class NavyHomeHero {
    public static void GenerateMasterBanner(string srcPath, string outPath, string fontSansPath, string fontSerifPath, int scale) {
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

                    // 2. Define the smooth bottom S-curve wave boundary
                    PointF[] curvePoints = new PointF[] {
                        new PointF(0f * scale, 132f * scale),
                        new PointF(40f * scale, 156f * scale),
                        new PointF(80f * scale, 166f * scale),
                        new PointF(120f * scale, 171f * scale),
                        new PointF(160f * scale, 171f * scale),
                        new PointF(220f * scale, 167f * scale),
                        new PointF(280f * scale, 164f * scale),
                        new PointF(340f * scale, 167f * scale),
                        new PointF(400f * scale, 175f * scale),
                        new PointF(460f * scale, 180f * scale),
                        new PointF(520f * scale, 184f * scale),
                        new PointF(600f * scale, 186f * scale),
                        new PointF(750f * scale, 188f * scale),
                        new PointF(900f * scale, 188f * scale),
                        new PointF(1024f * scale, 189f * scale)
                    };

                    GraphicsPath waveArea = new GraphicsPath();
                    waveArea.AddCurve(curvePoints, 0.45f);
                    waveArea.AddLine(1024f * scale, 189f * scale, targetW, targetH);
                    waveArea.AddLine(targetW, targetH, 0, targetH);
                    waveArea.CloseFigure();

                    // 3. Inpaint the left text area with rich, vibrant NAVY BLUE twilight gradient
                    // Strictly NO black! Real corporate Maritime Navy: #184278 to #0c2448
                    int cardRightX = 415 * scale;
                    int fadeStartX = 345 * scale;
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
                                glowPath.AddEllipse(-40 * scale, -20 * scale, 340 * scale, 220 * scale);
                                using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                    pgb.CenterColor = Color.FromArgb(50, 45, 115, 195);
                                    pgb.SurroundColors = new Color[] { Color.FromArgb(0, 15, 40, 80) };
                                    pg.FillPath(pgb, glowPath);
                                }
                            }

                            // Smooth horizontal fade into the sunset port center
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
                        Color.FromArgb(245, 205, 85), Color.FromArgb(220, 145, 30))) {
                        using (Pen goldPen = new Pen(goldPenBrush, 1.6f * scale)) {
                            g.DrawPath(goldPen, strokePath);
                        }
                    }

                    // 6. Right Stats Card Area (Opaque Maritime Navy Blue glassmorphic - NO black!)
                    int cardX = 868 * scale;
                    int cardY = 17 * scale;
                    int cardW = 144 * scale;
                    int cardH = 153 * scale;
                    int cardRadius = 11 * scale;

                    GraphicsPath cardPath = GetRoundedRect(new Rectangle(cardX, cardY, cardW, cardH), cardRadius);

                    // Deep Maritime Navy gradient (strictly NO black!)
                    using (LinearGradientBrush cardBg = new LinearGradientBrush(
                        new Rectangle(cardX, cardY, cardW, cardH),
                        Color.FromArgb(245, 20, 52, 98),
                        Color.FromArgb(248, 12, 34, 68),
                        LinearGradientMode.Vertical)) {
                        g.FillPath(cardBg, cardPath);
                    }
                    using (Pen glassPen = new Pen(Color.FromArgb(160, 255, 255, 255), 1.2f * scale)) {
                        g.DrawPath(glassPen, cardPath);
                    }

                    // 7. Load custom fonts
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

                    // 8. Draw Left Typography (Navy Blue and White Palette)
                    float startX = 56f * scale;

                    // Eyebrow: INTERNATIONAL TRADE & LOGISTICS in crisp Ice-White
                    using (Font eyebrowFont = new Font(famSans, 6.8f * scale, FontStyle.Bold))
                    using (SolidBrush whiteEyebrow = new SolidBrush(Color.FromArgb(255, 235, 245, 255))) {
                        DrawSpacedString(g, "INTERNATIONAL TRADE & LOGISTICS", eyebrowFont, whiteEyebrow, startX, 26f * scale, 1.2f * scale);
                    }

                    // Heading: Trade Beyond Borders, & Built for Growth in Pure Brilliant White
                    using (Font headingFont = new Font(famSerif, 18.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                        g.DrawString("Trade Beyond Borders,", headingFont, whiteHeading, startX - (0.5f * scale), 39f * scale);
                        g.DrawString("Built for Growth", headingFont, whiteHeading, startX - (0.5f * scale), 66f * scale);
                    }

                    // Paragraph: High contrast ice-white
                    using (Font descFont = new Font(famSans, 5.8f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(255, 226, 238, 250))) {
                        string l1 = "CONCEPT EXIM connects businesses worldwide with seamless";
                        string l2 = "import-export solutions, reliable logistics and trusted partnerships.";
                        float lineSpacing = 8.6f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, 98f * scale);
                        g.DrawString(l2, descFont, descBrush, startX, 98f * scale + lineSpacing);
                    }

                    // Two Buttons (Navy Blue and White Theme)
                    float btnY = 128f * scale;
                    float btnH = 22f * scale;

                    // Button 1: Explore Our Services -> (Crisp White Button with Navy Blue text)
                    float btn1W = 106f * scale;
                    GraphicsPath btn1Path = GetRoundedRect(new Rectangle((int)startX, (int)btnY, (int)btn1W, (int)btnH), 5 * scale);
                    using (SolidBrush btn1Bg = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillPath(btn1Bg, btn1Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush btn1Text = new SolidBrush(Color.FromArgb(255, 12, 34, 68))) {
                        string b1Str = "Explore Our Services  \u2192";
                        SizeF b1Size = g.MeasureString(b1Str, btnFont);
                        g.DrawString(b1Str, btnFont, btn1Text, startX + (btn1W - b1Size.Width) / 2f, btnY + (btnH - b1Size.Height) / 2f);
                    }

                    // Button 2: Get a Custom Quote (Deep Navy button with crisp White 1.5px border and White text)
                    float btn2X = startX + btn1W + (12f * scale);
                    float btn2W = 102f * scale;
                    GraphicsPath btn2Path = GetRoundedRect(new Rectangle((int)btn2X, (int)btnY, (int)btn2W, (int)btnH), 5 * scale);
                    using (SolidBrush btn2Bg = new SolidBrush(Color.FromArgb(220, 16, 44, 84))) {
                        g.FillPath(btn2Bg, btn2Path);
                    }
                    using (Pen btn2Pen = new Pen(Color.FromArgb(255, 255, 255, 255), 1.3f * scale)) {
                        g.DrawPath(btn2Pen, btn2Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                        string b2Str = "Get a Custom Quote";
                        SizeF b2Size = g.MeasureString(b2Str, btnFont);
                        g.DrawString(b2Str, btnFont, whiteBrush, btn2X + (btn2W - b2Size.Width) / 2f, btnY + (btnH - b2Size.Height) / 2f);
                    }

                    // 9. Draw Right Stats Card Content (Navy Blue and White Palette)
                    float statRowH = 34f * scale;
                    float iconCX = cardX + 22f * scale;
                    float textStartX = cardX + 41f * scale;
                    float iconR = 8.5f * scale;

                    string[][] statsData = new string[][] {
                        new string[] { "150+", "Countries Served" },
                        new string[] { "2,500+", "Successful Shipments" },
                        new string[] { "500+", "Global Partners" },
                        new string[] { "98%", "On-Time Delivery Rate" }
                    };

                    using (Pen iconRing = new Pen(Color.FromArgb(200, 255, 255, 255), 1.2f * scale))
                    using (SolidBrush iconFill = new SolidBrush(Color.FromArgb(40, 255, 255, 255)))
                    using (SolidBrush iconWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (Pen iconPen = new Pen(Color.FromArgb(255, 255, 255), 1.2f * scale))
                    using (Font numFont = new Font(famSans, 7.8f * scale, FontStyle.Bold))
                    using (Font labelFont = new Font(famSans, 4.6f * scale, FontStyle.Regular))
                    using (SolidBrush numBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush labelBrush = new SolidBrush(Color.FromArgb(215, 230, 245)))
                    using (Pen dividerPen = new Pen(Color.FromArgb(45, 255, 255, 255), 1.0f * scale)) {
                        for (int i = 0; i < 4; i++) {
                            float rowCY = cardY + (18f * scale) + (i * statRowH);

                            // Draw icon circle badge
                            g.FillEllipse(iconFill, iconCX - iconR, rowCY - iconR, iconR * 2, iconR * 2);
                            g.DrawEllipse(iconRing, iconCX - iconR, rowCY - iconR, iconR * 2, iconR * 2);

                            // Draw vector icon in pure white
                            DrawStatIcon(g, i, iconCX, rowCY, iconR, iconPen, iconWhite);

                            // Draw text: Number on line 1, Label on line 2
                            g.DrawString(statsData[i][0], numFont, numBrush, textStartX, rowCY - (8.5f * scale));
                            g.DrawString(statsData[i][1], labelFont, labelBrush, textStartX, rowCY + (1.5f * scale));

                            // Divider between rows
                            if (i < 3) {
                                float divY = rowCY + (16f * scale);
                                g.DrawLine(dividerPen, textStartX, divY, cardX + cardW - (12f * scale), divY);
                            }
                        }
                    }
                }

                destBmp.Save(outPath, ImageFormat.Png);
            }
        }
    }

    private static GraphicsPath GetRoundedRect(Rectangle bounds, int radius) {
        int diameter = radius * 2;
        Size size = new Size(diameter, diameter);
        Rectangle arc = new Rectangle(bounds.Location, size);
        GraphicsPath path = new GraphicsPath();

        if (radius == 0) {
            path.AddRectangle(bounds);
            return path;
        }

        path.AddArc(arc, 180, 90);
        arc.X = bounds.Right - diameter;
        path.AddArc(arc, 270, 90);
        arc.Y = bounds.Bottom - diameter;
        path.AddArc(arc, 0, 90);
        arc.X = bounds.Left;
        path.AddArc(arc, 90, 90);
        path.CloseFigure();
        return path;
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

    private static void DrawStatIcon(Graphics g, int index, float cx, float cy, float r, Pen pen, SolidBrush brush) {
        float s = r * 0.55f;
        switch (index) {
            case 0: // Globe
                g.DrawEllipse(pen, cx - s, cy - s, s * 2, s * 2);
                g.DrawLine(pen, cx - s, cy, cx + s, cy);
                g.DrawLine(pen, cx, cy - s, cx, cy + s);
                g.DrawEllipse(pen, cx - s * 0.45f, cy - s, s * 0.9f, s * 2);
                break;
            case 1: // Cargo Ship
                GraphicsPath hull = new GraphicsPath();
                hull.AddLine(cx - s * 0.85f, cy + s * 0.2f, cx + s * 0.85f, cy + s * 0.2f);
                hull.AddLine(cx + s * 0.85f, cy + s * 0.2f, cx + s * 0.6f, cy + s * 0.7f);
                hull.AddLine(cx + s * 0.6f, cy + s * 0.7f, cx - s * 0.65f, cy + s * 0.7f);
                hull.CloseFigure();
                g.FillPath(brush, hull);
                // Bridge / Deckhouse
                g.FillRectangle(brush, cx - s * 0.55f, cy - s * 0.45f, s * 0.35f, s * 0.6f);
                g.DrawLine(pen, cx - s * 0.38f, cy - s * 0.75f, cx - s * 0.38f, cy - s * 0.45f);
                // Containers
                g.FillRectangle(brush, cx - s * 0.05f, cy - s * 0.25f, s * 0.35f, s * 0.4f);
                g.FillRectangle(brush, cx + s * 0.4f, cy - s * 0.25f, s * 0.35f, s * 0.4f);
                break;
            case 2: // Handshake / Partners
                GraphicsPath handL = new GraphicsPath();
                handL.AddLine(cx - s * 0.85f, cy - s * 0.35f, cx - s * 0.15f, cy + s * 0.1f);
                handL.AddLine(cx - s * 0.15f, cy + s * 0.1f, cx - s * 0.35f, cy + s * 0.45f);
                handL.AddLine(cx - s * 0.35f, cy + s * 0.45f, cx - s * 0.85f, cy + s * 0.05f);
                handL.CloseFigure();
                g.DrawPath(pen, handL);

                GraphicsPath handR = new GraphicsPath();
                handR.AddLine(cx + s * 0.85f, cy - s * 0.35f, cx + s * 0.15f, cy + s * 0.1f);
                handR.AddLine(cx + s * 0.15f, cy + s * 0.1f, cx + s * 0.35f, cy + s * 0.45f);
                handR.AddLine(cx + s * 0.35f, cy + s * 0.45f, cx + s * 0.85f, cy + s * 0.05f);
                handR.CloseFigure();
                g.DrawPath(pen, handR);

                // Clasp center knot
                g.FillEllipse(brush, cx - s * 0.3f, cy - s * 0.05f, s * 0.6f, s * 0.45f);
                break;
            case 3: // Shield with Checkmark
                GraphicsPath shield = new GraphicsPath();
                shield.AddLine(cx - s * 0.75f, cy - s * 0.8f, cx + s * 0.75f, cy - s * 0.8f);
                shield.AddLine(cx + s * 0.75f, cy - s * 0.8f, cx + s * 0.75f, cy + s * 0.1f);
                shield.AddBezier(cx + s * 0.75f, cy + s * 0.1f, cx + s * 0.5f, cy + s * 0.7f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                shield.AddBezier(cx, cy + s * 0.95f, cx - s * 0.5f, cy + s * 0.7f, cx - s * 0.75f, cy + s * 0.1f, cx - s * 0.75f, cy + s * 0.1f);
                shield.CloseFigure();
                g.DrawPath(pen, shield);
                // Checkmark
                using (Pen checkPen = new Pen(brush.Color, pen.Width * 1.35f)) {
                    checkPen.StartCap = LineCap.Round;
                    checkPen.EndCap = LineCap.Round;
                    g.DrawLine(checkPen, cx - s * 0.32f, cy + s * 0.05f, cx - s * 0.05f, cy + s * 0.38f);
                    g.DrawLine(checkPen, cx - s * 0.05f, cy + s * 0.38f, cx + s * 0.42f, cy - s * 0.22f);
                }
                break;
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9df06f00-e59b-48d6-91d0-af3c5f58dc58\.user_uploaded\media_1790230100995.png"
$masterOut = "c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png"

[NavyHomeHero]::GenerateMasterBanner($src, $masterOut, $fontSans, $fontSerif, 4)
Write-Host "Generated Navy Blue and White home_hero_banner.png successfully!"
