Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ComplianceBannerDeployer {
    public static void Deploy(string srcPath, string fontPath, string outPng1, string outPng2, string outJpg1, string outJpg2, string previewPath, int scale) {
        using (Bitmap rawSrc = new Bitmap(srcPath)) {
            int targetW = rawSrc.Width * scale;  // 4096
            int targetH = rawSrc.Height * scale; // 1364

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled base banner
                    g.DrawImage(rawSrc, 0, 0, targetW, targetH);

                    // 2. Clean out old paragraph text with pure white fill
                    // In 1x scale: x: 23 to 442, y: 167 to 226
                    int patchX = (int)(23f * scale);
                    int patchY = (int)(167f * scale);
                    int patchW = (int)(422f * scale);
                    int patchH = (int)(60f * scale);

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillRectangle(whiteBrush, patchX, patchY, patchW, patchH);
                    }

                    // 3. Load Plus Jakarta Sans font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    float fontSize = 9.35f * scale; // approx 37.4pt in 4K
                    float lineSpacing = 13.25f * scale; // approx 53px in 4K
                    float startX = 24.5f * scale;
                    float startY = 168.5f * scale;

                    using (Font fontReg = new Font(fam, fontSize, FontStyle.Regular, GraphicsUnit.Pixel))
                    using (Font fontBold = new Font(fam, fontSize, FontStyle.Bold, GraphicsUnit.Pixel))
                    using (SolidBrush textDark = new SolidBrush(Color.FromArgb(255, 15, 41, 74)))   // Deep Navy #0f294a (for bold brand & terms)
                    using (SolidBrush textSlate = new SolidBrush(Color.FromArgb(255, 51, 65, 85)))  // Rich Slate #334155 (crisp, high-contrast)
                    {
                        // Line 1: At CONCEPT EXIM, we ensure that every product meets the highest international
                        float curX = startX;
                        float curY = startY;

                        DrawWord(g, "At ", fontReg, textSlate, ref curX, curY);
                        DrawWord(g, "Concept Exim, ", fontBold, textDark, ref curX, curY);
                        DrawWord(g, "we ensure that every product meets the highest international", fontReg, textSlate, ref curX, curY);

                        // Line 2: quality standards and complies with global regulations. Our commitment to
                        curX = startX;
                        curY += lineSpacing;
                        DrawWord(g, "quality ", fontReg, textSlate, ref curX, curY);
                        DrawWord(g, "standards ", fontBold, textDark, ref curX, curY);
                        DrawWord(g, "and ", fontReg, textSlate, ref curX, curY);
                        DrawWord(g, "complies ", fontBold, textDark, ref curX, curY);
                        DrawWord(g, "with ", fontReg, textSlate, ref curX, curY);
                        DrawWord(g, "global regulations. ", fontBold, textDark, ref curX, curY);
                        DrawWord(g, "Our commitment to", fontReg, textSlate, ref curX, curY);

                        // Line 3: quality, safety, and transparency builds trust with our clients, partners, and
                        curX = startX;
                        curY += lineSpacing;
                        DrawWord(g, "quality, safety, ", fontBold, textDark, ref curX, curY);
                        DrawWord(g, "and transparency builds trust with our clients, partners, and", fontReg, textSlate, ref curX, curY);

                        // Line 4: communities worldwide.
                        curX = startX;
                        curY += lineSpacing;
                        DrawWord(g, "communities worldwide.", fontReg, textSlate, ref curX, curY);
                    }
                }

                // Save PNGs
                destBmp.Save(outPng1, ImageFormat.Png);
                destBmp.Save(outPng2, ImageFormat.Png);

                // Save JPEGs
                ImageCodecInfo jpegCodec = null;
                foreach (ImageCodecInfo codec in ImageCodecInfo.GetImageEncoders()) {
                    if (codec.MimeType == "image/jpeg") { jpegCodec = codec; break; }
                }
                if (jpegCodec != null) {
                    EncoderParameters ep = new EncoderParameters(1);
                    ep.Param[0] = new EncoderParameter(Encoder.Quality, 96L);
                    destBmp.Save(outJpg1, jpegCodec, ep);
                    destBmp.Save(outJpg2, jpegCodec, ep);
                }

                // Save preview (1200px)
                int prevW = 1200;
                int prevH = (int)(targetH * ((float)prevW / targetW));
                using (Bitmap prev = new Bitmap(prevW, prevH)) {
                    using (Graphics pg = Graphics.FromImage(prev)) {
                        pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        pg.DrawImage(destBmp, 0, 0, prevW, prevH);
                    }
                    prev.Save(previewPath, ImageFormat.Png);
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

$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.png"
$outJpg1 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.jpg"
$outJpg2 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.jpg"
$previewPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\new_compliance_user_banner_preview.png"

[ComplianceBannerDeployer]::Deploy($src, $fontSansPath, $outPng1, $outPng2, $outJpg1, $outJpg2, $previewPath, 4)
Write-Host "Quality and Compliance hero banner deployed successfully!"
