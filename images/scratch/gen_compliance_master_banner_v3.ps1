Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
$userUploaded = "C:\Users\Administrator\.gemini\antigravity-ide\brain\984eced1-f394-4a1f-bcf5-919d9d5f0246\.user_uploaded\media_1790331452802.png"
$destPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png"
$destPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.png"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class MasterComplianceHero4Kv3 {
    public static void GenerateMasterBanner(string userUploadedPath, string outPng1, string outPng2, string fontSansPath, int scale) {
        // 1. Load user uploaded screenshot (1024 x 169) and crop exactly to the banner area (1019 x 153)
        byte[] bytes = System.IO.File.ReadAllBytes(userUploadedPath);
        using (System.IO.MemoryStream ms = new System.IO.MemoryStream(bytes))
        using (Bitmap rawSrc = new Bitmap(ms)) {
            int cropX = 0;
            int cropY = 6;
            int cropW = 1019;
            int cropH = 153;

            Rectangle srcRect = new Rectangle(cropX, cropY, cropW, cropH);
            using (Bitmap croppedSrc = rawSrc.Clone(srcRect, PixelFormat.Format32bppArgb)) {
                int targetW = cropW * scale; // 1019 * 4 = 4076
                int targetH = cropH * scale; // 153 * 4 = 612

                using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                    using (Graphics g = Graphics.FromImage(destBmp)) {
                        g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        g.SmoothingMode = SmoothingMode.HighQuality;
                        g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                        g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                        // 1. Draw upscaled base photo
                        g.DrawImage(croppedSrc, 0, 0, targetW, targetH);

                        // 2. Inpaint the left text area with the exact deep navy blue twilight gradient
                        // Erases all old blurry text from X=0 to X=415 (in 1x scale)
                        // Fades smoothly between 398 and 415, ending right before the scientist at 418
                        int cardRightX = 415 * scale;
                        int fadeStartX = 398 * scale;
                        float fadeWidth = (float)(cardRightX - fadeStartX);

                        using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                            using (Graphics pg = Graphics.FromImage(patch)) {
                                pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                                pg.SmoothingMode = SmoothingMode.HighQuality;

                                // Exact vertical Deep Navy gradient matching original branding
                                using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                    new Rectangle(0, 0, cardRightX, targetH),
                                    Color.FromArgb(255, 11, 38, 63),
                                    Color.FromArgb(255, 3, 26, 49),
                                    LinearGradientMode.Vertical)) {

                                    ColorBlend cb = new ColorBlend(4);
                                    cb.Positions = new float[] { 0f, 0.30f, 0.70f, 1f };
                                    cb.Colors = new Color[] {
                                        Color.FromArgb(255, 11, 38, 63),   // #0b263f at top
                                        Color.FromArgb(255, 16, 44, 70),   // #102c46 mid-top
                                        Color.FromArgb(255, 7, 32, 57),    // #072039 mid-low
                                        Color.FromArgb(255, 3, 26, 49)     // #031a31 bottom navy
                                    };
                                    bgBrush.InterpolationColors = cb;
                                    pg.FillRectangle(bgBrush, 0, 0, cardRightX, targetH);
                                }

                                // Luminous subtle blue depth glow in upper-left
                                using (GraphicsPath glowPath = new GraphicsPath()) {
                                    glowPath.AddEllipse(-30 * scale, -20 * scale, 350 * scale, 210 * scale);
                                    using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                        pgb.CenterColor = Color.FromArgb(55, 45, 110, 180);
                                        pgb.SurroundColors = new Color[] { Color.FromArgb(0, 7, 28, 52) };
                                        pg.FillPath(pgb, glowPath);
                                    }
                                }

                                // Smooth cosine fade into the lab scene between fadeStartX and cardRightX
                                for (int y = 0; y < targetH; y++) {
                                    for (int x = fadeStartX; x < cardRightX; x++) {
                                        float f = (float)(x - fadeStartX) / fadeWidth;
                                        float alpha = 0.5f * (1f + (float)Math.Cos(f * Math.PI));
                                        Color orig = patch.GetPixel(x, y);
                                        patch.SetPixel(x, y, Color.FromArgb((int)(orig.A * alpha), orig.R, orig.G, orig.B));
                                    }
                                }
                            }

                            g.DrawImage(patch, 0, 0);
                        }

                        // 3. Re-inpaint the 4-pillars capsule area on the right with 100% OPAQUE backdrop
                        // Exactly covers X: 742 to 998, Y: 106 to 149 in 1x scale
                        float capX = 742f * scale;
                        float capY = 106f * scale;
                        float capW = 256f * scale;
                        float capH = 43f * scale;
                        float capRadius = 7f * scale;

                        using (GraphicsPath capPath = CreateRoundedRect(capX, capY, capW, capH, capRadius)) {
                            // 100% Solid Opaque Dark Navy background - completely obliterates any blurry text beneath!
                            using (SolidBrush capOpaqueBg = new SolidBrush(Color.FromArgb(255, 7, 21, 37))) {
                                g.FillPath(capOpaqueBg, capPath);
                            }
                            // Subtle glass gradient overlay
                            using (LinearGradientBrush glassOverlay = new LinearGradientBrush(
                                new RectangleF(capX, capY, capW, capH),
                                Color.FromArgb(35, 255, 255, 255),
                                Color.FromArgb(5, 255, 255, 255),
                                LinearGradientMode.Vertical)) {
                                g.FillPath(glassOverlay, capPath);
                            }
                            // Crisp glass border
                            using (Pen capPen = new Pen(Color.FromArgb(85, 255, 255, 255), 1.2f * scale)) {
                                g.DrawPath(capPen, capPath);
                            }
                        }

                        // 4. Load brand typography (Plus Jakarta Sans)
                        PrivateFontCollection pfc = new PrivateFontCollection();
                        if (!string.IsNullOrEmpty(fontSansPath) && System.IO.File.Exists(fontSansPath)) {
                            pfc.AddFontFile(fontSansPath);
                        }
                        FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                        // 5. Draw Left Typography (Ultra-crisp, crystal clear, 100% legible)
                        float startX = 36f * scale;

                        // Eyebrow: QUALITY & COMPLIANCE (Gold, bold uppercase, letter-spaced)
                        float eyebrowY = 16f * scale;
                        using (Font eyebrowFont = new Font(fam, 5.6f * scale, FontStyle.Bold))
                        using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(245, 196, 76))) {
                            DrawSpacedString(g, "QUALITY & COMPLIANCE", eyebrowFont, goldEyebrow, startX, eyebrowY, 1.25f * scale);
                        }

                        // Headline Line 1: Trusted Quality. (Pure White, Bold 800)
                        float line1Y = 26.5f * scale;
                        using (Font titleFont = new Font(fam, 18.2f * scale, FontStyle.Bold))
                        using (SolidBrush whiteTitle = new SolidBrush(Color.FromArgb(255, 255, 255)))
                        using (SolidBrush goldTitle = new SolidBrush(Color.FromArgb(245, 196, 76))) {
                            g.DrawString("Trusted Quality.", titleFont, whiteTitle, startX - (0.5f * scale), line1Y);

                            // Headline Line 2: Global (White) + Compliance. (Gold)
                            float line2Y = 46.5f * scale;
                            string globStr = "Global ";
                            g.DrawString(globStr, titleFont, whiteTitle, startX - (0.5f * scale), line2Y);
                            SizeF globSize = g.MeasureString(globStr, titleFont);
                            float compX = startX + globSize.Width - (4.2f * scale);
                            g.DrawString("Compliance.", titleFont, goldTitle, compX, line2Y);
                        }

                        // Description Paragraph: 4 lines in high-contrast Ice-White, 100% sharp and readable
                        float descY = 71.0f * scale;
                        using (Font descFont = new Font(fam, 4.6f * scale, FontStyle.Regular))
                        using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(255, 240, 246, 252))) {
                            string l1 = "At KlanExim, we ensure that every product meets the highest international";
                            string l2 = "quality standards and complies with global regulations. Our commitment to";
                            string l3 = "quality, safety, and transparency builds trust with our clients, partners, and communities";
                            string l4 = "worldwide.";

                            float lineSpacing = 7.3f * scale;
                            g.DrawString(l1, descFont, descBrush, startX, descY);
                            g.DrawString(l2, descFont, descBrush, startX, descY + lineSpacing);
                            g.DrawString(l3, descFont, descBrush, startX, descY + lineSpacing * 2);
                            g.DrawString(l4, descFont, descBrush, startX, descY + lineSpacing * 3);
                        }

                        // 6. Draw 5 Circular Badges on Left Bottom
                        // Spaced across X = 36 to X = 410 (exactly 78px increments)
                        float badgeY = 112f * scale;
                        float circleRadius = 7.6f * scale;
                        float circleDiam = circleRadius * 2f;

                        float[] badgeX = new float[] {
                            startX,
                            startX + (78f * scale),
                            startX + (156f * scale),
                            startX + (234f * scale),
                            startX + (312f * scale)
                        };

                        string[][] badgeTexts = new string[][] {
                            new string[] { "Global", "Standards" },
                            new string[] { "Certified", "Suppliers" },
                            new string[] { "Rigorous", "Inspection" },
                            new string[] { "Full", "Traceability" },
                            new string[] { "Sustainable", "Sourcing" }
                        };

                        using (Pen circlePen = new Pen(Color.FromArgb(245, 196, 76), 1.25f * scale))
                        using (SolidBrush circleFill = new SolidBrush(Color.FromArgb(35, 245, 196, 76)))
                        using (SolidBrush iconGold = new SolidBrush(Color.FromArgb(245, 205, 95)))
                        using (Pen iconPen = new Pen(Color.FromArgb(245, 205, 95), 1.15f * scale))
                        using (Font bTopFont = new Font(fam, 4.3f * scale, FontStyle.Bold))
                        using (Font bSubFont = new Font(fam, 3.9f * scale, FontStyle.Regular))
                        using (SolidBrush textWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                        using (SolidBrush textSub = new SolidBrush(Color.FromArgb(220, 235, 248))) {
                            for (int i = 0; i < 5; i++) {
                                float bx = badgeX[i];
                                float cy = badgeY + circleRadius;
                                float cx = bx + circleRadius;

                                // Draw gold ring circle
                                g.FillEllipse(circleFill, bx, badgeY, circleDiam, circleDiam);
                                g.DrawEllipse(circlePen, bx, badgeY, circleDiam, circleDiam);

                                // Draw vector icon inside circle
                                DrawLeftBadgeIcon(g, i, cx, cy, circleRadius, iconPen, iconGold);

                                // Draw 2-line text beside circle
                                float tx = bx + circleDiam + (3.4f * scale);
                                g.DrawString(badgeTexts[i][0], bTopFont, textWhite, tx, badgeY + (0.5f * scale));
                                g.DrawString(badgeTexts[i][1], bSubFont, textSub, tx, badgeY + (6.2f * scale));
                            }
                        }

                        // 7. Draw 4 Pillar Badges in Right Capsule (Safety, Integrity, Excellence, Sustainability)
                        float colW = capW / 4f;
                        string[] pillarNames = new string[] { "Safety", "Integrity", "Excellence", "Sustainability" };

                        using (Font pilFont = new Font(fam, 4.3f * scale, FontStyle.Bold))
                        using (SolidBrush pilWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                        using (Pen pilPen = new Pen(Color.FromArgb(255, 245, 250, 255), 1.15f * scale))
                        using (Pen divPen = new Pen(Color.FromArgb(45, 255, 255, 255), 1.0f * scale)) {
                            for (int i = 0; i < 4; i++) {
                                float cellX = capX + (i * colW);
                                float cellMidX = cellX + (colW / 2f);

                                // Shield icon
                                float iconCy = capY + (13.5f * scale);
                                DrawPillarShieldIcon(g, i, cellMidX, iconCy, 7.0f * scale, pilPen);

                                // Pillar Label centered
                                SizeF sz = g.MeasureString(pillarNames[i], pilFont);
                                float tx = cellMidX - (sz.Width / 2f);
                                float ty = capY + (26.5f * scale);
                                g.DrawString(pillarNames[i], pilFont, pilWhite, tx, ty);

                                // Vertical divider line
                                if (i > 0) {
                                    g.DrawLine(divPen, cellX, capY + (6f * scale), cellX, capY + capH - (6f * scale));
                                }
                            }
                        }

                        // 8. Draw smooth bottom S-curve wave boundary with white fill & gold line
                        PointF[] curvePoints = new PointF[] {
                            new PointF(0f * scale, 145f * scale),
                            new PointF(40f * scale, 147.5f * scale),
                            new PointF(100f * scale, 149.5f * scale),
                            new PointF(200f * scale, 151f * scale),
                            new PointF(400f * scale, 152f * scale),
                            new PointF(700f * scale, 152.5f * scale),
                            new PointF(1019f * scale, 153f * scale)
                        };

                        GraphicsPath waveArea = new GraphicsPath();
                        waveArea.AddCurve(curvePoints, 0.45f);
                        waveArea.AddLine(1019f * scale, 153f * scale, targetW, targetH);
                        waveArea.AddLine(targetW, targetH, 0, targetH);
                        waveArea.CloseFigure();

                        using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                            g.FillPath(whiteBrush, waveArea);
                        }

                        using (Pen goldPen = new Pen(Color.FromArgb(245, 196, 76), 1.3f * scale)) {
                            g.DrawCurve(goldPen, curvePoints, 0.45f);
                        }
                    }

                    // Save to destination files
                    destBmp.Save(outPng1, ImageFormat.Png);
                    if (!string.IsNullOrEmpty(outPng2)) {
                        destBmp.Save(outPng2, ImageFormat.Png);
                    }
                }
            }
        }
    }

    private static GraphicsPath CreateRoundedRect(float x, float y, float w, float h, float r) {
        GraphicsPath path = new GraphicsPath();
        float d = r * 2f;
        path.AddArc(x, y, d, d, 180, 90);
        path.AddArc(x + w - d, y, d, d, 270, 90);
        path.AddArc(x + w - d, y + h - d, d, d, 0, 90);
        path.AddArc(x, y + h - d, d, d, 90, 90);
        path.CloseFigure();
        return path;
    }

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraSpacing) {
        float currentX = x;
        foreach (char c in text) {
            string s = c.ToString();
            g.DrawString(s, font, brush, currentX, y);
            SizeF size = g.MeasureString(s, font);
            currentX += size.Width - (font.Size * 0.16f) + extraSpacing;
        }
    }

    private static void DrawLeftBadgeIcon(Graphics g, int index, float cx, float cy, float r, Pen pen, SolidBrush brush) {
        float s = r * 0.52f;
        switch (index) {
            case 0: // Globe
                g.DrawEllipse(pen, cx - s * 0.8f, cy - s * 0.8f, s * 1.6f, s * 1.6f);
                g.DrawEllipse(pen, cx - s * 0.35f, cy - s * 0.8f, s * 0.7f, s * 1.6f);
                g.DrawLine(pen, cx - s * 0.8f, cy, cx + s * 0.8f, cy);
                break;
            case 1: // Certified Star / Badge
                GraphicsPath star = new GraphicsPath();
                float ro = s * 0.85f;
                float ri = s * 0.4f;
                for (int i = 0; i < 16; i++) {
                    double angle = (i * Math.PI) / 8.0 - (Math.PI / 2.0);
                    float rad = (i % 2 == 0) ? ro : ri;
                    float px = cx + (float)(Math.Cos(angle) * rad);
                    float py = cy + (float)(Math.Sin(angle) * rad);
                    if (i == 0) star.AddLine(px, py, px, py);
                    else star.AddLine(star.GetLastPoint(), new PointF(px, py));
                }
                star.CloseFigure();
                g.DrawPath(pen, star);
                break;
            case 2: // Rigorous Inspection (Target / Lens)
                g.DrawEllipse(pen, cx - s * 0.8f, cy - s * 0.8f, s * 1.6f, s * 1.6f);
                g.DrawEllipse(pen, cx - s * 0.4f, cy - s * 0.4f, s * 0.8f, s * 0.8f);
                g.FillEllipse(brush, cx - s * 0.15f, cy - s * 0.15f, s * 0.3f, s * 0.3f);
                break;
            case 3: // Full Traceability (Nodes network)
                g.FillEllipse(brush, cx - s * 0.6f, cy - s * 0.5f, s * 0.35f, s * 0.35f);
                g.FillEllipse(brush, cx + s * 0.3f, cy - s * 0.5f, s * 0.35f, s * 0.35f);
                g.FillEllipse(brush, cx, cy + s * 0.4f, s * 0.35f, s * 0.35f);
                g.DrawLine(pen, cx - s * 0.4f, cy - s * 0.35f, cx + s * 0.45f, cy - s * 0.35f);
                g.DrawLine(pen, cx - s * 0.4f, cy - s * 0.35f, cx + s * 0.15f, cy + s * 0.4f);
                g.DrawLine(pen, cx + s * 0.45f, cy - s * 0.35f, cx + s * 0.15f, cy + s * 0.4f);
                break;
            case 4: // Sustainable Sourcing (Sprout / Leaf)
                GraphicsPath leaf = new GraphicsPath();
                leaf.AddBezier(cx - s * 0.6f, cy + s * 0.5f, cx - s * 0.5f, cy - s * 0.6f, cx + s * 0.6f, cy - s * 0.7f, cx + s * 0.6f, cy - s * 0.7f);
                leaf.AddBezier(cx + s * 0.6f, cy - s * 0.7f, cx + s * 0.6f, cy + s * 0.3f, cx - s * 0.6f, cy + s * 0.5f, cx - s * 0.6f, cy + s * 0.5f);
                leaf.CloseFigure();
                g.DrawPath(pen, leaf);
                g.DrawLine(pen, cx - s * 0.4f, cy + s * 0.35f, cx + s * 0.35f, cy - s * 0.35f);
                break;
        }
    }

    private static void DrawPillarShieldIcon(Graphics g, int index, float cx, float cy, float r, Pen pen) {
        float s = r * 0.85f;
        // Draw base shield
        GraphicsPath sh = new GraphicsPath();
        sh.AddLine(cx - s * 0.65f, cy - s * 0.7f, cx + s * 0.65f, cy - s * 0.7f);
        sh.AddLine(cx + s * 0.65f, cy - s * 0.7f, cx + s * 0.65f, cy + s * 0.1f);
        sh.AddBezier(cx + s * 0.65f, cy + s * 0.1f, cx + s * 0.4f, cy + s * 0.65f, cx, cy + s * 0.9f, cx, cy + s * 0.9f);
        sh.AddBezier(cx, cy + s * 0.9f, cx - s * 0.4f, cy + s * 0.65f, cx - s * 0.65f, cy + s * 0.1f, cx - s * 0.65f, cy + s * 0.1f);
        sh.CloseFigure();
        g.DrawPath(pen, sh);

        // Inner icon
        switch (index) {
            case 0: // Safety - Checkmark inside shield
                g.DrawLine(pen, cx - s * 0.3f, cy + s * 0.05f, cx - s * 0.05f, cy + s * 0.35f);
                g.DrawLine(pen, cx - s * 0.05f, cy + s * 0.35f, cx + s * 0.35f, cy - s * 0.25f);
                break;
            case 1: // Integrity - Star/ribbon checkmark
                g.DrawLine(pen, cx - s * 0.25f, cy + s * 0.05f, cx - s * 0.05f, cy + s * 0.32f);
                g.DrawLine(pen, cx - s * 0.05f, cy + s * 0.32f, cx + s * 0.3f, cy - s * 0.22f);
                break;
            case 2: // Excellence - Award rosette / checkmark
                g.DrawLine(pen, cx - s * 0.25f, cy + s * 0.05f, cx - s * 0.05f, cy + s * 0.32f);
                g.DrawLine(pen, cx - s * 0.05f, cy + s * 0.32f, cx + s * 0.3f, cy - s * 0.22f);
                break;
            case 3: // Sustainability - Seedling sprout inside shield
                g.DrawEllipse(pen, cx - s * 0.25f, cy - s * 0.25f, s * 0.5f, s * 0.5f);
                break;
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

Write-Host "Rendering 4X Ultra High Definition Master Compliance Banner v3 (4076 x 612)..."
[MasterComplianceHero4Kv3]::GenerateMasterBanner($userUploaded, $destPng1, $destPng2, $fontSans, 4)
Write-Host "Master Compliance Banner v3 Generated Successfully!"

$outImg = [System.Drawing.Image]::FromFile($destPng1)
Write-Host "Output Size: $($outImg.Width) x $($outImg.Height)"
$outImg.Dispose()
