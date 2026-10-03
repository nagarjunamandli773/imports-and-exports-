Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
if (-not (Test-Path $src)) {
    $src = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
}
$fontPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ComplianceRefinerV2 {
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
                    int patchX = 90;
                    int patchY = 660;
                    int patchW = 1720;
                    int patchH = 265;

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillRectangle(whiteBrush, patchX, patchY, patchW, patchH);
                    }

                    // 3. Load font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    Font fontBold = new Font(fam, 42f, FontStyle.Bold, GraphicsUnit.Pixel);
                    float lineSpacing = 60f;
                    float startX = 100f;
                    float startY = 675f;

                    using (SolidBrush textSlate = new SolidBrush(Color.FromArgb(255, 45, 58, 76))) { // #2D3A4C crisp slate
                        string l1 = "At Concept Exim, we ensure that every product meets the highest international";
                        string l2 = "quality standards and complies with global regulations. Our commitment to";
                        string l3 = "quality, safety, and transparency builds trust with our clients, partners, and";
                        string l4 = "communities worldwide.";

                        g.DrawString(l1, fontBold, textSlate, startX, startY);
                        g.DrawString(l2, fontBold, textSlate, startX, startY + lineSpacing);
                        g.DrawString(l3, fontBold, textSlate, startX, startY + lineSpacing * 2f);
                        g.DrawString(l4, fontBold, textSlate, startX, startY + lineSpacing * 3f);
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

$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.png"
$preview = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_compliance_banner_preview.png"

[ComplianceRefinerV2]::Refine($src, $fontPath, $outPng1, $outPng2, $preview)
Write-Host "Compliance banner V2 refined successfully!"
