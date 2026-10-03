Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790503971818.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class InsightsBannerDeployer {
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
                    // In 1x scale: x: 23 to 455, y: 178 to 216
                    int patchX = (int)(23f * scale);
                    int patchY = (int)(178f * scale);
                    int patchW = (int)(435f * scale);
                    int patchH = (int)(40f * scale);

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillRectangle(whiteBrush, patchX, patchY, patchW, patchH);
                    }

                    // 3. Load Plus Jakarta Sans font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    float fontSize = 9.4f * scale; // approx 37.6pt in 4K
                    float lineSpacing = 14.0f * scale; // approx 56px in 4K
                    float startX = 24.5f * scale;
                    float startY = 179.5f * scale;

                    using (Font fontReg = new Font(fam, fontSize, FontStyle.Regular, GraphicsUnit.Pixel))
                    using (Font fontBold = new Font(fam, fontSize, FontStyle.Bold, GraphicsUnit.Pixel))
                    using (SolidBrush textDark = new SolidBrush(Color.FromArgb(255, 15, 41, 74)))   // Deep Navy #0f294a
                    using (SolidBrush textSlate = new SolidBrush(Color.FromArgb(255, 51, 65, 85)))  // Slate #334155
                    {
                        // Line 1: Stay ahead with the latest market trends, industry updates, trade insights and expert
                        float curX = startX;
                        float curY = startY;
                        DrawWord(g, "Stay ahead with the latest market trends, industry updates, trade insights and expert", fontReg, textSlate, ref curX, curY);

                        // Line 2: analysis. At Concept Exim, we turn information into opportunities for your global success.
                        curX = startX;
                        curY += lineSpacing;
                        DrawWord(g, "analysis. At ", fontReg, textSlate, ref curX, curY);
                        DrawWord(g, "Concept Exim, ", fontBold, textDark, ref curX, curY);
                        DrawWord(g, "we turn information into opportunities for your global success.", fontReg, textSlate, ref curX, curY);
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

$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\insights_hero_banner.png"
$outJpg1 = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.jpg"
$outJpg2 = "c:\Users\Administrator\Pictures\emports and exports\images\insights_hero_banner.jpg"
$previewPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\new_insights_user_banner_preview.png"

[InsightsBannerDeployer]::Deploy($src, $fontSansPath, $outPng1, $outPng2, $outJpg1, $outJpg2, $previewPath, 4)
Write-Host "Market Intelligence & Insights hero banner deployed successfully!"
