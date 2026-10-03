Add-Type -AssemblyName System.Drawing

$src1x = "C:\Users\Administrator\.gemini\antigravity-ide\brain\7a6cf5c9-7082-4a64-9737-baa34e61ebc3\.user_uploaded\media_1790503971818.png"
if (-not (Test-Path $src1x)) {
    $src1x = "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png"
}
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class InsightsMasterDeployer {
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

            // Fill core pure-white polygon avoiding the bottom-left swoosh
            using (Graphics g = Graphics.FromImage(clean1x)) {
                using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                    GraphicsPath path = new GraphicsPath();
                    PointF[] pts = new PointF[] {
                        new PointF(24, 45),
                        new PointF(350, 45),
                        new PointF(350, 292),
                        new PointF(100, 292),
                        new PointF(50, 290),
                        new PointF(35, 282),
                        new PointF(24, 270)
                    };
                    path.AddPolygon(pts);
                    g.FillPath(whiteBrush, path);
                }
            }

            // Mask in transition zone X: 330 to 455, Y: 45 to 295
            bool[,] mask = new bool[w, h];
            for (int y = 45; y <= 295; y++) {
                for (int x = 330; x <= 455; x++) {
                    Color p = clean1x.GetPixel(x, y);
                    bool isNotBg = false;
                    if (p.R < 232 || p.G < 235 || p.B < 235) isNotBg = true;
                    if (p.R > 210 && p.B < 195) isNotBg = true;
                    if (y >= 210 && (p.R < 242 || p.G < 244 || p.B < 244)) isNotBg = true;
                    if (isNotBg) mask[x, y] = true;
                }
            }

            // Dilate mask by 3px
            bool[,] dilated = new bool[w, h];
            for (int y = 40; y <= 300; y++) {
                for (int x = 325; x <= 460; x++) {
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
                for (int y = 40; y <= 300; y++) {
                    for (int x = 325; x <= 460; x++) {
                        if (dilated[x, y]) {
                            rArr[x, y] = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            gArr[x, y] = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            bArr[x, y] = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;
                        }
                    }
                }
            }

            for (int y = 40; y <= 300; y++) {
                for (int x = 325; x <= 460; x++) {
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

                // Authentic Colors
                Color colNavyHead    = Color.FromArgb(255, 0, 29, 74);     // #001D4A deep royal navy
                Color colGold        = Color.FromArgb(255, 245, 166, 35);  // #F5A623 warm vibrant gold
                Color colEyebrowNavy = Color.FromArgb(255, 29, 53, 104);   // #1D3568
                Color colDesc        = Color.FromArgb(255, 30, 41, 59);    // #1E293B ultra-high contrast slate navy
                Color colBadgeNavy   = Color.FromArgb(255, 10, 35, 69);    // #0A2345 deep corporate navy
                Color colGoldRing    = Color.FromArgb(255, 248, 178, 32);  // #F8B220
                Color colDivider     = Color.FromArgb(255, 205, 218, 230); // #CDDAE6

                float startX = 144f;

                // StringFormat for typographic kerning
                StringFormat sfTypo = StringFormat.GenericTypographic;
                sfTypo.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces;

                // =========================================================
                // 1. EYEBROW: Gold Accent Bar + "MARKET INTELLIGENCE & INSIGHTS"
                // =========================================================
                float goldBarY = 248f;
                float goldBarW = 412f;
                using (SolidBrush goldBarBrush = new SolidBrush(colGold)) {
                    g.FillRectangle(goldBarBrush, startX, goldBarY, goldBarW, 5.5f);
                }

                float eyeY = 276f;
                using (SolidBrush eyeBrush = new SolidBrush(colEyebrowNavy)) {
                    DrawSpacedString(g, "MARKET INTELLIGENCE & INSIGHTS", fontEyebrow, eyeBrush, startX, eyeY, 4.2f);
                }

                // =========================================================
                // 2. HEADING: "Insights for a Smarter" / "Global Tomorrow"
                // =========================================================
                float title1Y = 368f;
                using (SolidBrush headBrush = new SolidBrush(colNavyHead)) {
                    g.DrawString("Insights for a Smarter", fontHeading, headBrush, startX, title1Y, sfTypo);
                }

                float title2Y = 516f;
                using (LinearGradientBrush compGoldBrush = new LinearGradientBrush(
                    new RectangleF(startX, title2Y, 1100f, 150f),
                    colGold,
                    Color.FromArgb(255, 235, 145, 15),
                    LinearGradientMode.Vertical)) {
                    g.DrawString("Global Tomorrow", fontHeading, compGoldBrush, startX, title2Y, sfTypo);
                }

                // =========================================================
                // 3. SENTENCE: 2 lines, bold, high-contrast, crystal-clear
                // =========================================================
                float descY = 695f;
                float lineH = 62f;
                string desc1 = "Stay ahead with the latest market trends, industry updates, trade insights and expert";
                string desc2 = "analysis. At Concept Exim, we turn information into opportunities for your global success.";

                using (SolidBrush descBrush = new SolidBrush(colDesc)) {
                    g.DrawString(desc1, fontDesc, descBrush, startX, descY, sfTypo);
                    g.DrawString(desc2, fontDesc, descBrush, startX, descY + lineH, sfTypo);
                }

                // =========================================================
                // 4. 5 CIRCULAR TRUST BADGES
                // =========================================================
                float ringCenterY = 944f;
                float ringRadius = 58f;
                float ringThick = 9f;

                float[] badgeCenters = new float[] { 248f, 552f, 864f, 1172f, 1512f };
                float[] dividers = new float[] { 392f, 704f, 1024f, 1344f };

                string[][] badgeLines = new string[][] {
                    new string[] { "Market Trends", "& Analysis" },
                    new string[] { "Trade Data", "& Statistics" },
                    new string[] { "Industry", "Reports" },
                    new string[] { "Expert", "Perspectives" },
                    new string[] { "Global Trade", "Updates" }
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
                case 0: // Market Trends & Analysis (Bar chart with growth arrow)
                    float barW = s * 0.28f;
                    float baseBarY = cy + (s * 0.72f);
                    // Bar 1
                    g.FillRectangle(brush, cx - (s * 0.65f), baseBarY - (s * 0.45f), barW, s * 0.45f);
                    // Bar 2
                    g.FillRectangle(brush, cx - (s * 0.15f), baseBarY - (s * 0.8f), barW, s * 0.8f);
                    // Bar 3
                    g.FillRectangle(brush, cx + (s * 0.35f), baseBarY - (s * 1.15f), barW, s * 1.15f);
                    // Upward growth arrow
                    using (Pen arrPen = new Pen(col, 3.6f)) {
                        arrPen.StartCap = LineCap.Round;
                        arrPen.EndCap = LineCap.Round;
                        float ax1 = cx - (s * 0.75f);
                        float ay1 = cy + (s * 0.15f);
                        float ax2 = cx + (s * 0.75f);
                        float ay2 = cy - (s * 0.75f);
                        g.DrawLine(arrPen, ax1, ay1, ax2, ay2);
                        // Arrow head
                        g.DrawLine(arrPen, ax2, ay2, ax2 - (s * 0.35f), ay2);
                        g.DrawLine(arrPen, ax2, ay2, ax2, ay2 + (s * 0.35f));
                    }
                    break;

                case 1: // Trade Data & Statistics (Data Document with lines)
                    float dw = s * 1.0f;
                    float dh = s * 1.35f;
                    float dx = cx - (dw / 2f);
                    float dy = cy - (dh / 2f);
                    using (Pen docPen = new Pen(col, 3.8f)) {
                        docPen.LineJoin = LineJoin.Round;
                        // Document body with top-right corner notch
                        GraphicsPath docPath = new GraphicsPath();
                        docPath.AddLine(dx, dy, dx + dw - (s * 0.35f), dy);
                        docPath.AddLine(dx + dw, dy + (s * 0.35f), dx + dw, dy + dh);
                        docPath.AddLine(dx + dw, dy + dh, dx, dy + dh);
                        docPath.CloseFigure();
                        g.DrawPath(docPen, docPath);
                        // Fold line
                        g.DrawLine(docPen, dx + dw - (s * 0.35f), dy, dx + dw - (s * 0.35f), dy + (s * 0.35f));
                        g.DrawLine(docPen, dx + dw - (s * 0.35f), dy + (s * 0.35f), dx + dw, dy + (s * 0.35f));
                    }
                    // Data horizontal lines inside
                    using (Pen linePen = new Pen(col, 3.2f)) {
                        linePen.StartCap = LineCap.Round;
                        linePen.EndCap = LineCap.Round;
                        g.DrawLine(linePen, dx + (s * 0.25f), cy - (s * 0.15f), dx + dw - (s * 0.25f), cy - (s * 0.15f));
                        g.DrawLine(linePen, dx + (s * 0.25f), cy + (s * 0.15f), dx + dw - (s * 0.25f), cy + (s * 0.15f));
                        g.DrawLine(linePen, dx + (s * 0.25f), cy + (s * 0.45f), dx + dw - (s * 0.45f), cy + (s * 0.45f));
                    }
                    break;

                case 2: // Industry Reports (Analytics Chart with trend)
                    float ibarW = s * 0.28f;
                    float ibaseY = cy + (s * 0.72f);
                    // 3 analytics bars
                    g.FillRectangle(brush, cx - (s * 0.65f), ibaseY - (s * 0.5f), ibarW, s * 0.5f);
                    g.FillRectangle(brush, cx - (s * 0.15f), ibaseY - (s * 0.9f), ibarW, s * 0.9f);
                    g.FillRectangle(brush, cx + (s * 0.35f), ibaseY - (s * 1.15f), ibarW, s * 1.15f);
                    // Trend line with points
                    using (Pen trPen = new Pen(col, 3.4f)) {
                        trPen.StartCap = LineCap.Round;
                        trPen.EndCap = LineCap.Round;
                        PointF p1 = new PointF(cx - (s * 0.51f), ibaseY - (s * 0.65f));
                        PointF p2 = new PointF(cx - (s * 0.01f), ibaseY - (s * 1.05f));
                        PointF p3 = new PointF(cx + (s * 0.49f), ibaseY - (s * 1.3f));
                        g.DrawLine(trPen, p1, p2);
                        g.DrawLine(trPen, p2, p3);
                        float ptR = s * 0.12f;
                        g.FillEllipse(brush, p1.X - ptR, p1.Y - ptR, ptR * 2f, ptR * 2f);
                        g.FillEllipse(brush, p2.X - ptR, p2.Y - ptR, ptR * 2f, ptR * 2f);
                        g.FillEllipse(brush, p3.X - ptR, p3.Y - ptR, ptR * 2f, ptR * 2f);
                    }
                    break;

                case 3: // Expert Perspectives (3 People Group)
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

                case 4: // Global Trade Updates (Globe)
                    float gr = s * 0.95f;
                    g.DrawEllipse(pen, cx - gr, cy - gr, gr * 2f, gr * 2f);
                    g.DrawEllipse(pen, cx - (gr * 0.44f), cy - gr, gr * 0.88f, gr * 2f);
                    g.DrawLine(pen, cx - gr, cy, cx + gr, cy);
                    g.DrawLine(pen, cx - (gr * 0.82f), cy - (gr * 0.5f), cx + (gr * 0.82f), cy - (gr * 0.5f));
                    g.DrawLine(pen, cx - (gr * 0.82f), cy + (gr * 0.5f), cx + (gr * 0.82f), cy + (gr * 0.5f));
                    break;
            }
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$outPngs = @(
    "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.png",
    "c:\Users\Administrator\Pictures\emports and exports\images\insights_hero_banner.png"
)

$outJpgs = @(
    "c:\Users\Administrator\Pictures\emports and exports\images\insights_crop\insights_hero_banner.jpg",
    "c:\Users\Administrator\Pictures\emports and exports\images\insights_hero_banner.jpg"
)

$previewPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_insights_banner_preview.png"

Write-Host "Deploying Master 4K Insights Hero Banner across all targets..."
[InsightsMasterDeployer]::DeployAll($src1x, $fontSansPath, $outPngs, $outJpgs, $previewPath)
Write-Host "Insights Master Hero Banner deployed successfully!"
