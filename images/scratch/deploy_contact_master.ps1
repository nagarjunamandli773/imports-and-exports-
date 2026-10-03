Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

# Save a copy as contact_hero_banner_user_1x.png
Copy-Item $src "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner_user_1x.png" -Force

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ContactMasterDeployer {
    public static void Deploy(string srcPath, string fontPath, string outPng1, string outPng2, string outJpg1, string outJpg2, string previewPath, int scale) {
        using (Bitmap rawSrc = new Bitmap(srcPath)) {
            int targetW = rawSrc.Width * scale;  // 4096
            int targetH = rawSrc.Height * scale; // 1364

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled base image
                    g.DrawImage(rawSrc, 0, 0, targetW, targetH);

                    // Load font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    // 2. Clean out old text regions with pure white fill
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        // Eyebrow
                        g.FillRectangle(whiteBrush, (int)(28f * scale), (int)(48f * scale), (int)(150f * scale), (int)(35f * scale));
                        // Heading Line 1
                        g.FillRectangle(whiteBrush, (int)(28f * scale), (int)(84f * scale), (int)(282f * scale), (int)(42f * scale));
                        DrawHorizontalFeather(g, (int)(310f * scale), (int)(84f * scale), (int)(18f * scale), (int)(42f * scale));
                        // Heading Line 2
                        g.FillRectangle(whiteBrush, (int)(28f * scale), (int)(125f * scale), (int)(355f * scale), (int)(40f * scale));
                        DrawHorizontalFeather(g, (int)(382f * scale), (int)(125f * scale), (int)(20f * scale), (int)(40f * scale));
                        // Paragraph
                        g.FillRectangle(whiteBrush, (int)(28f * scale), (int)(165f * scale), (int)(395f * scale), (int)(52f * scale));
                        DrawHorizontalFeather(g, (int)(420f * scale), (int)(165f * scale), (int)(18f * scale), (int)(52f * scale));
                        // Badges
                        g.FillRectangle(whiteBrush, (int)(20f * scale), (int)(214f * scale), (int)(418f * scale), (int)(88f * scale));
                        DrawHorizontalFeather(g, (int)(435f * scale), (int)(214f * scale), (int)(16f * scale), (int)(88f * scale));
                    }

                    // Colors
                    Color navyDark = Color.FromArgb(255, 7, 37, 78);       // #07254e
                    Color amberGold = Color.FromArgb(255, 235, 155, 22);   // #eb9b16
                    Color slateBody = Color.FromArgb(255, 45, 58, 76);     // #2D3A4C (bold, clear)
                    Color slateMuted = Color.FromArgb(255, 71, 85, 105);   // #475569 (crisp subtitle)
                    Color dividerColor = Color.FromArgb(255, 214, 222, 232); // #D6DEE8

                    using (SolidBrush navyBrush = new SolidBrush(navyDark))
                    using (SolidBrush goldBrush = new SolidBrush(amberGold))
                    using (SolidBrush slateBrush = new SolidBrush(slateBody))
                    using (SolidBrush mutedBrush = new SolidBrush(slateMuted))
                    using (Pen goldPen = new Pen(amberGold, 2.75f * scale))
                    using (Pen navyPen = new Pen(navyDark, 1.8f * scale))
                    using (Pen dividerPen = new Pen(dividerColor, 1.25f * scale))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.White))
                    {
                        navyPen.StartCap = LineCap.Round;
                        navyPen.EndCap = LineCap.Round;
                        navyPen.LineJoin = LineJoin.Round;

                        // 3. Eyebrow: GET IN TOUCH + Gold Pill Accent Bar
                        float eyebrowSize = 13.5f * scale; // ~54px in 4K
                        using (Font fontEyebrow = new Font(fam, eyebrowSize, FontStyle.Bold, GraphicsUnit.Pixel)) {
                            string eyebrowText = "GET IN TOUCH";
                            float eyeX = 36f * scale;
                            float eyeY = 56f * scale;
                            float charSpacing = 3.5f * scale;
                            StringFormat sfTypo = StringFormat.GenericTypographic;
                            sfTypo.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces | StringFormatFlags.NoWrap;

                            for (int i = 0; i < eyebrowText.Length; i++) {
                                string ch = eyebrowText.Substring(i, 1);
                                g.DrawString(ch, fontEyebrow, navyBrush, eyeX, eyeY, sfTypo);
                                SizeF sz = g.MeasureString(ch, fontEyebrow, new PointF(eyeX, eyeY), sfTypo);
                                eyeX += sz.Width + charSpacing;
                            }
                        }

                        // Gold Pill Bar
                        float barX = 36f * scale;
                        float barY = 77.5f * scale;
                        float barW = 68f * scale;
                        float barH = 2.8f * scale;
                        using (GraphicsPath pill = new GraphicsPath()) {
                            float pr = barH / 2f;
                            pill.AddArc(barX, barY, pr * 2f, pr * 2f, 90f, 180f);
                            pill.AddArc(barX + barW - pr * 2f, barY, pr * 2f, pr * 2f, 270f, 180f);
                            pill.CloseFigure();
                            g.FillPath(goldBrush, pill);
                        }

                        // 4. Main Heading: We're Here to / Connect With You
                        float headingSize = 34f * scale; // ~136px in 4K
                        using (Font fontHeading = new Font(fam, headingSize, FontStyle.Bold, GraphicsUnit.Pixel)) {
                            StringFormat sfTypo = StringFormat.GenericTypographic;
                            sfTypo.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces | StringFormatFlags.NoWrap;

                            float headX = 35f * scale;
                            float line1Y = 88f * scale;
                            float line2Y = 128.5f * scale;

                            g.DrawString("We're Here to", fontHeading, navyBrush, new PointF(headX, line1Y), sfTypo);
                            g.DrawString("Connect With You", fontHeading, goldBrush, new PointF(headX, line2Y), sfTypo);
                        }

                        // 5. Paragraph: BOLD, CLEAR, HIGH-CONTRAST SENTENCES
                        float paraFontSize = 10.8f * scale; // ~43.2px in 4K
                        float lineSpacing = 15.5f * scale;  // ~62px in 4K
                        float paraX = 35.5f * scale;
                        float paraY = 168.5f * scale;

                        using (Font fontBold = new Font(fam, paraFontSize, FontStyle.Bold, GraphicsUnit.Pixel)) {
                            string l1 = "Have a question, need support, or want to explore a partnership?";
                            string l2 = "Our team at Concept Exim is always ready to assist you. Reach out to us \u2014";
                            string l3 = "your global trade journey matters to us.";

                            g.DrawString(l1, fontBold, slateBrush, paraX, paraY);
                            g.DrawString(l2, fontBold, slateBrush, paraX, paraY + lineSpacing);
                            g.DrawString(l3, fontBold, slateBrush, paraX, paraY + lineSpacing * 2f);
                        }

                        // 6. 4 Badges with Gold Circles and Clear Vector Icons
                        float badgeDia = 30f * scale; // 120px in 4K
                        float badgeR = badgeDia / 2f;
                        float badgeCY = 236f * scale;
                        float titleFontSize = 9.6f * scale;
                        float subFontSize = 7.6f * scale;

                        using (Font fontBadgeTitle = new Font(fam, titleFontSize, FontStyle.Bold, GraphicsUnit.Pixel))
                        using (Font fontBadgeSub = new Font(fam, subFontSize, FontStyle.Bold, GraphicsUnit.Pixel)) {
                            StringFormat sfCenter = new StringFormat();
                            sfCenter.Alignment = StringAlignment.Center;
                            sfCenter.LineAlignment = StringAlignment.Near;

                            // Badge 1: Quick Response
                            float b1CX = 48f * scale;
                            DrawCircleBadge(g, b1CX, badgeCY, badgeR, goldPen, whiteBrush);
                            DrawChatBubbleIcon(g, b1CX, badgeCY, navyPen, scale);
                            DrawBadgeLabel(g, "Quick Response", "We reply within 24 hours", b1CX, badgeCY + badgeR + 7f * scale, fontBadgeTitle, fontBadgeSub, navyBrush, mutedBrush, sfCenter);

                            // Divider 1
                            float div1X = 112f * scale;
                            g.DrawLine(dividerPen, div1X, badgeCY - 16f * scale, div1X, badgeCY + 40f * scale);

                            // Badge 2: Dedicated Support
                            float b2CX = 160f * scale;
                            DrawCircleBadge(g, b2CX, badgeCY, badgeR, goldPen, whiteBrush);
                            DrawTeamIcon(g, b2CX, badgeCY, navyPen, scale);
                            DrawBadgeLabel(g, "Dedicated Support", "From our expert team", b2CX, badgeCY + badgeR + 7f * scale, fontBadgeTitle, fontBadgeSub, navyBrush, mutedBrush, sfCenter);

                            // Divider 2
                            float div2X = 224f * scale;
                            g.DrawLine(dividerPen, div2X, badgeCY - 16f * scale, div2X, badgeCY + 40f * scale);

                            // Badge 3: Global Reach
                            float b3CX = 268f * scale;
                            DrawCircleBadge(g, b3CX, badgeCY, badgeR, goldPen, whiteBrush);
                            DrawGlobeIcon(g, b3CX, badgeCY, navyPen, scale);
                            DrawBadgeLabel(g, "Global Reach", "Across 50+ countries", b3CX, badgeCY + badgeR + 7f * scale, fontBadgeTitle, fontBadgeSub, navyBrush, mutedBrush, sfCenter);

                            // Divider 3
                            float div3X = 332f * scale;
                            g.DrawLine(dividerPen, div3X, badgeCY - 16f * scale, div3X, badgeCY + 40f * scale);

                            // Badge 4: Trusted Partner
                            float b4CX = 376f * scale;
                            DrawCircleBadge(g, b4CX, badgeCY, badgeR, goldPen, whiteBrush);
                            DrawShieldCheckIcon(g, b4CX, badgeCY, navyPen, scale);
                            DrawBadgeLabel(g, "Trusted Partner", "For your business growth", b4CX, badgeCY + badgeR + 7f * scale, fontBadgeTitle, fontBadgeSub, navyBrush, mutedBrush, sfCenter);
                        }
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

    private static void DrawHorizontalFeather(Graphics g, int x, int y, int width, int height) {
        if (width <= 0) return;
        using (LinearGradientBrush lgb = new LinearGradientBrush(
            new Rectangle(x, y, width, height),
            Color.FromArgb(255, 255, 255, 255),
            Color.FromArgb(0, 255, 255, 255),
            LinearGradientMode.Horizontal)) {
            g.FillRectangle(lgb, x, y, width, height);
        }
    }

    private static void DrawCircleBadge(Graphics g, float cx, float cy, float r, Pen pen, Brush fill) {
        float d = r * 2f;
        g.FillEllipse(fill, cx - r, cy - r, d, d);
        g.DrawEllipse(pen, cx - r, cy - r, d, d);
    }

    private static void DrawBadgeLabel(Graphics g, string title, string sub, float cx, float topY, Font fontTitle, Font fontSub, Brush brushTitle, Brush brushSub, StringFormat sf) {
        g.DrawString(title, fontTitle, brushTitle, cx, topY, sf);
        SizeF sz = g.MeasureString(title, fontTitle);
        g.DrawString(sub, fontSub, brushSub, cx, topY + sz.Height * 0.85f, sf);
    }

    private static void DrawChatBubbleIcon(Graphics g, float cx, float cy, Pen pen, int scale) {
        float s = (float)scale;
        float rw = 12f * s;
        float rh = 9f * s;
        float rx = cx - rw / 2f;
        float ry = cy - rh / 2f - 1f * s;

        using (GraphicsPath path = new GraphicsPath()) {
            float rad = 2f * s;
            path.AddArc(rx, ry, rad * 2f, rad * 2f, 180f, 90f);
            path.AddArc(rx + rw - rad * 2f, ry, rad * 2f, rad * 2f, 270f, 90f);
            path.AddArc(rx + rw - rad * 2f, ry + rh - rad * 2f, rad * 2f, rad * 2f, 0f, 90f);
            path.AddLine(rx + rw - rad * 2f, ry + rh, rx + 4.5f * s, ry + rh);
            path.AddLine(rx + 4.5f * s, ry + rh, rx + 2f * s, ry + rh + 3f * s);
            path.AddLine(rx + 2f * s, ry + rh + 3f * s, rx + 2.5f * s, ry + rh);
            path.AddArc(rx, ry + rh - rad * 2f, rad * 2f, rad * 2f, 90f, 90f);
            path.CloseFigure();
            g.DrawPath(pen, path);
        }

        // Dots inside
        using (SolidBrush dotBrush = new SolidBrush(pen.Color)) {
            float dotR = 0.9f * s;
            g.FillEllipse(dotBrush, cx - 3.5f * s, cy - 1f * s, dotR * 2f, dotR * 2f);
            g.FillEllipse(dotBrush, cx - 0.9f * s, cy - 1f * s, dotR * 2f, dotR * 2f);
            g.FillEllipse(dotBrush, cx + 1.7f * s, cy - 1f * s, dotR * 2f, dotR * 2f);
        }
    }

    private static void DrawTeamIcon(Graphics g, float cx, float cy, Pen pen, int scale) {
        float s = (float)scale;
        using (SolidBrush brush = new SolidBrush(pen.Color)) {
            // Center head
            g.DrawEllipse(pen, cx - 2.8f * s, cy - 4.5f * s, 5.6f * s, 5.6f * s);
            // Center shoulder
            g.DrawArc(pen, cx - 5.5f * s, cy - 0.5f * s, 11f * s, 9f * s, 195f, 150f);

            // Left head
            g.FillEllipse(brush, cx - 6.5f * s, cy - 2.8f * s, 3.6f * s, 3.6f * s);
            g.DrawArc(pen, cx - 9.5f * s, cy + 0.5f * s, 6.5f * s, 6.5f * s, 180f, 120f);

            // Right head
            g.FillEllipse(brush, cx + 2.9f * s, cy - 2.8f * s, 3.6f * s, 3.6f * s);
            g.DrawArc(pen, cx + 3f * s, cy + 0.5f * s, 6.5f * s, 6.5f * s, 240f, 120f);
        }
    }

    private static void DrawGlobeIcon(Graphics g, float cx, float cy, Pen pen, int scale) {
        float s = (float)scale;
        float r = 5.8f * s;
        g.DrawEllipse(pen, cx - r, cy - r, r * 2f, r * 2f);
        g.DrawLine(pen, cx - r + 0.5f * s, cy, cx + r - 0.5f * s, cy);
        g.DrawEllipse(pen, cx - 2.8f * s, cy - r, 5.6f * s, r * 2f);
        g.DrawLine(pen, cx, cy - r + 0.5f * s, cx, cy + r - 0.5f * s);
    }

    private static void DrawShieldCheckIcon(Graphics g, float cx, float cy, Pen pen, int scale) {
        float s = (float)scale;
        float w = 5.6f * s;
        float topY = cy - 5.2f * s;
        using (GraphicsPath path = new GraphicsPath()) {
            path.AddLine(cx - w, topY, cx + w, topY);
            path.AddLine(cx + w, topY, cx + w, topY + 4f * s);
            path.AddBezier(cx + w, topY + 4f * s, cx + w, topY + 7.5f * s, cx + 2.5f * s, topY + 10f * s, cx, topY + 11.5f * s);
            path.AddBezier(cx, topY + 11.5f * s, cx - 2.5f * s, topY + 10f * s, cx - w, topY + 7.5f * s, cx - w, topY + 4f * s);
            path.CloseFigure();
            g.DrawPath(pen, path);
        }

        using (Pen checkPen = new Pen(pen.Color, pen.Width * 1.1f)) {
            checkPen.StartCap = LineCap.Round;
            checkPen.EndCap = LineCap.Round;
            g.DrawLine(checkPen, cx - 2.6f * s, cy + 0.6f * s, cx - 0.6f * s, cy + 2.6f * s);
            g.DrawLine(checkPen, cx - 0.6f * s, cy + 2.6f * s, cx + 3.2f * s, cy - 1.8f * s);
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies "System.Drawing"

$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\contact_hero_banner.png"
$preview = "C:\Users\Administrator\.gemini\antigravity-ide\brain\ea257d91-8612-4218-87dd-31accfd328b2\vector_contact_banner_perfect.png"

[ContactMasterDeployer]::Deploy($src, $fontSansPath, $outPng1, $outPng2, "", "", $preview, 4)
Write-Host "Contact Master Banner successfully deployed!"

# Update JPG fallbacks
Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile($outPng1)
$ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$b.Save("c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner.jpg", $codec, $ep)
$b.Save("c:\Users\Administrator\Pictures\emports and exports\images\contact_hero_banner.jpg", $codec, $ep)
$b.Dispose()
Write-Host "Contact JPEG fallbacks updated!"
