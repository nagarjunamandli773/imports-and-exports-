Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class TestContactDeployer {
    public static void RenderTest(string srcPath, string fontPath, string outTestPath, string outPrevPath) {
        int scale = 4;
        using (Bitmap rawSrc = new Bitmap(srcPath)) {
            int targetW = rawSrc.Width * scale;  // 4096
            int targetH = rawSrc.Height * scale; // 1364

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled base image
                    g.DrawImage(rawSrc, 0, 0, targetW, targetH);

                    // Load Plus Jakarta Sans font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    // 2. Clean out old paragraph text
                    // x: 30 to 425, y: 165 to 210 in 1x scale
                    int pX = (int)(32f * scale);
                    int pY = (int)(166f * scale);
                    int pW = (int)(395f * scale);
                    int pH = (int)(46f * scale);

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillRectangle(whiteBrush, pX, pY, pW, pH);
                    }

                    // 3. Render Crisp Paragraph Text
                    float paraFontSize = 9.8f * scale; // ~39.2px
                    float lineSpacing = 14.5f * scale;  // ~58px
                    float startX = 35.5f * scale;
                    float startY = 169.5f * scale;

                    using (Font fontReg = new Font(fam, paraFontSize, FontStyle.Regular, GraphicsUnit.Pixel))
                    using (Font fontBold = new Font(fam, paraFontSize, FontStyle.Bold, GraphicsUnit.Pixel))
                    using (SolidBrush textNavy = new SolidBrush(Color.FromArgb(255, 7, 25, 47)))      // Brand Deep Navy #07192f
                    using (SolidBrush textSlate = new SolidBrush(Color.FromArgb(255, 51, 65, 85)))     // Rich Crisp Slate #334155
                    {
                        // Line 1: Have a question, need support, or want to explore a partnership?
                        float curX = startX;
                        float curY = startY;
                        DrawWord(g, "Have a question, need support, or want to explore a partnership?", fontReg, textSlate, ref curX, curY);

                        // Line 2: Our team at Concept Exim is always ready to assist you. Reach out to us —
                        curX = startX;
                        curY += lineSpacing;
                        DrawWord(g, "Our team at ", fontReg, textSlate, ref curX, curY);
                        DrawWord(g, "Concept Exim ", fontBold, textNavy, ref curX, curY);
                        DrawWord(g, "is always ready to assist you. Reach out to us —", fontReg, textSlate, ref curX, curY);

                        // Line 3: your global trade journey matters to us.
                        curX = startX;
                        curY += lineSpacing;
                        DrawWord(g, "your global trade journey matters to us.", fontReg, textSlate, ref curX, curY);
                    }

                    // 4. Clean and re-render the 4 Badges text
                    // In 1x scale, badge text is from y: 264 to 300
                    int bTextX = (int)(20f * scale);
                    int bTextY = (int)(263f * scale);
                    int bTextW = (int)(425f * scale);
                    int bTextH = (int)(40f * scale);

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillRectangle(whiteBrush, bTextX, bTextY, bTextW, bTextH);
                    }

                    // Badge text fonts
                    float titleFontSize = 9.8f * scale; // ~39.2px
                    float subFontSize = 8.2f * scale;   // ~32.8px
                    using (Font fontTitle = new Font(fam, titleFontSize, FontStyle.Bold, GraphicsUnit.Pixel))
                    using (Font fontSub = new Font(fam, subFontSize, FontStyle.Regular, GraphicsUnit.Pixel))
                    using (SolidBrush textTitle = new SolidBrush(Color.FromArgb(255, 7, 25, 47)))     // Deep Navy #07192f
                    using (SolidBrush textSub = new SolidBrush(Color.FromArgb(255, 71, 85, 105)))     // Slate #475569
                    {
                        StringFormat sfCenter = new StringFormat();
                        sfCenter.Alignment = StringAlignment.Center;
                        sfCenter.LineAlignment = StringAlignment.Near;

                        // Badge 1: Center = 71 * scale
                        float b1Center = 71f * scale;
                        g.DrawString("Quick Response", fontTitle, textTitle, new PointF(b1Center, 267f * scale), sfCenter);
                        g.DrawString("We reply within\n24 hours", fontSub, textSub, new PointF(b1Center, 281.5f * scale), sfCenter);

                        // Badge 2: Center = 175.5 * scale
                        float b2Center = 175.5f * scale;
                        g.DrawString("Dedicated Support", fontTitle, textTitle, new PointF(b2Center, 267f * scale), sfCenter);
                        g.DrawString("From our expert team", fontSub, textSub, new PointF(b2Center, 283.5f * scale), sfCenter);

                        // Badge 3: Center = 281 * scale
                        float b3Center = 281f * scale;
                        g.DrawString("Global Reach", fontTitle, textTitle, new PointF(b3Center, 267f * scale), sfCenter);
                        g.DrawString("Across 50+ countries", fontSub, textSub, new PointF(b3Center, 283.5f * scale), sfCenter);

                        // Badge 4: Center = 387 * scale
                        float b4Center = 387f * scale;
                        g.DrawString("Trusted Partner", fontTitle, textTitle, new PointF(b4Center, 267f * scale), sfCenter);
                        g.DrawString("For your business growth", fontSub, textSub, new PointF(b4Center, 283.5f * scale), sfCenter);
                    }
                }

                // Save full test
                destBmp.Save(outTestPath, ImageFormat.Png);

                // Save preview (1600px)
                int prevW = 1600;
                int prevH = (int)(targetH * ((float)prevW / targetW));
                using (Bitmap prev = new Bitmap(prevW, prevH)) {
                    using (Graphics pg = Graphics.FromImage(prev)) {
                        pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        pg.DrawImage(destBmp, 0, 0, prevW, prevH);
                    }
                    prev.Save(outPrevPath, ImageFormat.Png);
                }
            }
        }
    }

    private static void DrawWord(Graphics g, string text, Font font, Brush brush, ref float curX, float y) {
        StringFormat sf = StringFormat.GenericTypographic;
        sf.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces | StringFormatFlags.NoWrap;
        g.DrawString(text, font, brush, curX, y, sf);
        SizeF sz = g.MeasureString(text, font, new PointF(curX, y), sf);
        curX += sz.Width;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$outTest = "images\scratch\test_contact_4k.png"
$outPrev = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\test_contact_preview.png"

[TestContactDeployer]::RenderTest($src, $fontSansPath, $outTest, $outPrev)
Write-Host "Test render completed successfully!"
