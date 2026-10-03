Add-Type -AssemblyName System.Drawing

$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class VectorServicesHero {
    public static void RenderMaster(string cleanBgPath, string outPath, string fontSansPath) {
        using (Bitmap bg = new Bitmap(cleanBgPath)) {
            int w = bg.Width;   // 4096
            int h = bg.Height;  // 1364

            using (Bitmap dest = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(dest)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw clean base background
                    g.DrawImage(bg, 0, 0, w, h);

                    // 2. Load TrueType Fonts
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontSansPath) && System.IO.File.Exists(fontSansPath)) {
                        pfc.AddFontFile(fontSansPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    Font fontEyebrow  = new Font(fam, 40f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontHeading  = new Font(fam, 126f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontDesc     = new Font(fam, 39f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontBadge    = new Font(fam, 36f, FontStyle.Bold, GraphicsUnit.Pixel);

                    // Colors
                    Color colGoldEyebrow = Color.FromArgb(255, 230, 142, 18);  // #E68E12
                    Color colNavyHead    = Color.FromArgb(255, 0, 29, 74);     // #001D4A
                    Color colGoldHead    = Color.FromArgb(255, 245, 175, 5);   // #F5AF05
                    Color colDesc        = Color.FromArgb(255, 55, 68, 86);    // #374456 deep slate charcoal (super clear)
                    Color colBadgeNavy   = Color.FromArgb(255, 29, 53, 104);   // #1D3568
                    Color colGoldRing    = Color.FromArgb(255, 248, 184, 37);  // #F8B825
                    Color colDivider     = Color.FromArgb(255, 214, 222, 232); // #D6DEE8

                    float startX = 200f; // matches X=50 at 1024

                    // =========================================================
                    // 1. EYEBROW: "OUR SERVICES"
                    // =========================================================
                    float eyeY = 320f;
                    using (SolidBrush eyeBrush = new SolidBrush(colGoldEyebrow)) {
                        g.DrawString("OUR SERVICES", fontEyebrow, eyeBrush, startX, eyeY);
                    }

                    // =========================================================
                    // 2. HEADING: "End-to-End Trade" / "Solutions"
                    // =========================================================
                    float title1Y = 385f;
                    using (SolidBrush headBrush = new SolidBrush(colNavyHead)) {
                        g.DrawString("End-to-End Trade", fontHeading, headBrush, startX, title1Y);
                    }

                    float title2Y = 525f;
                    using (LinearGradientBrush goldBrush = new LinearGradientBrush(
                        new RectangleF(startX, title2Y, 700f, 150f),
                        colGoldHead,
                        Color.FromArgb(255, 225, 138, 10),
                        LinearGradientMode.Vertical)) {
                        g.DrawString("Solutions", fontHeading, goldBrush, startX, title2Y);
                    }

                    // =========================================================
                    // 3. SENTENCE (3 lines, bold & high-contrast)
                    // =========================================================
                    float descY = 690f;
                    float lineH = 56f;
                    string desc1 = "From sourcing to delivery, we handle the complexities";
                    string desc2 = "so you can focus on growth. Our comprehensive services";
                    string desc3 = "ensure seamless, secure and efficient global trade.";

                    using (SolidBrush descBrush = new SolidBrush(colDesc)) {
                        g.DrawString(desc1, fontDesc, descBrush, startX, descY);
                        g.DrawString(desc2, fontDesc, descBrush, startX, descY + lineH);
                        g.DrawString(desc3, fontDesc, descBrush, startX, descY + lineH * 2f);
                    }

                    // =========================================================
                    // 4. 4 TRUST BADGES
                    // =========================================================
                    float badgeCenterY = 930f;
                    float ringRadius = 56f;
                    float ringThick = 9f;

                    // Badge 1: Global Network
                    float b1X = startX + ringRadius + 6f; // ~262
                    DrawBadgeCircle(g, b1X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawGlobeIcon(g, b1X, badgeCenterY, colBadgeNavy);
                    DrawBadgeText(g, "Global", "Network", b1X + ringRadius + 24f, badgeCenterY, fontBadge, colBadgeNavy);

                    // Divider 1
                    float div1X = startX + 475f;
                    DrawDivider(g, div1X, badgeCenterY - 42f, div1X, badgeCenterY + 42f, colDivider);

                    // Badge 2: Expert Support
                    float b2X = div1X + 54f + ringRadius;
                    DrawBadgeCircle(g, b2X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawPeopleIcon(g, b2X, badgeCenterY, colBadgeNavy);
                    DrawBadgeText(g, "Expert", "Support", b2X + ringRadius + 24f, badgeCenterY, fontBadge, colBadgeNavy);

                    // Divider 2
                    float div2X = div1X + 445f;
                    DrawDivider(g, div2X, badgeCenterY - 42f, div2X, badgeCenterY + 42f, colDivider);

                    // Badge 3: Secure & Reliable
                    float b3X = div2X + 54f + ringRadius;
                    DrawBadgeCircle(g, b3X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawShieldIcon(g, b3X, badgeCenterY, colBadgeNavy);
                    DrawBadgeText(g, "Secure", "& Reliable", b3X + ringRadius + 24f, badgeCenterY, fontBadge, colBadgeNavy);

                    // Divider 3
                    float div3X = div2X + 475f;
                    DrawDivider(g, div3X, badgeCenterY - 42f, div3X, badgeCenterY + 42f, colDivider);

                    // Badge 4: On-Time Delivery
                    float b4X = div3X + 54f + ringRadius;
                    DrawBadgeCircle(g, b4X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawClockDeliveryIcon(g, b4X, badgeCenterY, colBadgeNavy);
                    DrawBadgeText(g, "On-Time", "Delivery", b4X + ringRadius + 24f, badgeCenterY, fontBadge, colBadgeNavy);
                }

                dest.Save(outPath, ImageFormat.Png);
            }
        }
    }

    private static void DrawBadgeCircle(Graphics g, float cx, float cy, float r, float thickness, Color ringColor) {
        float x = cx - r;
        float y = cy - r;
        float d = r * 2f;
        using (SolidBrush fill = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
            g.FillEllipse(fill, x, y, d, d);
        }
        using (Pen p = new Pen(ringColor, thickness)) {
            g.DrawEllipse(p, x + thickness / 2f, y + thickness / 2f, d - thickness, d - thickness);
        }
    }

    private static void DrawDivider(Graphics g, float x1, float y1, float x2, float y2, Color c) {
        using (Pen p = new Pen(c, 3.5f)) {
            g.DrawLine(p, x1, y1, x2, y2);
        }
    }

    private static void DrawBadgeText(Graphics g, string line1, string line2, float tx, float cy, Font font, Color c) {
        using (SolidBrush brush = new SolidBrush(c)) {
            float y1 = cy - 42f;
            float y2 = cy + 2f;
            g.DrawString(line1, font, brush, tx, y1);
            g.DrawString(line2, font, brush, tx, y2);
        }
    }

    private static void DrawGlobeIcon(Graphics g, float cx, float cy, Color c) {
        float r = 26f;
        using (Pen pen = new Pen(c, 5.5f)) {
            g.DrawEllipse(pen, cx - r, cy - r, r * 2f, r * 2f);
            g.DrawLine(pen, cx - r + 1f, cy, cx + r - 1f, cy);
            g.DrawEllipse(pen, cx - 12f, cy - r, 24f, r * 2f);
            g.DrawLine(pen, cx, cy - r + 1f, cx, cy + r - 1f);
        }
    }

    private static void DrawPeopleIcon(Graphics g, float cx, float cy, Color c) {
        using (Pen pen = new Pen(c, 5.5f))
        using (SolidBrush brush = new SolidBrush(c)) {
            // Center person head
            g.DrawEllipse(pen, cx - 10f, cy - 22f, 20f, 20f);
            // Center person body arch
            g.DrawArc(pen, cx - 18f, cy - 2f, 36f, 32f, 190, 160);

            // Left person head
            g.FillEllipse(brush, cx - 22f, cy - 14f, 12f, 12f);
            // Left person shoulder
            g.DrawArc(pen, cx - 28f, cy + 2f, 20f, 22f, 180, 120);

            // Right person head
            g.FillEllipse(brush, cx + 10f, cy - 14f, 12f, 12f);
            // Right person shoulder
            g.DrawArc(pen, cx + 8f, cy + 2f, 20f, 22f, 240, 120);
        }
    }

    private static void DrawShieldIcon(Graphics g, float cx, float cy, Color c) {
        using (GraphicsPath path = new GraphicsPath()) {
            float w = 26f;
            float topY = cy - 20f;
            path.AddLine(cx - w, topY, cx + w, topY);
            path.AddLine(cx + w, topY, cx + w, topY + 16f);
            path.AddBezier(cx + w, topY + 16f, cx + w, topY + 32f, cx + 12f, topY + 44f, cx, topY + 50f);
            path.AddBezier(cx, topY + 50f, cx - 12f, topY + 44f, cx - w, topY + 32f, cx - w, topY + 16f);
            path.CloseFigure();

            using (Pen pen = new Pen(c, 5.5f)) {
                pen.LineJoin = LineJoin.Round;
                g.DrawPath(pen, path);
            }

            using (Pen checkPen = new Pen(c, 6f)) {
                checkPen.StartCap = LineCap.Round;
                checkPen.EndCap = LineCap.Round;
                g.DrawLine(checkPen, cx - 12f, cy + 4f, cx - 3f, cy + 14f);
                g.DrawLine(checkPen, cx - 3f, cy + 14f, cx + 14f, cy - 6f);
            }
        }
    }

    private static void DrawClockDeliveryIcon(Graphics g, float cx, float cy, Color c) {
        float r = 26f;
        using (Pen pen = new Pen(c, 5.5f)) {
            g.DrawEllipse(pen, cx - r, cy - r, r * 2f, r * 2f);
            // Clock hands
            pen.StartCap = LineCap.Round;
            pen.EndCap = LineCap.Round;
            g.DrawLine(pen, cx, cy, cx, cy - 14f);
            g.DrawLine(pen, cx, cy, cx + 11f, cy + 4f);
            // Check accent notch
            g.DrawLine(pen, cx - 7f, cy - 24f, cx - 15f, cy - 30f);
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies "System.Drawing"

$cleanBg = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_4k.png"
$outMaster = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_vector_services_banner_4k.png"

[VectorServicesHero]::RenderMaster($cleanBg, $outMaster, $fontSansPath)
Write-Host "Services 4K Vector Banner rendered successfully!"

# Also save preview artifact
$previewOut = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_services_banner_preview.png"
$bmp4k = [System.Drawing.Bitmap]::FromFile($outMaster)
$prevBmp = New-Object System.Drawing.Bitmap(1200, 400)
$prevG = [System.Drawing.Graphics]::FromImage($prevBmp)
$prevG.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$prevG.DrawImage($bmp4k, 0, 0, 1200, 400)
$prevBmp.Save($previewOut, [System.Drawing.Imaging.ImageFormat]::Png)
$prevG.Dispose()
$prevBmp.Dispose()
$bmp4k.Dispose()
Write-Host "Services preview artifact saved: $previewOut"
