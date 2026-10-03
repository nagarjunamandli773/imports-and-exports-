Add-Type -AssemblyName System.Drawing

$src1x = "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner_user_1x.png"
if (-not (Test-Path $src1x)) {
    $src1x = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790499551687.png"
}
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ComplianceMasterDeployer {
    public static void DeployAll(string src1xPath, string fontSansPath, string[] outPngs, string[] outJpgs, string previewPath) {
        // Step 1: Clean background via Laplace PDE diffusion on 1x image
        Bitmap clean1x;
        using (Bitmap raw = new Bitmap(src1xPath)) {
            int w = raw.Width;   // 1024
            int h = raw.Height;  // 341

            clean1x = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(clean1x)) {
                g.DrawImage(raw, 0, 0);
            }

            // Fill core pure-white polygon
            using (Graphics g = Graphics.FromImage(clean1x)) {
                using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                    GraphicsPath path = new GraphicsPath();
                    PointF[] pts = new PointF[] {
                        new PointF(24, 36),
                        new PointF(330, 36),
                        new PointF(330, 300),
                        new PointF(60, 300),
                        new PointF(40, 292),
                        new PointF(24, 285)
                    };
                    path.AddPolygon(pts);
                    g.FillPath(whiteBrush, path);
                }
            }

            // Mask in transition zone X: 320 to 455, Y: 35 to 302
            bool[,] mask = new bool[w, h];
            for (int y = 35; y <= 302; y++) {
                for (int x = 320; x <= 455; x++) {
                    Color p = clean1x.GetPixel(x, y);
                    bool isNotBg = false;
                    if (p.R < 232 || p.G < 235 || p.B < 235) isNotBg = true;
                    if (p.R > 210 && p.B < 195) isNotBg = true;
                    if (y >= 220 && (p.R < 242 || p.G < 244 || p.B < 244)) isNotBg = true;
                    if (isNotBg) mask[x, y] = true;
                }
            }

            // Dilate mask by 3px
            bool[,] dilated = new bool[w, h];
            for (int y = 30; y <= 306; y++) {
                for (int x = 315; x <= 460; x++) {
                    bool found = false;
                    for (int dy = -3; dy <= 3 && !found; dy++) {
                        for (int dx = -3; dx <= 3 && !found; dx++) {
                            int nx = x + dx;
                            int ny = y + dy;
                            if (nx >= 0 && nx < w && ny >= 0 && ny < h) {
                                if (mask[nx, ny]) found = true;
                            }
                        }
                    }
                    dilated[x, y] = found;
                }
            }

            // Laplace diffusion
            double[,] rArr = new double[w, h];
            double[,] gArr = new double[w, h];
            double[,] bArr = new double[w, h];

            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    Color p = clean1x.GetPixel(x, y);
                    rArr[x, y] = p.R;
                    gArr[x, y] = p.G;
                    bArr[x, y] = p.B;
                }
            }

            for (int iter = 0; iter < 1500; iter++) {
                for (int y = 30; y <= 306; y++) {
                    for (int x = 315; x <= 460; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }

            for (int y = 30; y <= 306; y++) {
                for (int x = 315; x <= 460; x++) {
                    if (dilated[x, y]) {
                        int r = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y])));
                        int gCol = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y])));
                        int bCol = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y])));
                        clean1x.SetPixel(x, y, Color.FromArgb(r, gCol, bCol));
                    }
                }
            }
        }

        // Step 2: Render 4K Vector Master (4096 x 1364)
        int targetW = 4096;
        int targetH = 1364;

        using (Bitmap master4k = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
            using (Graphics g = Graphics.FromImage(master4k)) {
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                // 1. Draw clean background
                g.DrawImage(clean1x, 0, 0, targetW, targetH);

                // 2. Load Brand Fonts
                PrivateFontCollection pfc = new PrivateFontCollection();
                if (!string.IsNullOrEmpty(fontSansPath) && System.IO.File.Exists(fontSansPath)) {
                    pfc.AddFontFile(fontSansPath);
                }
                FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                Font fontEyebrow = new Font(fam, 37f, FontStyle.Bold, GraphicsUnit.Pixel);
                Font fontHeading = new Font(fam, 134f, FontStyle.Bold, GraphicsUnit.Pixel);
                Font fontDesc    = new Font(fam, 43f, FontStyle.Bold, GraphicsUnit.Pixel);
                Font fontBadge   = new Font(fam, 36f, FontStyle.Bold, GraphicsUnit.Pixel);

                // Authentic Colors
                Color colNavyHead    = Color.FromArgb(255, 0, 29, 74);     // #001D4A deep royal navy
                Color colGold        = Color.FromArgb(255, 245, 166, 35);  // #F5A623 warm vibrant gold
                Color colEyebrowNavy = Color.FromArgb(255, 29, 53, 104);   // #1D3568
                Color colDesc        = Color.FromArgb(255, 30, 41, 59);    // #1E293B ultra-high contrast slate navy
                Color colBadgeNavy   = Color.FromArgb(255, 10, 35, 69);    // #0A2345 deep corporate navy
                Color colGoldRing    = Color.FromArgb(255, 248, 178, 32);  // #F8B220
                Color colDivider     = Color.FromArgb(255, 205, 218, 230); // #CDDAE6

                float startX = 132f;

                // StringFormat for perfect typographic kerning
                StringFormat sfTypo = StringFormat.GenericTypographic;
                sfTypo.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces;

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
                    g.DrawString("Trusted Quality.", fontHeading, headBrush, startX, title1Y, sfTypo);
                }

                float title2Y = 412f;
                string globText = "Global ";
                using (SolidBrush headBrush = new SolidBrush(colNavyHead)) {
                    g.DrawString(globText, fontHeading, headBrush, startX, title2Y, sfTypo);
                }

                SizeF globSize = g.MeasureString(globText, fontHeading, new PointF(startX, title2Y), sfTypo);
                float compX = startX + globSize.Width + 4f;

                using (LinearGradientBrush compGoldBrush = new LinearGradientBrush(
                    new RectangleF(compX, title2Y, 700f, 150f),
                    colGold,
                    Color.FromArgb(255, 235, 145, 15),
                    LinearGradientMode.Vertical)) {
                    g.DrawString("Compliance.", fontHeading, compGoldBrush, compX, title2Y, sfTypo);
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
                    g.DrawString(desc1, fontDesc, descBrush, startX, descY, sfTypo);
                    g.DrawString(desc2, fontDesc, descBrush, startX, descY + lineH, sfTypo);
                    g.DrawString(desc3, fontDesc, descBrush, startX, descY + lineH * 2f, sfTypo);
                    g.DrawString(desc4, fontDesc, descBrush, startX, descY + lineH * 3f, sfTypo);
                }

                // =========================================================
                // 4. 5 CIRCULAR TRUST BADGES
                // =========================================================
                float ringCenterY = 960f;
                float ringRadius = 58f;
                float ringThick = 9f;

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
                    DrawCenteredText(g, badgeLines[i][0], fontBadge, colBadgeNavy, cx, textStartY, sfTypo);
                    DrawCenteredText(g, badgeLines[i][1], fontBadge, colBadgeNavy, cx, textStartY + 42f, sfTypo);
                }

                // Vertical Dividers between badges
                for (int i = 0; i < 4; i++) {
                    float divX = dividers[i];
                    DrawDivider(g, divX, ringCenterY - 45f, divX, ringCenterY + 98f, colDivider);
                }
            }

            // Save Master PNGs
            foreach (string pngPath in outPngs) {
                master4k.Save(pngPath, ImageFormat.Png);
                Console.WriteLine("Saved: " + pngPath);
            }

            // Save Master JPEGs (Quality 96)
            ImageCodecInfo jpegCodec = null;
            foreach (ImageCodecInfo codec in ImageCodecInfo.GetImageEncoders()) {
                if (codec.MimeType == "image/jpeg") { jpegCodec = codec; break; }
            }
            if (jpegCodec != null) {
                EncoderParameters ep = new EncoderParameters(1);
                ep.Param[0] = new EncoderParameter(Encoder.Quality, 96L);
                foreach (string jpgPath in outJpgs) {
                    master4k.Save(jpgPath, jpegCodec, ep);
                    Console.WriteLine("Saved: " + jpgPath);
                }
            }

            // Save 1200px Preview Artifact
            int prevW = 1200;
            int prevH = (int)(targetH * ((float)prevW / targetW));
            using (Bitmap prev = new Bitmap(prevW, prevH)) {
                using (Graphics pg = Graphics.FromImage(prev)) {
                    pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    pg.DrawImage(master4k, 0, 0, prevW, prevH);
                }
                prev.Save(previewPath, ImageFormat.Png);
                Console.WriteLine("Preview saved: " + previewPath);
            }
        }
        clean1x.Dispose();
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

    private static void DrawCenteredText(Graphics g, string text, Font font, Color color, float cx, float y, StringFormat sf) {
        SizeF sz = g.MeasureString(text, font, new PointF(0, 0), sf);
        float x = cx - (sz.Width / 2f);
        using (SolidBrush b = new SolidBrush(color)) {
            g.DrawString(text, font, b, x, y, sf);
        }
    }

    private static void DrawBadgeCircle(Graphics g, float cx, float cy, float r, float thickness, Color col) {
        using (SolidBrush fillBrush = new SolidBrush(Color.FromArgb(22, 245, 166, 35))) {
            g.FillEllipse(fillBrush, cx - r, cy - r, r * 2f, r * 2f);
        }
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
                    float chR = s * 0.32f;
                    g.FillEllipse(brush, cx - chR, cy - (s * 0.88f), chR * 2f, chR * 2f);
                    using (GraphicsPath bPath = new GraphicsPath()) {
                        bPath.AddArc(cx - (s * 0.6f), cy - (s * 0.15f), s * 1.2f, s * 0.95f, 180, 180);
                        bPath.CloseFigure();
                        g.FillPath(brush, bPath);
                    }
                    float sideR = s * 0.24f;
                    float lx = cx - (s * 0.58f);
                    g.FillEllipse(brush, lx - sideR, cy - (s * 0.65f), sideR * 2f, sideR * 2f);
                    using (GraphicsPath lbPath = new GraphicsPath()) {
                        lbPath.AddArc(lx - (s * 0.45f), cy + (s * 0.05f), s * 0.9f, s * 0.75f, 180, 180);
                        lbPath.CloseFigure();
                        g.FillPath(brush, lbPath);
                    }
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

$outPngs = @(
    "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png",
    "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.png"
)

$outJpgs = @(
    "c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.jpg",
    "c:\Users\Administrator\Pictures\emports and exports\images\compliance_hero_banner.jpg"
)

$previewPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_compliance_banner_preview.png"

Write-Host "Deploying Master 4K Compliance Hero Banner across all targets..."
[ComplianceMasterDeployer]::DeployAll($src1x, $fontSansPath, $outPngs, $outJpgs, $previewPath)
Write-Host "Compliance Master Hero Banner deployed successfully!"
