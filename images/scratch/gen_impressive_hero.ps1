Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ImpressiveNavyHero {
    public static void GenerateBanner(string srcPath, string outPath, string fontSansPath, string fontSerifPath) {
        using (Bitmap baseBmp = new Bitmap(srcPath)) {
            int w = baseBmp.Width;   // 4096
            int h = baseBmp.Height;  // 756
            float scale = (float)w / 1024f; // 4.0

            using (Bitmap destBmp = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Process base photo: lift all shadows from black into rich maritime navy blue!
                    // Deepest black (0,0,0) becomes rich navy (14, 38, 78) - strictly NO BLACK!
                    using (Bitmap gradedPhoto = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
                        BitmapData srcData = baseBmp.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
                        BitmapData dstData = gradedPhoto.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);

                        int bytes = Math.Abs(srcData.Stride) * h;
                        byte[] rgbValues = new byte[bytes];
                        System.Runtime.InteropServices.Marshal.Copy(srcData.Scan0, rgbValues, 0, bytes);

                        for (int i = 0; i < bytes; i += 4) {
                            byte b = rgbValues[i];
                            byte gVal = rgbValues[i + 1];
                            byte r = rgbValues[i + 2];
                            byte a = rgbValues[i + 3];

                            // Calculate luminance
                            float lum = 0.299f * r + 0.587f * gVal + 0.114f * b;

                            // Shadow lifting: if luminance is low (dark/black areas like ship hull, crane shadows)
                            // lift floor so it turns into deep rich navy blue (R:14, G:36, B:76)
                            float shadowFactor = Math.Max(0f, 1f - (lum / 90f));
                            
                            int newR = (int)(r + shadowFactor * 14f);
                            int newG = (int)(gVal + shadowFactor * 36f);
                            int newB = (int)(b + shadowFactor * 78f);

                            // Color grade towards rich navy-azure
                            newB = Math.Min(255, (int)(newB * 1.06f));
                            newR = Math.Min(255, Math.Max(12, newR));
                            newG = Math.Min(255, Math.Max(32, newG));
                            newB = Math.Min(255, Math.Max(70, newB));

                            rgbValues[i] = (byte)newB;
                            rgbValues[i + 1] = (byte)newG;
                            rgbValues[i + 2] = (byte)newR;
                            rgbValues[i + 3] = a;
                        }

                        System.Runtime.InteropServices.Marshal.Copy(rgbValues, 0, dstData.Scan0, bytes);
                        baseBmp.UnlockBits(srcData);
                        gradedPhoto.UnlockBits(dstData);

                        g.DrawImage(gradedPhoto, 0, 0, w, h);
                    }

                    // 2. Define smooth S-curve wave boundary along bottom
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
                    waveArea.AddLine(1024f * scale, 189f * scale, w, h);
                    waveArea.AddLine(w, h, 0, h);
                    waveArea.CloseFigure();

                    // 3. Exclude the bottom wave so navy gradient never touches the bottom white curve
                    Region origClip = g.Clip;
                    g.ExcludeClip(new Region(waveArea));

                    // 4. Inpaint Left Hero Side with Rich Vibrant Corporate Navy Blue Gradient
                    // Strictly NO black! Vibrant Royal Navy: #1c5296 to #0e305e
                    int cardRightX = (int)(425 * scale);
                    int fadeStartX = (int)(335 * scale);
                    float fadeWidth = (float)(cardRightX - fadeStartX);

                    using (Bitmap leftPatch = new Bitmap(cardRightX, h, PixelFormat.Format32bppArgb)) {
                        using (Graphics pg = Graphics.FromImage(leftPatch)) {
                            pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            pg.SmoothingMode = SmoothingMode.HighQuality;

                            // Fill with rich Navy Blue vertical gradient
                            using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                new Rectangle(0, 0, cardRightX, h),
                                Color.FromArgb(255, 26, 75, 140),   // Royal Navy top
                                Color.FromArgb(255, 14, 46, 92),    // Deep vibrant Maritime Navy bottom (NO black!)
                                LinearGradientMode.Vertical)) {

                                ColorBlend cb = new ColorBlend(4);
                                cb.Positions = new float[] { 0f, 0.32f, 0.72f, 1f };
                                cb.Colors = new Color[] {
                                    Color.FromArgb(255, 28, 80, 148), // #1c5094 Bright Royal Navy
                                    Color.FromArgb(255, 22, 64, 122), // #16407a Rich Navy
                                    Color.FromArgb(255, 17, 52, 102), // #113466 Deep Navy
                                    Color.FromArgb(255, 14, 44, 90)   // #0e2c5a Solid Navy Blue
                                };
                                bgBrush.InterpolationColors = cb;
                                pg.FillRectangle(bgBrush, 0, 0, cardRightX, h);
                            }

                            // Ethereal luminous blue radial bloom behind the headline
                            using (GraphicsPath glowPath = new GraphicsPath()) {
                                glowPath.AddEllipse(-60 * scale, -30 * scale, 420 * scale, 280 * scale);
                                using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                    pgb.CenterColor = Color.FromArgb(65, 56, 140, 235); // Luminous sapphire blue
                                    pgb.SurroundColors = new Color[] { Color.FromArgb(0, 14, 44, 90) };
                                    pg.FillPath(pgb, glowPath);
                                }
                            }

                            // Subtle secondary ambient blue highlight near bottom left
                            using (GraphicsPath glowPath2 = new GraphicsPath()) {
                                glowPath2.AddEllipse(20 * scale, 90 * scale, 260 * scale, 150 * scale);
                                using (PathGradientBrush pgb2 = new PathGradientBrush(glowPath2)) {
                                    pgb2.CenterColor = Color.FromArgb(35, 70, 160, 255);
                                    pgb2.SurroundColors = new Color[] { Color.FromArgb(0, 14, 44, 90) };
                                    pg.FillPath(pgb2, glowPath2);
                                }
                            }

                            // Smooth horizontal cosine alpha fade into the sunset port photo
                            for (int y = 0; y < h; y++) {
                                for (int x = fadeStartX; x < cardRightX; x++) {
                                    float f = (float)(x - fadeStartX) / fadeWidth;
                                    float alpha = 0.5f * (1f + (float)Math.Cos(f * Math.PI));
                                    Color orig = leftPatch.GetPixel(x, y);
                                    leftPatch.SetPixel(x, y, Color.FromArgb((int)(orig.A * alpha), orig.R, orig.G, orig.B));
                                }
                            }
                        }

                        g.DrawImage(leftPatch, 0, 0);
                    }

                    // Restore clip
                    g.Clip = origClip;

                    // 5. Fill bottom wave area with 100% pure crisp white
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillPath(whiteBrush, waveArea);
                    }

                    // 6. Draw clean Navy Blue and White elegant wave accent borders (NO gold, NO black!)
                    GraphicsPath strokePath = new GraphicsPath();
                    strokePath.AddCurve(curvePoints, 0.45f);

                    // Deep Navy accent stroke
                    using (Pen navyPen = new Pen(Color.FromArgb(220, 20, 60, 115), 2.2f * scale)) {
                        g.DrawPath(navyPen, strokePath);
                    }
                    // Pure White highlight ribbon stroke
                    using (Pen whitePen = new Pen(Color.FromArgb(255, 255, 255, 255), 1.0f * scale)) {
                        g.DrawPath(whitePen, strokePath);
                    }

                    // 7. Right Stats Card Area (Frosted Royal Navy Blue Glassmorphism - NO black!)
                    int cardX = (int)(868 * scale);
                    int cardY = (int)(17 * scale);
                    int cardW = (int)(144 * scale);
                    int cardH = (int)(153 * scale);
                    int cardRadius = (int)(12 * scale);

                    GraphicsPath cardPath = GetRoundedRect(new Rectangle(cardX, cardY, cardW, cardH), cardRadius);

                    // Vibrant Maritime Navy Blue frosted glass gradient
                    using (LinearGradientBrush cardBg = new LinearGradientBrush(
                        new Rectangle(cardX, cardY, cardW, cardH),
                        Color.FromArgb(235, 22, 65, 125),   // Rich Royal Navy top
                        Color.FromArgb(242, 14, 45, 92),    // Deep Navy bottom (NO black!)
                        LinearGradientMode.Vertical)) {
                        g.FillPath(cardBg, cardPath);
                    }
                    // Pure White crisp card outline with subtle glow
                    using (Pen glassPen = new Pen(Color.FromArgb(210, 255, 255, 255), 1.4f * scale)) {
                        g.DrawPath(glassPen, cardPath);
                    }

                    // 8. Custom Typography (Plus Jakarta Sans & Playfair Display)
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

                    // 9. Render Left Hero Content (Navy Blue and Pure White Theme)
                    float startX = 56f * scale;

                    // Eyebrow: INTERNATIONAL TRADE & LOGISTICS in pure crisp white
                    using (Font eyebrowFont = new Font(famSans, 6.8f * scale, FontStyle.Bold))
                    using (SolidBrush whiteEyebrow = new SolidBrush(Color.FromArgb(255, 240, 248, 255))) {
                        DrawSpacedString(g, "INTERNATIONAL TRADE & LOGISTICS", eyebrowFont, whiteEyebrow, startX, 26f * scale, 1.25f * scale);
                    }

                    // Headline: Trade Beyond Borders, / Built for Growth in Pure Brilliant White
                    using (Font headingFont = new Font(famSerif, 18.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        // Soft navy shadow for maximum legibility and depth
                        using (SolidBrush shadowBrush = new SolidBrush(Color.FromArgb(80, 10, 30, 65))) {
                            g.DrawString("Trade Beyond Borders,", headingFont, shadowBrush, startX - (0.5f * scale) + (1f * scale), 39f * scale + (1.2f * scale));
                            g.DrawString("Built for Growth", headingFont, shadowBrush, startX - (0.5f * scale) + (1f * scale), 66f * scale + (1.2f * scale));
                        }
                        g.DrawString("Trade Beyond Borders,", headingFont, whiteHeading, startX - (0.5f * scale), 39f * scale);
                        g.DrawString("Built for Growth", headingFont, whiteHeading, startX - (0.5f * scale), 66f * scale);
                    }

                    // Description: High contrast crisp white
                    using (Font descFont = new Font(famSans, 5.8f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(255, 242, 248, 255))) {
                        string l1 = "CONCEPT EXIM connects businesses worldwide with seamless";
                        string l2 = "import-export solutions, reliable logistics and trusted partnerships.";
                        float lineSpacing = 8.6f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, 98f * scale);
                        g.DrawString(l2, descFont, descBrush, startX, 98f * scale + lineSpacing);
                    }

                    // 10. Two Call-To-Action Buttons (Navy Blue and White Palette)
                    float btnY = 128f * scale;
                    float btnH = 22f * scale;

                    // Button 1: Explore Our Services -> (Pure White button with Navy Blue text)
                    float btn1W = 106f * scale;
                    GraphicsPath btn1Path = GetRoundedRect(new Rectangle((int)startX, (int)btnY, (int)btn1W, (int)btnH), (int)(5 * scale));
                    
                    // Button drop shadow (navy glow)
                    using (SolidBrush bShadow = new SolidBrush(Color.FromArgb(60, 10, 35, 75))) {
                        GraphicsPath bShPath = GetRoundedRect(new Rectangle((int)startX, (int)(btnY + 1.5f * scale), (int)btn1W, (int)btnH), (int)(5 * scale));
                        g.FillPath(bShadow, bShPath);
                    }

                    using (SolidBrush btn1Bg = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillPath(btn1Bg, btn1Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush btn1Text = new SolidBrush(Color.FromArgb(255, 14, 46, 92))) { // Navy Blue Text
                        string b1Str = "Explore Our Services  \u2192";
                        SizeF b1Size = g.MeasureString(b1Str, btnFont);
                        g.DrawString(b1Str, btnFont, btn1Text, startX + (btn1W - b1Size.Width) / 2f, btnY + (btnH - b1Size.Height) / 2f);
                    }

                    // Button 2: Get a Custom Quote (Royal Navy button with crisp White 1.6px border and White text)
                    float btn2X = startX + btn1W + (12f * scale);
                    float btn2W = 102f * scale;
                    GraphicsPath btn2Path = GetRoundedRect(new Rectangle((int)btn2X, (int)btnY, (int)btn2W, (int)btnH), (int)(5 * scale));
                    
                    using (SolidBrush btn2Bg = new SolidBrush(Color.FromArgb(240, 20, 60, 118))) { // Royal Navy fill
                        g.FillPath(btn2Bg, btn2Path);
                    }
                    using (Pen btn2Pen = new Pen(Color.FromArgb(255, 255, 255, 255), 1.6f * scale)) { // Pure White border
                        g.DrawPath(btn2Pen, btn2Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        string b2Str = "Get a Custom Quote";
                        SizeF b2Size = g.MeasureString(b2Str, btnFont);
                        g.DrawString(b2Str, btnFont, whiteBrush, btn2X + (btn2W - b2Size.Width) / 2f, btnY + (btnH - b2Size.Height) / 2f);
                    }

                    // 11. Right Stats Card Content (Pure White & Navy Blue)
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

                    using (Pen iconRing = new Pen(Color.FromArgb(230, 255, 255, 255), 1.3f * scale))
                    using (SolidBrush iconFill = new SolidBrush(Color.FromArgb(50, 255, 255, 255)))
                    using (SolidBrush iconWhite = new SolidBrush(Color.FromArgb(255, 255, 255, 255)))
                    using (Pen iconPen = new Pen(Color.FromArgb(255, 255, 255, 255), 1.3f * scale))
                    using (Font numFont = new Font(famSans, 8.0f * scale, FontStyle.Bold))
                    using (Font labelFont = new Font(famSans, 4.6f * scale, FontStyle.Regular))
                    using (SolidBrush numBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255)))
                    using (SolidBrush labelBrush = new SolidBrush(Color.FromArgb(230, 242, 255)))
                    using (Pen dividerPen = new Pen(Color.FromArgb(60, 255, 255, 255), 1.0f * scale)) {
                        for (int i = 0; i < 4; i++) {
                            float rowCY = cardY + (18f * scale) + (i * statRowH);

                            // Draw circle badge
                            g.FillEllipse(iconFill, iconCX - iconR, rowCY - iconR, iconR * 2, iconR * 2);
                            g.DrawEllipse(iconRing, iconCX - iconR, rowCY - iconR, iconR * 2, iconR * 2);

                            // Draw crisp vector icon in pure white
                            DrawStatIcon(g, i, iconCX, rowCY, iconR, iconPen, iconWhite);

                            // Draw stat values in pure white
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

$src = "c:\Users\Administrator\Pictures\emports and exports\images\home_hero_master_4x.png"
$testOut = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_impressive_navy_hero.png"

[ImpressiveNavyHero]::GenerateBanner($src, $testOut, $fontSans, $fontSerif)
Write-Host "Generated test_impressive_navy_hero.png successfully!"
