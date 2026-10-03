Add-Type -AssemblyName System.Drawing

$cleanBgPath = "c:\Users\Administrator\Pictures\emports and exports\images\scratch\test_clean_compliance_perfect_v3.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$testOutPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\test_compliance_4k_vector.png"
$testPreviewPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_compliance_banner_preview.png"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class VectorComplianceHeroV2 {
    public static void RenderMaster(string cleanBgPath, string outPath, string previewPath, string fontSansPath) {
        using (Bitmap bg1x = new Bitmap(cleanBgPath)) {
            int targetW = 4096;
            int targetH = 1364;

            using (Bitmap dest = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(dest)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled clean background
                    g.DrawImage(bg1x, 0, 0, targetW, targetH);

                    // 2. Load Fonts
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontSansPath) && System.IO.File.Exists(fontSansPath)) {
                        pfc.AddFontFile(fontSansPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    Font fontEyebrow = new Font(fam, 37f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontHeading = new Font(fam, 134f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontDesc    = new Font(fam, 43f, FontStyle.Bold, GraphicsUnit.Pixel);
                    Font fontBadge   = new Font(fam, 36f, FontStyle.Bold, GraphicsUnit.Pixel);

                    // Authentic Brand Colors
                    Color colNavyHead    = Color.FromArgb(255, 0, 29, 74);     // #001D4A deep royal navy
                    Color colGold        = Color.FromArgb(255, 245, 166, 35);  // #F5A623 warm vibrant gold
                    Color colEyebrowNavy = Color.FromArgb(255, 29, 53, 104);   // #1D3568
                    Color colDesc        = Color.FromArgb(255, 30, 41, 59);    // #1E293B ultra-high contrast slate navy
                    Color colBadgeNavy   = Color.FromArgb(255, 10, 35, 69);    // #0A2345 deep corporate navy
                    Color colGoldRing    = Color.FromArgb(255, 248, 178, 32);  // #F8B220
                    Color colDivider     = Color.FromArgb(255, 205, 218, 230); // #CDDAE6

                    float startX = 132f; // matches X=33 at 1024

                    // =========================================================
                    // 1. EYEBROW: "QUALITY & COMPLIANCE" with gold underline under "QUALITY &"
                    // =========================================================
                    float eyeY = 168f;
                    using (SolidBrush eyeBrush = new SolidBrush(colEyebrowNavy)) {
                        DrawSpacedString(g, "QUALITY & COMPLIANCE", fontEyebrow, eyeBrush, startX, eyeY, 4.2f);
                    }

                    // Gold underline under "QUALITY &"
                    float goldUnderlineY = eyeY + 45f;
                    float goldUnderlineWidth = 475f;
                    using (SolidBrush goldBarBrush = new SolidBrush(colGold)) {
                        g.FillRectangle(goldBarBrush, startX, goldUnderlineY, goldUnderlineWidth, 5.5f);
                    }

                    // =========================================================
                    // 2. HEADING: "Trusted Quality." / "Global Compliance."
                    // =========================================================
                    float title1Y = 260f;
                    using (SolidBrush headBrush = new SolidBrush(colNavyHead)) {
                        g.DrawString("Trusted Quality.", fontHeading, headBrush, startX, title1Y);
                    }

                    float title2Y = 412f;
                    string globText = "Global ";
                    using (SolidBrush headBrush = new SolidBrush(colNavyHead)) {
                        g.DrawString(globText, fontHeading, headBrush, startX, title2Y);
                    }

                    SizeF globSize = g.MeasureString(globText, fontHeading);
                    float compX = startX + globSize.Width - 22f;

                    using (LinearGradientBrush compGoldBrush = new LinearGradientBrush(
                        new RectangleF(compX, title2Y, 700f, 150f),
                        colGold,
                        Color.FromArgb(255, 235, 145, 15),
                        LinearGradientMode.Vertical)) {
                        g.DrawString("Compliance.", fontHeading, compGoldBrush, compX, title2Y);
                    }

                    // =========================================================
                    // 3. SENTENCE: 4 lines, bold, high-contrast, crystal-clear
                    // =========================================================
                    float descY = 665f;
                    float lineH = 58f;
                    string desc1 = "At Concept Exim, we ensure that every product meets the highest international";
                    string desc2 = "quality standards and complies with global regulations. Our commitment to";
                    string desc3 = "quality, safety, and transparency builds trust with our clients, partners, and";
                    string desc4 = "communities worldwide.";

                    using (SolidBrush descBrush = new SolidBrush(colDesc)) {
                        g.DrawString(desc1, fontDesc, descBrush, startX, descY);
                        g.DrawString(desc2, fontDesc, descBrush, startX, descY + lineH);
                        g.DrawString(desc3, fontDesc, descBrush, startX, descY + lineH * 2f);
                        g.DrawString(desc4, fontDesc, descBrush, startX, descY + lineH * 3f);
                    }

                    // =========================================================
                    // 4. 5 CIRCULAR TRUST BADGES
                    // =========================================================
                    float ringCenterY = 960f;
                    float ringRadius = 58f;
                    float ringThick = 9f;

                    // 5 Center X positions
                    float[] badgeCenters = new float[] { 280f, 608f, 920f, 1248f, 1580f };
                    float[] dividers = new float[] { 445f, 764f, 1084f, 1414f };

                    string[][] badgeLines = new string[][] {
                        new string[] { "Global", "Standards" },
                        new string[] { "Certified", "Suppliers" },
                        new string[] { "Rigorous", "Inspection" },
                        new string[] { "Full", "Traceability" },
                        new string[] { "Sustainable", "Sourcing" }
                    };

                    for (int i = 0; i < 5; i++) {
                        float cx = badgeCenters[i];

                        // Gold Circle Ring
                        DrawBadgeCircle(g, cx, ringCenterY, ringRadius, ringThick, colGoldRing);

                        // Vector Icon inside circle
                        DrawBadgeIcon(g, i, cx, ringCenterY, ringRadius * 0.56f, colBadgeNavy);

                        // Centered 2-line Text below circle
                        float textStartY = ringCenterY + ringRadius + 22f;
                        DrawCenteredText(g, badgeLines[i][0], fontBadge, colBadgeNavy, cx, textStartY);
                        DrawCenteredText(g, badgeLines[i][1], fontBadge, colBadgeNavy, cx, textStartY + 42f);
                    }

                    // Vertical Dividers between badges
                    for (int i = 0; i < 4; i++) {
                        float divX = dividers[i];
                        DrawDivider(g, divX, ringCenterY - 45f, divX, ringCenterY + 98f, colDivider);
                    }
                }

                // Save full master 4K PNG
                dest.Save(outPath, ImageFormat.Png);

                // Save preview for visual artifact inspection
                int prevW = 1200;
                int prevH = (int)(targetH * ((float)prevW / targetW));
                using (Bitmap prev = new Bitmap(prevW, prevH)) {
                    using (Graphics pg = Graphics.FromImage(prev)) {
                        pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        pg.DrawImage(dest, 0, 0, prevW, prevH);
                    }
                    prev.Save(previewPath, ImageFormat.Png);
                }
            }
        }
    }

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraSpacing) {
        float curX = x;
        foreach (char c in text) {
            string s = c.ToString();
            g.DrawString(s, font, brush, curX, y);
            SizeF sz = g.MeasureString(s, font);
            curX += sz.Width - (font.Size * 0.16f) + extraSpacing;
        }
    }

    private static void DrawCenteredText(Graphics g, string text, Font font, Color color, float cx, float y) {
        SizeF sz = g.MeasureString(text, font);
        float x = cx - (sz.Width / 2f);
        using (SolidBrush b = new SolidBrush(color)) {
            g.DrawString(text, font, b, x, y);
        }
    }

    private static void DrawBadgeCircle(Graphics g, float cx, float cy, float r, float thickness, Color col) {
        // Soft creamy fill
        using (SolidBrush fillBrush = new SolidBrush(Color.FromArgb(22, 245, 166, 35))) {
            g.FillEllipse(fillBrush, cx - r, cy - r, r * 2f, r * 2f);
        }
        // Crisp Gold Ring
        using (Pen ringPen = new Pen(col, thickness)) {
            ringPen.Alignment = PenAlignment.Center;
            g.DrawEllipse(ringPen, cx - r, cy - r, r * 2f, r * 2f);
        }
    }

    private static void DrawDivider(Graphics g, float x1, float y1, float x2, float y2, Color col) {
        using (Pen p = new Pen(col, 2.5f)) {
            g.DrawLine(p, x1, y1, x2, y2);
        }
    }

    private static void DrawBadgeIcon(Graphics g, int index, float cx, float cy, float s, Color col) {
        using (Pen pen = new Pen(col, 3.8f))
        using (SolidBrush brush = new SolidBrush(col)) {
            pen.StartCap = LineCap.Round;
            pen.EndCap = LineCap.Round;
            pen.LineJoin = LineJoin.Round;

            switch (index) {
                case 0: // Globe
                    float gr = s * 0.95f;
                    g.DrawEllipse(pen, cx - gr, cy - gr, gr * 2f, gr * 2f);
                    g.DrawEllipse(pen, cx - (gr * 0.44f), cy - gr, gr * 0.88f, gr * 2f);
                    g.DrawLine(pen, cx - gr, cy, cx + gr, cy);
                    g.DrawLine(pen, cx - (gr * 0.82f), cy - (gr * 0.5f), cx + (gr * 0.82f), cy - (gr * 0.5f));
                    g.DrawLine(pen, cx - (gr * 0.82f), cy + (gr * 0.5f), cx + (gr * 0.82f), cy + (gr * 0.5f));
                    break;

                case 1: // Certified Suppliers (3 people)
                    // Center person
                    float chR = s * 0.32f;
                    g.FillEllipse(brush, cx - chR, cy - (s * 0.88f), chR * 2f, chR * 2f);
                    using (GraphicsPath bPath = new GraphicsPath()) {
                        bPath.AddArc(cx - (s * 0.6f), cy - (s * 0.15f), s * 1.2f, s * 0.95f, 180, 180);
                        bPath.CloseFigure();
                        g.FillPath(brush, bPath);
                    }
                    // Left person
                    float sideR = s * 0.24f;
                    float lx = cx - (s * 0.58f);
                    g.FillEllipse(brush, lx - sideR, cy - (s * 0.65f), sideR * 2f, sideR * 2f);
                    using (GraphicsPath lbPath = new GraphicsPath()) {
                        lbPath.AddArc(lx - (s * 0.45f), cy + (s * 0.05f), s * 0.9f, s * 0.75f, 180, 180);
                        lbPath.CloseFigure();
                        g.FillPath(brush, lbPath);
                    }
                    // Right person
                    float rx = cx + (s * 0.58f);
                    g.FillEllipse(brush, rx - sideR, cy - (s * 0.65f), sideR * 2f, sideR * 2f);
                    using (GraphicsPath rbPath = new GraphicsPath()) {
                        rbPath.AddArc(rx - (s * 0.45f), cy + (s * 0.05f), s * 0.9f, s * 0.75f, 180, 180);
                        rbPath.CloseFigure();
                        g.FillPath(brush, rbPath);
                    }
                    break;

                case 2: // Rigorous Inspection (Magnifying glass)
                    float mr = s * 0.56f;
                    float mcx = cx - (s * 0.22f);
                    float mcy = cy - (s * 0.22f);
                    using (Pen magPen = new Pen(col, 4.4f)) {
                        g.DrawEllipse(magPen, mcx - mr, mcy - mr, mr * 2f, mr * 2f);
                    }
                    // Handle
                    using (Pen hPen = new Pen(col, 6.4f)) {
                        hPen.StartCap = LineCap.Round;
                        hPen.EndCap = LineCap.Round;
                        float hx1 = mcx + (mr * 0.72f);
                        float hy1 = mcy + (mr * 0.72f);
                        float hx2 = cx + (s * 0.85f);
                        float hy2 = cy + (s * 0.85f);
                        g.DrawLine(hPen, hx1, hy1, hx2, hy2);
                    }
                    break;

                case 3: // Full Traceability (Location Map Pin)
                    float pinR = s * 0.54f;
                    float pinCy = cy - (s * 0.32f);
                    using (GraphicsPath pinPath = new GraphicsPath()) {
                        pinPath.AddArc(cx - pinR, pinCy - pinR, pinR * 2f, pinR * 2f, 180, 180);
                        pinPath.AddLine(cx + pinR, pinCy, cx, cy + (s * 0.88f));
                        pinPath.AddLine(cx, cy + (s * 0.88f), cx - pinR, pinCy);
                        pinPath.CloseFigure();
                        g.FillPath(brush, pinPath);
                    }
                    // White cutout hole inside pin
                    using (SolidBrush wHole = new SolidBrush(Color.White)) {
                        float holeR = s * 0.22f;
                        g.FillEllipse(wHole, cx - holeR, pinCy - holeR, holeR * 2f, holeR * 2f);
                    }
                    break;

                case 4: // Sustainable Sourcing (Elegant Leaf)
                    using (GraphicsPath leaf = new GraphicsPath()) {
                        leaf.AddBezier(cx - (s * 0.8f), cy + (s * 0.75f),
                                       cx - (s * 0.75f), cy - (s * 0.75f),
                                       cx + (s * 0.85f), cy - (s * 0.85f),
                                       cx + (s * 0.85f), cy - (s * 0.85f));
                        leaf.AddBezier(cx + (s * 0.85f), cy - (s * 0.85f),
                                       cx + (s * 0.75f), cy + (s * 0.55f),
                                       cx - (s * 0.8f), cy + (s * 0.75f),
                                       cx - (s * 0.8f), cy + (s * 0.75f));
                        leaf.CloseFigure();
                        g.FillPath(brush, leaf);
                    }
                    // Leaf stem vein in white
                    using (Pen stemPen = new Pen(Color.White, 3.0f)) {
                        stemPen.StartCap = LineCap.Round;
                        stemPen.EndCap = LineCap.Round;
                        g.DrawBezier(stemPen,
                            cx - (s * 0.65f), cy + (s * 0.65f),
                            cx - (s * 0.15f), cy + (s * 0.15f),
                            cx + (s * 0.25f), cy - (s * 0.25f),
                            cx + (s * 0.65f), cy - (s * 0.65f));
                    }
                    break;
            }
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

[VectorComplianceHeroV2]::RenderMaster($cleanBgPath, $testOutPath, $testPreviewPath, $fontSansPath)
Write-Host "Vector Compliance Master V2 rendered to $testOutPath"
