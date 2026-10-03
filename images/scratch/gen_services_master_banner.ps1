Add-Type -AssemblyName System.Drawing

$fontSans = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class MasterServicesHero {
    public static void GenerateMasterBanner(string srcPath, string outPng1, string outPng2, string fontSansPath, int scale) {
        using (Bitmap rawSrc = new Bitmap(srcPath)) {
            int rawW = rawSrc.Width;  // 1024
            int rawH = rawSrc.Height; // 152

            // =========================================================================
            // STEP 1: Inpaint "Your Global Trade Partner" and the gold swoosh
            // seamlessly on the 1x raw image using Laplace PDE diffusion
            // =========================================================================
            Bitmap cleanSrc = new Bitmap(rawW, rawH, PixelFormat.Format32bppArgb);
            using (Graphics gClean = Graphics.FromImage(cleanSrc)) {
                gClean.DrawImage(rawSrc, 0, 0);
            }

            int offsetX = 830;
            bool[,] mask = new bool[rawW, rawH];

            for (int y = 0; y < rawH; y++) {
                for (int x = offsetX; x < rawW; x++) {
                    int lx = x - offsetX;

                    // Strictly protect buildings: never mask skyscraper tops
                    if (lx <= 74 && y >= 104) continue;

                    Color c = rawSrc.GetPixel(x, y);

                    // 1. "Your" + ascenders & flourishes (lx: 60..145, y: 24..48)
                    bool inUpperText = (lx >= 60 && lx <= 145 && y >= 24 && y <= 48);
                    bool isUpperText = inUpperText && (
                        (c.R + c.G + c.B > 410) ||
                        (c.R > 130 && c.G > 140 && c.B > 155) ||
                        (c.R > 115 && c.G > 125 && c.B > 165)
                    );

                    // 2. "Global Trade" + loops (lx: 48..168, y: 44..76)
                    bool inMidText = (lx >= 48 && lx <= 168 && y >= 44 && y <= 76);
                    bool isMidText = inMidText && (
                        (c.R + c.G + c.B > 415) ||
                        (c.R > 130 && c.G > 140 && c.B > 155) ||
                        (c.R > 115 && c.G > 125 && c.B > 165) ||
                        (c.R > 150 && c.G > 145 && c.B > 140)
                    );

                    // 3. "Partner" (lx: 62..145, y: 72..98)
                    bool inLowerText = (lx >= 62 && lx <= 145 && y >= 72 && y <= 98);
                    bool isLowerText = inLowerText && (
                        (c.R + c.G + c.B > 415) ||
                        (c.R > 145 && c.G > 145 && c.B > 140) ||
                        (c.R > 165 && c.G > 160 && c.B > 130) ||
                        (c.R > 135 && c.G > 135 && c.B > 155)
                    );

                    // 4. Gold Swoosh underline flourish
                    double swooshY = 108.0 - (lx - 65.0) * 0.316;
                    bool isNearSwoosh = (lx >= 74 && lx <= 162 && Math.Abs(y - swooshY) <= 3.2);
                    bool isGold = isNearSwoosh && (
                        (c.R > 165 && c.G > 125 && c.B < 135 && (c.R - c.B) > 35) ||
                        (c.R > 185 && c.G > 145 && c.B < 145)
                    );

                    if (isUpperText || isMidText || isLowerText || isGold) {
                        mask[x, y] = true;
                    }
                }
            }

            // Dilate mask by 2px (circular kernel)
            bool[,] dilated = new bool[rawW, rawH];
            for (int y = 0; y < rawH; y++) {
                for (int x = offsetX; x < rawW; x++) {
                    int lx = x - offsetX;
                    if (lx <= 46 || (lx <= 74 && y >= 104) || y <= 21 || y >= 106 || lx >= 172) continue;

                    bool found = false;
                    for (int dy = -2; dy <= 2 && !found; dy++) {
                        for (int dx = -2; dx <= 2 && !found; dx++) {
                            if (dx * dx + dy * dy <= 5) {
                                int nx = x + dx;
                                int ny = y + dy;
                                if (nx >= offsetX && nx < rawW && ny >= 0 && ny < rawH) {
                                    if (mask[nx, ny]) found = true;
                                }
                            }
                        }
                    }
                    dilated[x, y] = found;
                }
            }

            // Inpaint dilated region using Laplace PDE diffusion
            double[,] rArr = new double[rawW, rawH];
            double[,] gArr = new double[rawW, rawH];
            double[,] bArr = new double[rawW, rawH];

            for (int y = 0; y < rawH; y++) {
                for (int x = 0; x < rawW; x++) {
                    Color c = rawSrc.GetPixel(x, y);
                    rArr[x, y] = c.R;
                    gArr[x, y] = c.G;
                    bArr[x, y] = c.B;
                }
            }

            for (int iter = 0; iter < 450; iter++) {
                for (int y = 22; y < 106; y++) {
                    for (int x = offsetX + 47; x < offsetX + 172 && x < rawW - 1; x++) {
                        if (dilated[x, y]) {
                            double avgR = (rArr[x - 1, y] + rArr[x + 1, y] + rArr[x, y - 1] + rArr[x, y + 1]) * 0.25;
                            double avgG = (gArr[x - 1, y] + gArr[x + 1, y] + gArr[x, y - 1] + gArr[x, y + 1]) * 0.25;
                            double avgB = (bArr[x - 1, y] + bArr[x + 1, y] + bArr[x, y - 1] + bArr[x, y + 1]) * 0.25;

                            rArr[x, y] = avgR;
                            gArr[x, y] = avgG;
                            bArr[x, y] = avgB;
                        }
                    }
                }
            }

            Random rand = new Random(31415);
            for (int y = 0; y < rawH; y++) {
                for (int x = offsetX; x < rawW; x++) {
                    if (dilated[x, y]) {
                        int grain = rand.Next(-1, 2);
                        int r = Math.Max(0, Math.Min(255, (int)Math.Round(rArr[x, y] + grain)));
                        int g = Math.Max(0, Math.Min(255, (int)Math.Round(gArr[x, y] + grain)));
                        int b = Math.Max(0, Math.Min(255, (int)Math.Round(bArr[x, y] + grain)));
                        cleanSrc.SetPixel(x, y, Color.FromArgb(r, g, b));
                    }
                }
            }

            // =========================================================================
            // STEP 2: Render 4K Master Banner (Scale = 4)
            // Dimensions: 4096 x 608
            // =========================================================================
            int targetW = rawW * scale;
            int targetH = rawH * scale;

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled base photo panorama (cleaned, NO quote!)
                    g.DrawImage(cleanSrc, 0, 0, targetW, targetH);

                    // 2. Define the smooth bottom-left curve points
                    PointF[] curvePoints = new PointF[] {
                        new PointF(0 * scale, 105f * scale),
                        new PointF(18f * scale, 122f * scale),
                        new PointF(40f * scale, 135f * scale),
                        new PointF(66f * scale, 142f * scale),
                        new PointF(92f * scale, 147.5f * scale),
                        new PointF(105f * scale, 149.0f * scale)
                    };

                    // 3. Inpaint left text zone with rich, vibrant corporate Maritime NAVY BLUE
                    // Strictly NO black! True corporate maritime navy: #184078 -> #133462 -> #0f284e -> #0b2042
                    int cardRightX = 425 * scale;
                    int fadeStartX = 345 * scale;
                    float fadeWidth = (float)(cardRightX - fadeStartX);

                    using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                        using (Graphics pg = Graphics.FromImage(patch)) {
                            pg.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            pg.SmoothingMode = SmoothingMode.HighQuality;

                            // Fill with rich vertical Navy Blue gradient
                            using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                                new Rectangle(0, 0, cardRightX, targetH),
                                Color.FromArgb(255, 24, 64, 120),
                                Color.FromArgb(255, 11, 32, 66),
                                LinearGradientMode.Vertical)) {

                                ColorBlend cb = new ColorBlend(4);
                                cb.Positions = new float[] { 0f, 0.28f, 0.70f, 1f };
                                cb.Colors = new Color[] {
                                    Color.FromArgb(255, 24, 64, 120),  // #184078 rich royal maritime navy at top
                                    Color.FromArgb(255, 19, 52, 98),   // #133462 mid navy
                                    Color.FromArgb(255, 15, 40, 78),   // #0f284e deep navy
                                    Color.FromArgb(255, 11, 32, 66)    // #0b2042 base navy, zero black!
                                };
                                bgBrush.InterpolationColors = cb;
                                pg.FillRectangle(bgBrush, 0, 0, cardRightX, targetH);
                            }

                            // Subtle luminous blue depth accent in upper-left
                            using (GraphicsPath glowPath = new GraphicsPath()) {
                                glowPath.AddEllipse(-40 * scale, -20 * scale, 360 * scale, 220 * scale);
                                using (PathGradientBrush pgb = new PathGradientBrush(glowPath)) {
                                    pgb.CenterColor = Color.FromArgb(55, 45, 115, 195);
                                    pgb.SurroundColors = new Color[] { Color.FromArgb(0, 15, 40, 80) };
                                    pg.FillPath(pgb, glowPath);
                                }
                            }

                            // Smooth cosine fade into the sunset port / ship center
                            for (int y = 0; y < targetH; y++) {
                                for (int x = fadeStartX; x < cardRightX; x++) {
                                    float f = (float)(x - fadeStartX) / fadeWidth;
                                    float alpha = 0.5f * (1f + (float)Math.Cos(f * Math.PI));
                                    Color orig = patch.GetPixel(x, y);
                                    patch.SetPixel(x, y, Color.FromArgb((int)(orig.A * alpha), orig.R, orig.G, orig.B));
                                }
                            }
                        }

                        // Clip drawing so it stays strictly ABOVE the bottom-left curve
                        GraphicsPath clipPath = new GraphicsPath();
                        clipPath.AddLine(0, 0, cardRightX, 0);
                        clipPath.AddLine(cardRightX, 0, cardRightX, targetH);
                        clipPath.AddLine(cardRightX, targetH, 105f * scale, targetH);
                        PointF[] revPoints = new PointF[curvePoints.Length];
                        for (int i = 0; i < curvePoints.Length; i++) {
                            revPoints[i] = curvePoints[curvePoints.Length - 1 - i];
                        }
                        clipPath.AddCurve(revPoints, 0.45f);
                        clipPath.AddLine(0, 105f * scale, 0, 0);
                        clipPath.CloseFigure();

                        Region oldClip = g.Clip;
                        g.SetClip(clipPath);
                        g.DrawImage(patch, 0, 0);
                        g.Clip = oldClip;
                    }

                    // 4. Fill bottom-left corner below the curve with pure white
                    GraphicsPath whiteCornerPath = new GraphicsPath();
                    whiteCornerPath.AddCurve(curvePoints, 0.45f);
                    whiteCornerPath.AddLine(105f * scale, targetH, 0, targetH);
                    whiteCornerPath.AddLine(0, targetH, 0, 105f * scale);
                    whiteCornerPath.CloseFigure();

                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        g.FillPath(whiteBrush, whiteCornerPath);
                    }

                    // Draw golden curved border stroke along the curve
                    using (Pen goldOuter = new Pen(Color.FromArgb(238, 178, 48), 2.5f * scale)) {
                        goldOuter.StartCap = LineCap.Round;
                        goldOuter.EndCap = LineCap.Round;
                        g.DrawCurve(goldOuter, curvePoints, 0.45f);
                    }
                    using (Pen goldInner = new Pen(Color.FromArgb(255, 225, 120), 1.1f * scale)) {
                        g.DrawCurve(goldInner, curvePoints, 0.45f);
                    }

                    // 5. Load brand font Plus Jakarta Sans
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontSansPath) && System.IO.File.Exists(fontSansPath)) {
                        pfc.AddFontFile(fontSansPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    // 6. Draw Typography (Ultra-crisp ClearType)
                    float startX = 38f * scale;

                    // Eyebrow: OUR SERVICES (Gold, bold uppercase, letter-spaced)
                    using (Font eyebrowFont = new Font(fam, 7.3f * scale, FontStyle.Bold))
                    using (SolidBrush goldEyebrow = new SolidBrush(Color.FromArgb(243, 202, 101))) {
                        DrawSpacedString(g, "OUR SERVICES", eyebrowFont, goldEyebrow, startX, 13.5f * scale, 1.4f * scale);
                    }

                    // Heading: End-to-End Trade (Pure White) & Solutions (Radiant Gold)
                    using (Font titleFont = new Font(fam, 20.2f * scale, FontStyle.Bold))
                    using (SolidBrush whiteTitle = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush goldTitle = new SolidBrush(Color.FromArgb(246, 206, 104))) {
                        g.DrawString("End-to-End Trade", titleFont, whiteTitle, startX - (0.5f * scale), 23.5f * scale);
                        g.DrawString("Solutions", titleFont, goldTitle, startX - (0.5f * scale), 45.5f * scale);
                    }

                    // Paragraph: 3 sentences in high-contrast Ice-White
                    using (Font descFont = new Font(fam, 6.0f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(235, 242, 252))) {
                        string l1 = "From sourcing to delivery, we handle the complexities";
                        string l2 = "so you can focus on growth. Our comprehensive services";
                        string l3 = "ensure seamless, secure and efficient global trade.";

                        float lineSpacing = 8.6f * scale;
                        float descStartY = 72.5f * scale;
                        g.DrawString(l1, descFont, descBrush, startX, descStartY);
                        g.DrawString(l2, descFont, descBrush, startX, descStartY + lineSpacing);
                        g.DrawString(l3, descFont, descBrush, startX, descStartY + lineSpacing * 2);
                    }

                    // 7. Draw 4 Feature Badges (Horizontal Row at Y ~ 103..133 in 1x scale)
                    float badgeY = 103f * scale;
                    float circleRadius = 10.2f * scale;
                    float circleDiam = circleRadius * 2f;

                    float[] badgeX = new float[] {
                        40f * scale,
                        116f * scale,
                        191f * scale,
                        266f * scale
                    };

                    string[][] badgeTexts = new string[][] {
                        new string[] { "Global", "Network" },
                        new string[] { "Expert", "Support" },
                        new string[] { "Secure", "& Reliable" },
                        new string[] { "On-Time", "Delivery" }
                    };

                    using (Pen circlePen = new Pen(Color.FromArgb(238, 188, 72), 1.4f * scale))
                    using (SolidBrush circleFill = new SolidBrush(Color.FromArgb(55, 243, 202, 101)))
                    using (SolidBrush iconBrush = new SolidBrush(Color.FromArgb(250, 218, 125)))
                    using (Pen iconPen = new Pen(Color.FromArgb(250, 218, 125), 1.2f * scale))
                    using (Font badgeFont = new Font(fam, 5.25f * scale, FontStyle.Bold))
                    using (SolidBrush textWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush textBlue = new SolidBrush(Color.FromArgb(220, 235, 250))) {
                        for (int i = 0; i < 4; i++) {
                            float bx = badgeX[i];
                            float cy = badgeY + circleRadius;
                            float cx = bx + circleRadius;

                            // Draw circle
                            g.FillEllipse(circleFill, bx, badgeY, circleDiam, circleDiam);
                            g.DrawEllipse(circlePen, bx, badgeY, circleDiam, circleDiam);

                            // Draw Icon inside circle
                            DrawBadgeIcon(g, i, cx, cy, circleRadius, iconPen, iconBrush);

                            // Draw 2-line text beside circle
                            float tx = bx + circleDiam + (3.4f * scale);
                            g.DrawString(badgeTexts[i][0], badgeFont, textWhite, tx, badgeY + (1.2f * scale));
                            g.DrawString(badgeTexts[i][1], badgeFont, textBlue, tx, badgeY + (8.2f * scale));
                        }
                    }
                }

                // Save to target outputs
                destBmp.Save(outPng1, ImageFormat.Png);
                if (!string.IsNullOrEmpty(outPng2)) {
                    destBmp.Save(outPng2, ImageFormat.Png);
                }
            }

            cleanSrc.Dispose();
        }
    }

    private static void DrawSpacedString(Graphics g, string text, Font font, Brush brush, float x, float y, float extraSpacing) {
        float currentX = x;
        foreach (char c in text) {
            string s = c.ToString();
            g.DrawString(s, font, brush, currentX, y);
            SizeF size = g.MeasureString(s, font);
            currentX += size.Width - (font.Size * 0.18f) + extraSpacing;
        }
    }

    private static void DrawBadgeIcon(Graphics g, int index, float cx, float cy, float r, Pen pen, SolidBrush brush) {
        float s = r * 0.58f;
        switch (index) {
            case 0: // Globe
                g.DrawEllipse(pen, cx - s, cy - s, s * 2, s * 2);
                g.DrawLine(pen, cx - s, cy, cx + s, cy);
                g.DrawLine(pen, cx, cy - s, cx, cy + s);
                g.DrawEllipse(pen, cx - s * 0.46f, cy - s, s * 0.92f, s * 2);
                break;
            case 1: // Expert Support (Team silhouette: center user + 2 side users)
                float chr = s * 0.32f;
                g.FillEllipse(brush, cx - chr, cy - s * 0.85f, chr * 2, chr * 2);
                GraphicsPath cBody = new GraphicsPath();
                cBody.AddArc(cx - s * 0.55f, cy - s * 0.1f, s * 1.1f, s * 1.2f, 200, 140);
                cBody.CloseFigure();
                g.FillPath(brush, cBody);

                float lhr = s * 0.23f;
                g.FillEllipse(brush, cx - s * 0.70f - lhr, cy - s * 0.55f, lhr * 2, lhr * 2);
                GraphicsPath lBody = new GraphicsPath();
                lBody.AddArc(cx - s * 0.95f, cy + s * 0.05f, s * 0.65f, s * 0.8f, 200, 140);
                lBody.CloseFigure();
                g.FillPath(brush, lBody);

                g.FillEllipse(brush, cx + s * 0.70f - lhr, cy - s * 0.55f, lhr * 2, lhr * 2);
                GraphicsPath rBody = new GraphicsPath();
                rBody.AddArc(cx + s * 0.30f, cy + s * 0.05f, s * 0.65f, s * 0.8f, 200, 140);
                rBody.CloseFigure();
                g.FillPath(brush, rBody);
                break;
            case 2: // Secure & Reliable (Shield with checkmark)
                GraphicsPath shield = new GraphicsPath();
                shield.AddLine(cx - s * 0.72f, cy - s * 0.80f, cx + s * 0.72f, cy - s * 0.80f);
                shield.AddLine(cx + s * 0.72f, cy - s * 0.80f, cx + s * 0.72f, cy + s * 0.10f);
                shield.AddBezier(cx + s * 0.72f, cy + s * 0.10f, cx + s * 0.50f, cy + s * 0.70f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                shield.AddBezier(cx, cy + s * 0.95f, cx - s * 0.50f, cy + s * 0.70f, cx - s * 0.72f, cy + s * 0.10f, cx - s * 0.72f, cy + s * 0.10f);
                shield.CloseFigure();
                g.DrawPath(pen, shield);

                using (Pen checkPen = new Pen(brush.Color, pen.Width * 1.25f)) {
                    checkPen.StartCap = LineCap.Round;
                    checkPen.EndCap = LineCap.Round;
                    g.DrawLine(checkPen, cx - s * 0.35f, cy + s * 0.05f, cx - s * 0.05f, cy + s * 0.38f);
                    g.DrawLine(checkPen, cx - s * 0.05f, cy + s * 0.38f, cx + s * 0.42f, cy - s * 0.25f);
                }
                break;
            case 3: // On-Time Delivery (Stopwatch / Clock)
                g.DrawEllipse(pen, cx - s * 0.80f, cy - s * 0.80f, s * 1.6f, s * 1.6f);
                for (int a = 0; a < 8; a++) {
                    double rad = a * Math.PI / 4.0;
                    float tx1 = cx + (float)(Math.Cos(rad) * s * 0.80f);
                    float ty1 = cy + (float)(Math.Sin(rad) * s * 0.80f);
                    float tx2 = cx + (float)(Math.Cos(rad) * s * 0.95f);
                    float ty2 = cy + (float)(Math.Sin(rad) * s * 0.95f);
                    g.DrawLine(pen, tx1, ty1, tx2, ty2);
                }
                using (Pen handPen = new Pen(brush.Color, pen.Width * 1.15f)) {
                    handPen.StartCap = LineCap.Round;
                    handPen.EndCap = LineCap.Round;
                    g.DrawLine(handPen, cx, cy, cx - s * 0.36f, cy - s * 0.36f);
                    g.DrawLine(handPen, cx, cy, cx + s * 0.44f, cy - s * 0.22f);
                }
                break;
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\c8e02fdf-c3e0-4936-9538-312b39b3e2f8\.user_uploaded\media_1790300743947.png"
$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\services_hero_banner.png"

[MasterServicesHero]::GenerateMasterBanner($src, $outPng1, $outPng2, $fontSans, 4)
Write-Host "Generated Master Services Banner WITHOUT quotation in rich Navy Blue and White successfully!"
