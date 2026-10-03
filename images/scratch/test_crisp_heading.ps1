Add-Type -AssemblyName System.Drawing

$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class HeadingTester {
    public static void RenderCrispHeading(string fontPath, string outPath) {
        int w = 1400;
        int h = 340;
        using (Bitmap bmp = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
            using (Graphics g = Graphics.FromImage(bmp)) {
                g.Clear(Color.White);
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                PrivateFontCollection pfc = new PrivateFontCollection();
                if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                    pfc.AddFontFile(fontPath);
                }
                FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                // Font size for heading: in 1x scale it was ~33-34px. At 4x it's ~136px.
                float headingSize = 132f;
                using (Font fontHeading = new Font(fam, headingSize, FontStyle.Bold, GraphicsUnit.Pixel))
                using (SolidBrush navyBrush = new SolidBrush(Color.FromArgb(255, 7, 37, 78)))     // Deep Navy #07254e
                using (SolidBrush goldBrush = new SolidBrush(Color.FromArgb(255, 235, 155, 22)))   // Golden Amber #eb9b16
                {
                    StringFormat sf = StringFormat.GenericTypographic;
                    sf.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces | StringFormatFlags.NoWrap;

                    // Line 1: We're Here to
                    g.DrawString("We're Here to", fontHeading, navyBrush, new PointF(25f, 20f), sf);

                    // Line 2: Connect With You
                    g.DrawString("Connect With You", fontHeading, goldBrush, new PointF(25f, 168f), sf);
                }
            }
            bmp.Save(outPath, ImageFormat.Png);
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing
[HeadingTester]::RenderCrispHeading($fontSansPath, "images\scratch\heading_crisp.png")
Write-Host "Saved heading_crisp.png"
