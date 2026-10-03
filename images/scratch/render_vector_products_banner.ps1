Add-Type -AssemblyName System.Drawing

$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class VectorProductsHeroV2 {
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

                    Font fontEyebrow   = new Font(fam, 42f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontTitleOur   = new Font(fam, 142f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontTitleGold  = new Font(fam, 142f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontDesc       = new Font(fam, 45f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontBadge      = new Font(fam, 37f, FontStyle.Bold, GraphicsUnit.Pixel);

                    // Colors exactly matched to user's uploaded banner screenshot
                    Color colNavyEyebrow = Color.FromArgb(255, 29, 53, 104);  // #1D3568 deep navy
                    Color colGoldDot     = Color.FromArgb(255, 245, 177, 8);  // #F5B108 rich amber
                    Color colNavyOur     = Color.FromArgb(255, 0, 29, 74);    // #001D4A midnight navy
                    Color colDesc        = Color.FromArgb(255, 55, 68, 86);   // #374456 deep slate charcoal (super clear)
                    Color colBadgeNavy   = Color.FromArgb(255, 29, 53, 104);  // #1D3568
                    Color colGoldRing    = Color.FromArgb(255, 248, 184, 37); // #F8B825 vibrant gold
                    Color colDivider     = Color.FromArgb(255, 214, 222, 232);// #D6DEE8 subtle divider

                    float startX = 200f; // matches X=50 at 1024

                    // =========================================================
                    // 1. EYEBROW: "PREMIUM QUALITY • GLOBAL SOURCING"
                    // =========================================================
                    float eyeY = 124f;
                    using (SolidBrush eyeBrush = new SolidBrush(colNavyEyebrow)) {
                        string part1 = "PREMIUM QUALITY";
                        g.DrawString(part1, fontEyebrow, eyeBrush, startX, eyeY);
                        SizeF sz1 = g.MeasureString(part1, fontEyebrow);

                        // Gold bullet dot
                        float dotX = startX + sz1.Width + 24f;
                        float dotY = eyeY + (sz1.Height / 2f) - 10f;
                        using (SolidBrush dotBrush = new SolidBrush(colGoldDot)) {
                            g.FillEllipse(dotBrush, dotX, dotY, 20f, 20f);
                        }

                        string part2 = "GLOBAL SOURCING";
                        g.DrawString(part2, fontEyebrow, eyeBrush, dotX + 44f, eyeY);
                    }

                    // =========================================================
                    // 2. HEADING: "Our Premium Products"
                    // =========================================================
                    float titleY = 224f;
                    string strOur = "Our ";
                    using (SolidBrush ourBrush = new SolidBrush(colNavyOur)) {
                        g.DrawString(strOur, fontTitleOur, ourBrush, startX, titleY);
                    }
                    SizeF szOur = g.MeasureString(strOur, fontTitleOur);

                    string strGold = "Premium Products";
                    float goldX = startX + szOur.Width - 28f;
                    using (LinearGradientBrush goldBrush = new LinearGradientBrush(
                        new RectangleF(goldX, titleY, 1400f, 160f),
                        Color.FromArgb(255, 248, 179, 3),
                        Color.FromArgb(255, 225, 138, 10),
                        LinearGradientMode.Vertical)) {
                        g.DrawString(strGold, fontTitleGold, goldBrush, goldX, titleY);
                    }

                    // =========================================================
                    // 3. SENTENCE (2 lines, high contrast & crystal clear)
                    // =========================================================
                    float descY = 445f;
                    float lineHeight = 66f;
                    string desc1 = "From farms to industries, we bring you the finest quality products";
                    string desc2 = "sourced globally, ensuring trust, purity and excellence in every shipment.";

                    using (SolidBrush descBrush = new SolidBrush(colDesc)) {
                        g.DrawString(desc1, fontDesc, descBrush, startX, descY);
                        g.DrawString(desc2, fontDesc, descBrush, startX, descY + lineHeight);
                    }

                    // =========================================================
                    // 4. 4 TRUST BADGES (Perfect spacing matching original 1x layout)
                    // =========================================================
                    float badgeCenterY = 705f;
                    float ringRadius = 58f;
                    float ringThick = 9f;

                    // Badge 1: Trusted Suppliers
                    float b1X = startX + ringRadius + 6f; // ~264
                    DrawBadgeCircle(g, b1X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawShieldIcon(g, b1X, badgeCenterY, colNavyEyebrow);
                    DrawBadgeText(g, "Trusted", "Suppliers", b1X + ringRadius + 26f, badgeCenterY, fontBadge, colBadgeNavy);

                    // Divider 1
                    float div1X = startX + 490f;
                    DrawDivider(g, div1X, badgeCenterY - 45f, div1X, badgeCenterY + 45f, colDivider);

                    // Badge 2: Quality Assured
                    float b2X = div1X + 54f + ringRadius; // ~602
                    DrawBadgeCircle(g, b2X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawAwardIcon(g, b2X, badgeCenterY, colNavyEyebrow);
                    DrawBadgeText(g, "Quality", "Assured", b2X + ringRadius + 26f, badgeCenterY, fontBadge, colBadgeNavy);

                    // Divider 2
                    float div2X = div1X + 460f; // ~950
                    DrawDivider(g, div2X, badgeCenterY - 45f, div2X, badgeCenterY + 45f, colDivider);

                    // Badge 3: Global Sourcing
                    float b3X = div2X + 54f + ringRadius; // ~1062
                    DrawBadgeCircle(g, b3X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawGlobeIcon(g, b3X, badgeCenterY, colNavyEyebrow);
                    DrawBadgeText(g, "Global", "Sourcing", b3X + ringRadius + 26f, badgeCenterY, fontBadge, colBadgeNavy);

                    // Divider 3
                    float div3X = div2X + 465f; // ~1415
                    DrawDivider(g, div3X, badgeCenterY - 45f, div3X, badgeCenterY + 45f, colDivider);

                    // Badge 4: On-Time Delivery
                    float b4X = div3X + 54f + ringRadius; // ~1527
                    DrawBadgeCircle(g, b4X, badgeCenterY, ringRadius, ringThick, colGoldRing);
                    DrawTruckIcon(g, b4X, badgeCenterY, colNavyEyebrow);
                    DrawBadgeText(g, "On-Time", "Delivery", b4X + ringRadius + 26f, badgeCenterY, fontBadge, colBadgeNavy);
                }

                dest.Save(outPath, ImageFormat.Png);
            }
        }
    }

    private static void DrawBadgeCircle(Graphics g, float cx, float cy, float r, float thickness, Color ringColor) {
        float x = cx - r;
        float y = cy - r;
        float d = r * 2f;
        // White backing fill
        using (SolidBrush fill = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
            g.FillEllipse(fill, x, y, d, d);
        }
        // Gold ring border
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
            float y1 = cy - 44f;
            float y2 = cy + 2f;
            g.DrawString(line1, font, brush, tx, y1);
            g.DrawString(line2, font, brush, tx, y2);
        }
    }

    // Vector Icon 1: Shield with Checkmark
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

            // Checkmark inside shield
            using (Pen checkPen = new Pen(c, 6f)) {
                checkPen.StartCap = LineCap.Round;
                checkPen.EndCap = LineCap.Round;
                g.DrawLine(checkPen, cx - 12f, cy + 4f, cx - 3f, cy + 14f);
                g.DrawLine(checkPen, cx - 3f, cy + 14f, cx + 14f, cy - 6f);
            }
        }
    }

    // Vector Icon 2: Rosette Award Ribbon
    private static void DrawAwardIcon(Graphics g, float cx, float cy, Color c) {
        float r = 24f;
        float centerCy = cy - 8f;
        using (Pen pen = new Pen(c, 5.5f)) {
            g.DrawEllipse(pen, cx - r, centerCy - r, r * 2f, r * 2f);

            // Inner circle
            g.DrawEllipse(pen, cx - 14f, centerCy - 14f, 28f, 28f);

            // Ribbon tails
            using (Pen ribbonPen = new Pen(c, 5.5f)) {
                ribbonPen.StartCap = LineCap.Round;
                ribbonPen.EndCap = LineCap.Round;
                g.DrawLine(ribbonPen, cx - 10f, centerCy + r - 4f, cx - 18f, centerCy + r + 26f);
                g.DrawLine(ribbonPen, cx - 18f, centerCy + r + 26f, cx - 10f, centerCy + r + 20f);
                g.DrawLine(ribbonPen, cx - 10f, centerCy + r + 20f, cx - 2f, centerCy + r + 25f);

                g.DrawLine(ribbonPen, cx + 10f, centerCy + r - 4f, cx + 18f, centerCy + r + 26f);
                g.DrawLine(ribbonPen, cx + 18f, centerCy + r + 26f, cx + 10f, centerCy + r + 20f);
                g.DrawLine(ribbonPen, cx + 10f, centerCy + r + 20f, cx + 2f, centerCy + r + 25f);
            }
        }
    }

    // Vector Icon 3: Globe with Grid Lines
    private static void DrawGlobeIcon(Graphics g, float cx, float cy, Color c) {
        float r = 26f;
        using (Pen pen = new Pen(c, 5.5f)) {
            // Outer circle
            g.DrawEllipse(pen, cx - r, cy - r, r * 2f, r * 2f);
            // Equator horizontal line
            g.DrawLine(pen, cx - r + 1f, cy, cx + r - 1f, cy);
            // Vertical meridian ellipse
            g.DrawEllipse(pen, cx - 12f, cy - r, 24f, r * 2f);
            // Prime vertical meridian
            g.DrawLine(pen, cx, cy - r + 1f, cx, cy + r - 1f);
        }
    }

    // Vector Icon 4: Cargo Delivery Truck
    private static void DrawTruckIcon(Graphics g, float cx, float cy, Color c) {
        using (Pen pen = new Pen(c, 5.5f)) {
            pen.LineJoin = LineJoin.Round;
            // Cargo box
            float boxLeft = cx - 28f;
            float boxTop = cy - 20f;
            float boxW = 34f;
            float boxH = 30f;
            g.DrawRectangle(pen, boxLeft, boxTop, boxW, boxH);

            // Cabin
            using (GraphicsPath cabin = new GraphicsPath()) {
                cabin.AddLine(boxLeft + boxW, cy - 8f, boxLeft + boxW + 20f, cy - 8f);
                cabin.AddLine(boxLeft + boxW + 20f, cy - 8f, boxLeft + boxW + 26f, cy + 2f);
                cabin.AddLine(boxLeft + boxW + 26f, cy + 2f, boxLeft + boxW + 26f, cy + 10f);
                cabin.AddLine(boxLeft + boxW + 26f, cy + 10f, boxLeft + boxW, cy + 10f);
                g.DrawPath(pen, cabin);
            }

            // Wheels
            using (SolidBrush wheelBrush = new SolidBrush(c)) {
                g.FillEllipse(wheelBrush, boxLeft + 6f, cy + 8f, 14f, 14f);
                g.FillEllipse(wheelBrush, boxLeft + boxW + 8f, cy + 8f, 14f, 14f);
            }
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies "System.Drawing"

$cleanBg = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_4k.png"
$outMaster = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_vector_products_banner_4k.png"

[VectorProductsHeroV2]::RenderMaster($cleanBg, $outMaster, $fontSansPath)
Write-Host "Vector Products 4K Banner V2 rendered successfully!"

# Also save a 1200px preview artifact
$previewOut = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_products_banner_preview_v2.png"
$bmp4k = [System.Drawing.Bitmap]::FromFile($outMaster)
$prevBmp = New-Object System.Drawing.Bitmap(1200, 400)
$prevG = [System.Drawing.Graphics]::FromImage($prevBmp)
$prevG.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$prevG.DrawImage($bmp4k, 0, 0, 1200, 400)
$prevBmp.Save($previewOut, [System.Drawing.Imaging.ImageFormat]::Png)
$prevG.Dispose()
$prevBmp.Dispose()
$bmp4k.Dispose()
Write-Host "Preview artifact V2 saved: $previewOut"
