Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790503971818.png"
if (-not (Test-Path $src)) {
    $src = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png"
}
$fontPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class InsightsRefiner {
    public static void Refine(string srcPath, string fontPath, string outPng1, string outPng2, string previewPath) {
        using (Bitmap rawSrc = new Bitmap(srcPath)) {
            int targetW = 4096;
            int targetH = 1364;

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw base banner
                    g.DrawImage(rawSrc, 0, 0, targetW, targetH);

                    // 2. Clean out old paragraph text with pure white fill
                    // In 4K: X: 90 to 1800, Y: 700 to 880
                    int patchX = 90;
                    int patchY = 700;
                    int patchW = 1720;
                    int patchH = 180;

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillRectangle(whiteBrush, patchX, patchY, patchW, patchH);
                    }

                    // 3. Load font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    Font fontBold = new Font(fam, 43f, FontStyle.Bold, GraphicsUnit.Pixel);
                    float lineSpacing = 64f;
                    float startX = 100f;
                    float startY = 718f;

                    using (SolidBrush textSlate = new SolidBrush(Color.FromArgb(255, 45, 58, 76))) { // #2D3A4C crisp slate
                        string l1 = "Stay ahead with the latest market trends, industry updates, trade insights and expert";
                        string l2 = "analysis. At Concept Exim, we turn information into opportunities for your global success.";

                        g.DrawString(l1, fontBold, textSlate, startX, startY);
                        g.DrawString(l2, fontBold, textSlate, startX, startY + lineSpacing);
                    }
                }

                destBmp.Save(outPng1, ImageFormat.Png);
                destBmp.Save(outPng2, ImageFormat.Png);

                // Save preview
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
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies "System.Drawing"

$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\insights_hero_banner.png"
$preview = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_insights_banner_preview.png"

[InsightsRefiner]::Refine($src, $fontPath, $outPng1, $outPng2, $preview)
Write-Host "Insights banner refined with bold, clear text!"

# Update JPG fallbacks
Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile($outPng1)
$ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$b.Save("c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.jpg", $codec, $ep)
$b.Save("c:\Users\Administrator\Pictures\emports and exports\images\insights_hero_banner.jpg", $codec, $ep)
$b.Dispose()
Write-Host "Insights JPEG fallbacks updated!"
