Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$fontSerif = "c:\Users\Administrator\Pictures\emports and exports\images\PlayfairDisplay.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class Render4KHomeHero {
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

                    // 2. Subtle Navy gradient on left 38%
                    int fadeEndX = (int)(targetW * 0.38f);
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

                    // 6. Left Typography
                    float startX = 56f * scale;

                    // Eyebrow: INTERNATIONAL TRADE & LOGISTICS
                    using (Font eyebrowFont = new Font(famSans, 6.8f * scale, FontStyle.Bold))
                    using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(245, 195, 82))) {
                        DrawSpacedString(g, "INTERNATIONAL TRADE & LOGISTICS", eyebrowFont, goldEyebrow, startX, 26f * scale, 1.2f * scale);
                    }

                    // Heading: Trade Beyond Borders, (Pure White) & Built for Growth (Gold)
                    using (Font headingFont = new Font(famSerif, 18.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteHeading = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush goldHeading = new SolidBrush(Color.FromArgb(245, 188, 55))) {
                        g.DrawString("Trade Beyond Borders,", headingFont, whiteHeading, startX - (0.5f * scale), 39f * scale);
                        g.DrawString("Built for Growth", headingFont, goldHeading, startX - (0.5f * scale), 66f * scale);
                    }

                    // Paragraph: 2 lines
                    using (Font descFont = new Font(famSans, 5.8f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(228, 238, 248))) {
                        string l1 = "CONCEPT EXIM connects businesses worldwide with seamless";
                        string l2 = "import-export solutions, reliable logistics and trusted partnerships.";
                        float lineSpacing = 8.6f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, 98f * scale);
                        g.DrawString(l2, descFont, descBrush, startX, 98f * scale + lineSpacing);
                    }

                    // Two Buttons
                    float btnY = 128f * scale;
                    float btnH = 22f * scale;

                    // Button 1: Explore Our Services -> (Warm Golden Amber)
                    float btn1W = 106f * scale;
                    GraphicsPath btn1Path = GetRoundedRect(new Rectangle((int)startX, (int)btnY, (int)btn1W, (int)btnH), (int)(5f * scale));
                    using (SolidBrush btn1Bg = new SolidBrush(Color.FromArgb(245, 185, 55))) {
                        g.FillPath(btn1Bg, btn1Path);
                    }
                    using (Font btnFont = new Font(famSans, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush btn1Text = new SolidBrush(Color.FromArgb(7, 25, 47))) {
                        string b1Str = "Explore Our Services  \u2192";
                        SizeF b1Size = g.MeasureString(b1Str, btnFont);
                        g.DrawString(b1Str, btnFont, btn1Text, startX + (btn1W - b1Size.Width) / 2f, btnY + (btnH - b1Size.Height) / 2f);
                    }

                    // Button 2: Get a Custom Quote
                    float btn2X = startX + btn1W + (12f * scale);
                    float btn2W = 102f * scale;
                    GraphicsPath btn2Path = GetRoundedRect(new Rectangle((int)btn2X, (int)btnY, (int)btn2W, (int)btnH), (int)(5f * scale));
                    using (SolidBrush btn2Bg = new SolidBrush(Color.FromArgb(170, 8, 28, 56))) {
                        g.FillPath(btn2Bg, btn2Path);
                    }
                    using (Pen btn2Pen = new Pen(Color.FromArgb(200, 255, 255, 255), 1.2f * scale)) {
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

[Render4KHomeHero]::GenerateBanner($photoPath, $outMaster, $outWeb, $fontSans, $fontSerif)
Write-Host "Pristine master clean home hero banner with 4K background generated successfully!"
