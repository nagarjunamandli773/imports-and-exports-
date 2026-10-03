Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class Render4KHomeHeroV2 {
    public static void GenerateBanner(string photoPath, string outPathMaster, string outPathWeb, string fontSansPath, string fontSerifPath) {
        using (Bitmap photoBmp = new Bitmap(photoPath)) {
            int targetW = 4096;
            int targetH = 756;
            float scale = (float)targetW / 1024f; // 4.0

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw 4K photo covering whole banner
                    float bgScale = Math.Max((float)targetW / photoBmp.Width, (float)targetH / photoBmp.Height);
                    int drawW = (int)(photoBmp.Width * bgScale);
                    int drawH = (int)(photoBmp.Height * bgScale);
                    int drawX = (targetW - drawW) / 2;
                    int drawY = (targetH - drawH) / 2;
                    g.DrawImage(photoBmp, drawX, drawY, drawW, drawH);

                    // 2. Subtle Navy gradient on left 42%
                    int fadeEndX = (int)(targetW * 0.42f);
                    using (LinearGradientBrush gradBrush = new LinearGradientBrush(
                        new Rectangle(0, 0, fadeEndX, targetH),
                        Color.FromArgb(220, 7, 25, 47),
                        Color.FromArgb(0, 7, 25, 47),
                        LinearGradientMode.Horizontal)) {
                        g.FillRectangle(gradBrush, 0, 0, fadeEndX, targetH);
                    }

                    // 3. Subtle bottom gold line
                    using (LinearGradientBrush goldLine = new LinearGradientBrush(
                        new Point(0, targetH - 6), new Point(targetW, targetH - 6),
                        Color.FromArgb(220, 245, 185, 55), Color.FromArgb(80, 14, 46, 88))) {
                        using (Pen p = new Pen(goldLine, 3.5f)) {
                            g.DrawLine(p, 0, targetH - 2, targetW, targetH - 2);
                        }
                    }

                    // 4. Right Stats Card Area (Frosted Navy Blue glassmorphic)
                    int cardX = (int)(868f * scale);
                    int cardY = (int)(18f * scale);
                    int cardW = (int)(144f * scale);
                    int cardH = (int)(153f * scale);
                    int cardRadius = (int)(11f * scale);

                    GraphicsPath cardPath = GetRoundedRect(new Rectangle(cardX, cardY, cardW, cardH), cardRadius);

                    using (LinearGradientBrush cardBg = new LinearGradientBrush(
                        new Rectangle(cardX, cardY, cardW, cardH),
                        Color.FromArgb(246, 10, 32, 64),
                        Color.FromArgb(246, 6, 20, 42),
                        LinearGradientMode.Vertical)) {
                        g.FillPath(cardBg, cardPath);
                    }
                    using (Pen glassPen = new Pen(Color.FromArgb(130, 255, 255, 255), 1.2f * scale)) {
                        g.DrawPath(glassPen, cardPath);
                    }

                    // 5. Load custom fonts
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

                    // 6. Left Typography (Generous space from left side corner)
                    float startX = 84f * scale;

                    // Luxury Pill Eyebrow Badge
                    float pillX = startX;
                    float pillY = 22f * scale;
                    float pillH = 10f * scale;
                    float pillW = 120f * scale;
                    GraphicsPath pillPath = GetRoundedRect(new Rectangle((int)pillX, (int)pillY, (int)pillW, (int)pillH), (int)(pillH / 2f));
                    using (SolidBrush pillBg = new SolidBrush(Color.FromArgb(45, 245, 195, 82))) {
                        g.FillPath(pillBg, pillPath);
                    }
                    using (Pen pillPen = new Pen(Color.FromArgb(140, 245, 195, 82), 1f * scale)) {
                        g.DrawPath(pillPen, pillPath);
                    }
                    // Glowing indicator dot
                    float dotCX = pillX + (5.5f * scale);
                    float dotCY = pillY + (pillH / 2f);
                    float dotR = 1.6f * scale;
                    using (SolidBrush dotGlow = new SolidBrush(Color.FromArgb(80, 255, 200, 59))) {
                        g.FillEllipse(dotGlow, dotCX - (dotR * 1.8f), dotCY - (dotR * 1.8f), dotR * 3.6f, dotR * 3.6f);
                    }
                    using (SolidBrush dotBrush = new SolidBrush(Color.FromArgb(255, 255, 200, 59))) {
                        g.FillEllipse(dotBrush, dotCX - dotR, dotCY - dotR, dotR * 2, dotR * 2);
                    }
                    // Eyebrow Text
                    using (Font eyebrowFont = new Font(famSans, 4.4f * scale, FontStyle.Bold))
                    using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(255, 220, 120))) {
                        DrawSpacedString(g, "INTERNATIONAL TRADE & LOGISTICS", eyebrowFont, goldEyebrow, pillX + (10f * scale), pillY + (2.5f * scale), 0.8f * scale);
                    }

                    // Headline:
                    // Line 1: Trade Beyond Borders, (Drop shadow + Brilliant Pure White)
                    using (Font headingFont = new Font(famSerif, 18.5f * scale, FontStyle.Bold))
                    using (SolidBrush shadowBrush = new SolidBrush(Color.FromArgb(180, 5, 18, 38)))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                        g.DrawString("Trade Beyond Borders,", headingFont, shadowBrush, startX - (0.5f * scale) + (1.2f * scale), 39f * scale + (1.5f * scale));
                        g.DrawString("Trade Beyond Borders,", headingFont, whiteHeading, startX - (0.5f * scale), 39f * scale);
                    }

                    // Line 2: Built for Growth (Metallic Radiant Luxury Gold Gradient!)
                    using (Font headingFont = new Font(famSerif, 18.5f * scale, FontStyle.Bold))
                    using (LinearGradientBrush goldHeadingBrush = new LinearGradientBrush(
                        new RectangleF(startX, 66f * scale, 340f * scale, 28f * scale),
                        Color.FromArgb(255, 255, 243, 214),
                        Color.FromArgb(255, 212, 126, 6),
                        LinearGradientMode.Horizontal)) {

                        ColorBlend cbGold = new ColorBlend(4);
                        cbGold.Positions = new float[] { 0f, 0.25f, 0.65f, 1f };
                        cbGold.Colors = new Color[] {
                            Color.FromArgb(255, 255, 245, 220), // Champagne highlight
                            Color.FromArgb(255, 252, 214, 121), // Gleaming gold
                            Color.FromArgb(255, 245, 176, 39),  // Amber gold
                            Color.FromArgb(255, 212, 126, 6)   // Deep rich bronze-gold
                        };
                        goldHeadingBrush.InterpolationColors = cbGold;

                        using (SolidBrush shadowBrush = new SolidBrush(Color.FromArgb(160, 5, 18, 38))) {
                            g.DrawString("Built for Growth", headingFont, shadowBrush, startX - (0.5f * scale) + (1.2f * scale), 66f * scale + (1.5f * scale));
                        }
                        g.DrawString("Built for Growth", headingFont, goldHeadingBrush, startX - (0.5f * scale), 66f * scale);
                    }

                    // Paragraph: 2 lines with refined high contrast ice-white
                    using (Font descFont = new Font(famSans, 5.8f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(232, 242, 252))) {
                        string l1 = "CONCEPT EXIM connects businesses worldwide with seamless";
                        string l2 = "import-export solutions, reliable logistics and trusted partnerships.";
                        float lineSpacing = 8.6f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, 98f * scale);
                        g.DrawString(l2, descFont, descBrush, startX, 98f * scale + lineSpacing);
                    }

                    // Two Ultra-Premium Action Buttons
                    float btnY = 127f * scale;
                    float btnH = 23f * scale;

                    // Button 1: Explore Our Services -> (Warm Golden Amber Radiant Gradient)
                    float btn1W = 112f * scale;
                    GraphicsPath btn1Path = GetRoundedRect(new Rectangle((int)startX, (int)btnY, (int)btn1W, (int)btnH), (int)(6f * scale));
                    using (LinearGradientBrush btn1Bg = new LinearGradientBrush(
                        new Rectangle((int)startX, (int)btnY, (int)btn1W, (int)btnH),
                        Color.FromArgb(255, 255, 211, 88),
                        Color.FromArgb(255, 219, 127, 9),
                        LinearGradientMode.Vertical)) {
                        g.FillPath(btn1Bg, btn1Path);
                    }
                    // Highlight top border
                    using (Pen btn1Border = new Pen(Color.FromArgb(180, 255, 255, 255), 1.2f * scale)) {
                        g.DrawPath(btn1Border, btn1Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush btn1Text = new SolidBrush(Color.FromArgb(7, 25, 47))) {
                        string b1Str = "Explore Our Services";
                        g.DrawString(b1Str, btnFont, btn1Text, startX + (10f * scale), btnY + (6.2f * scale));
                    }
                    // Translucent dark circle badge around arrow
                    float circleCX = startX + btn1W - (12f * scale);
                    float circleCY = btnY + (btnH / 2f);
                    float circleR = 5.5f * scale;
                    using (SolidBrush circleBg = new SolidBrush(Color.FromArgb(40, 7, 25, 47))) {
                        g.FillEllipse(circleBg, circleCX - circleR, circleCY - circleR, circleR * 2, circleR * 2);
                    }
                    using (Font arrowFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush arrowBrush = new SolidBrush(Color.FromArgb(7, 25, 47))) {
                        string arrowStr = "\u2192";
                        SizeF aSize = g.MeasureString(arrowStr, arrowFont);
                        g.DrawString(arrowStr, arrowFont, arrowBrush, circleCX - (aSize.Width / 2f), circleCY - (aSize.Height / 2f) + (0.3f * scale));
                    }

                    // Button 2: Get a Custom Quote (Frosted Navy Glassmorphic)
                    float btn2X = startX + btn1W + (12f * scale);
                    float btn2W = 106f * scale;
                    GraphicsPath btn2Path = GetRoundedRect(new Rectangle((int)btn2X, (int)btnY, (int)btn2W, (int)btnH), (int)(6f * scale));
                    using (SolidBrush btn2Bg = new SolidBrush(Color.FromArgb(170, 8, 28, 56))) {
                        g.FillPath(btn2Bg, btn2Path);
                    }
                    using (Pen btn2Pen = new Pen(Color.FromArgb(190, 255, 255, 255), 1.2f * scale)) {
                        g.DrawPath(btn2Pen, btn2Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                        string b2Str = "Get a Custom Quote";
                        SizeF b2Size = g.MeasureString(b2Str, btnFont);
                        g.DrawString(b2Str, btnFont, whiteBrush, btn2X + (btn2W - b2Size.Width) / 2f, btnY + (btnH - b2Size.Height) / 2f);
                    }

                    // 7. Right Stats Card Content (4 Rows with gold circular icons)
                    float statRowH = 34f * scale;
                    float iconCX = cardX + 22f * scale;
                    float textStartX = cardX + 41f * scale;
                    float iconR = 8.5f * scale;

                    using (Font numFont = new Font(famSans, 7.8f * scale, FontStyle.Bold))
                    using (Font lblFont = new Font(famSans, 4.4f * scale, FontStyle.Regular))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush subBrush = new SolidBrush(Color.FromArgb(215, 228, 242)))
                    using (SolidBrush iconBgBrush = new SolidBrush(Color.FromArgb(40, 245, 185, 55)))
                    using (Pen iconBorderPen = new Pen(Color.FromArgb(180, 245, 185, 55), 1f * scale))
                    using (Pen iconDrawPen = new Pen(Color.FromArgb(255, 245, 185, 55), 1.3f * scale))
                    using (SolidBrush iconFillBrush = new SolidBrush(Color.FromArgb(255, 245, 185, 55)))
                    using (Pen divPen = new Pen(Color.FromArgb(50, 255, 255, 255), 0.8f * scale)) {

                        string[] nums = new string[] { "150+", "2,500+", "500+", "98%" };
                        string[] lbls = new string[] { "Countries Served", "Successful Shipments", "Global Partners", "On-Time Delivery Rate" };

                        for (int i = 0; i < 4; i++) {
                            float rowY = cardY + (10f * scale) + (i * statRowH);
                            float cy = rowY + (10f * scale);

                            g.FillEllipse(iconBgBrush, iconCX - iconR, cy - iconR, iconR * 2, iconR * 2);
                            g.DrawEllipse(iconBorderPen, iconCX - iconR, cy - iconR, iconR * 2, iconR * 2);

                            DrawGlyph(g, i, iconCX, cy, iconR * 0.58f, iconDrawPen, iconFillBrush);

                            g.DrawString(nums[i], numFont, whiteBrush, textStartX, rowY + (0.5f * scale));
                            g.DrawString(lbls[i], lblFont, subBrush, textStartX, rowY + (9.8f * scale));

                            if (i < 3) {
                                float divY = rowY + statRowH - (2f * scale);
                                g.DrawLine(divPen, cardX + (12f * scale), divY, cardX + cardW - (12f * scale), divY);
                            }
                        }
                    }

                    destBmp.Save(outPathMaster, ImageFormat.Png);
                    destBmp.Save(outPathWeb, ImageFormat.Png);
                }
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

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraSpace) {
        float currentX = x;
        foreach (char c in text) {
            string s = c.ToString();
            g.DrawString(s, font, brush, currentX, y);
            SizeF size = g.MeasureString(s, font);
            currentX += (size.Width * 0.72f) + extraSpace;
        }
    }

    private static void DrawGlyph(Graphics g, int iconIndex, float cx, float cy, float s, Pen pen, Brush brush) {
        switch (iconIndex) {
            case 0:
                g.DrawEllipse(pen, cx - s, cy - s, s * 2, s * 2);
                g.DrawLine(pen, cx - s, cy, cx + s, cy);
                g.DrawLine(pen, cx, cy - s, cx, cy + s);
                g.DrawEllipse(pen, cx - s * 0.5f, cy - s, s, s * 2);
                break;
            case 1:
                GraphicsPath hull = new GraphicsPath();
                hull.AddLine(cx - s * 0.9f, cy + s * 0.1f, cx + s * 0.9f, cy + s * 0.1f);
                hull.AddLine(cx + s * 0.9f, cy + s * 0.1f, cx + s * 0.65f, cy + s * 0.75f);
                hull.AddLine(cx + s * 0.65f, cy + s * 0.75f, cx - s * 0.65f, cy + s * 0.75f);
                hull.CloseFigure();
                g.DrawPath(pen, hull);
                g.FillRectangle(brush, cx - s * 0.7f, cy - s * 0.55f, s * 0.4f, s * 0.55f);
                g.FillRectangle(brush, cx - s * 0.2f, cy - s * 0.75f, s * 0.45f, s * 0.75f);
                g.FillRectangle(brush, cx + s * 0.35f, cy - s * 0.45f, s * 0.35f, s * 0.45f);
                break;
            case 2:
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
            case 3:
                GraphicsPath shield = new GraphicsPath();
                shield.AddLine(cx - s * 0.75f, cy - s * 0.8f, cx + s * 0.75f, cy - s * 0.8f);
                shield.AddLine(cx + s * 0.75f, cy - s * 0.8f, cx + s * 0.75f, cy + s * 0.1f);
                shield.AddBezier(cx + s * 0.75f, cy + s * 0.1f, cx + s * 0.5f, cy + s * 0.7f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                shield.AddBezier(cx, cy + s * 0.95f, cx - s * 0.5f, cy + s * 0.7f, cx - s * 0.75f, cy + s * 0.1f, cx - s * 0.75f, cy + s * 0.1f);
                shield.CloseFigure();
                g.DrawPath(pen, shield);
                using (Pen checkPen = new Pen(brush, pen.Width * 1.35f)) {
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

$photoPath = "c:\Users\Administrator\Pictures\emports and exports\public\images\concept-exim-global-trade-hero-bg-4k.png"
$outMaster = "c:\Users\Administrator\Pictures\emports and exports\images\home_hero_master_4x.png"
$outWeb = "c:\Users\Administrator\Pictures\emports and exports\images\home_hero_banner.png"

[Render4KHomeHeroV2]::GenerateBanner($photoPath, $outMaster, $outWeb, $fontSans, $fontSerif)
Write-Host "V2 Ultra-Premium Master banner generated successfully!"
