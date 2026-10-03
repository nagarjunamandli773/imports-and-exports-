Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\.user_uploaded\media_1790522523566.png"
$fontSansPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ContactBannerDeployerV2 {
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

                    // 1. Draw upscaled base image (scenery, ship, sunset sky, plane, support agent, map, laptop, golden swoosh)
                    g.DrawImage(rawSrc, 0, 0, targetW, targetH);

                    // Load Plus Jakarta Sans font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    // 2. Clean out old blurry text regions with pure white fill
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                        // Eyebrow region
                        g.FillRectangle(whiteBrush, (int)(30f * scale), (int)(45f * scale), (int)(180f * scale), (int)(38f * scale));

                        // Heading region (We're Here to Connect With You)
                        g.FillRectangle(whiteBrush, (int)(30f * scale), (int)(84f * scale), (int)(345f * scale), (int)(80f * scale));

                        // Paragraph region
                        g.FillRectangle(whiteBrush, (int)(30f * scale), (int)(165f * scale), (int)(365f * scale), (int)(48f * scale));

                        // Badges region (circles and text down to top of swoosh)
                        g.FillRectangle(whiteBrush, (int)(20f * scale), (int)(214f * scale), (int)(418f * scale), (int)(88f * scale));
                    }

                    // Colors
                    Color navyDark = Color.FromArgb(255, 7, 37, 78);      // Deep Brand Navy #07254e
                    Color amberGold = Color.FromArgb(255, 235, 155, 22);   // Vibrant Golden Amber #eb9b16
                    Color slateBody = Color.FromArgb(255, 51, 65, 85);     // Slate Body #334155
                    Color slateMuted = Color.FromArgb(255, 100, 116, 139); // Slate Subtitle #64748b
                    Color dividerColor = Color.FromArgb(255, 226, 232, 240); // #e2e8f0

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
                            // Letter-spaced GET IN TOUCH
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

                        // Gold Pill Bar under "GET IN"
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

                        // 5. Paragraph: Clear, Visible Sentences
                        float paraFontSize = 9.8f * scale; // ~39.2px in 4K
                        float lineSpacing = 14.5f * scale;  // ~58px in 4K
                        float paraX = 35.5f * scale;
                        float paraY = 169.5f * scale;

                        using (Font fontReg = new Font(fam, paraFontSize, FontStyle.Regular, GraphicsUnit.Pixel))
                        using (Font fontBold = new Font(fam, paraFontSize, FontStyle.Bold, GraphicsUnit.Pixel)) {
                            // Line 1: Have a question, need support, or want to explore a partnership?
                            float curX = paraX;
                            float curY = paraY;
                            DrawWord(g, "Have a question, need support, or want to explore a partnership?", fontReg, slateBrush, ref curX, curY);

                            // Line 2: Our team at Concept Exim is always ready to assist you. Reach out to us —
                            curX = paraX;
                            curY += lineSpacing;
                            DrawWord(g, "Our team at ", fontReg, slateBrush, ref curX, curY);
                            DrawWord(g, "Concept Exim ", fontBold, navyBrush, ref curX, curY);
                            DrawWord(g, "is always ready to assist you. Reach out to us \u2014", fontReg, slateBrush, ref curX, curY);

                            // Line 3: your global trade journey matters to us.
                            curX = paraX;
                            curY += lineSpacing;
                            DrawWord(g, "your global trade journey matters to us.", fontReg, slateBrush, ref curX, curY);
                        }

                        // 6. Badges: 4 Vector-Drawn Icons + Ultra-Crisp Titles & Subtitles
                        float[] badgeCenters = { 71f * scale, 175.5f * scale, 281f * scale, 387f * scale };
                        float circleCenterY = 240f * scale;
                        float circleRadius = 19f * scale; // 76px in 4K

                        // Vertical divider lines between badges
                        float[] dividerXs = { 123f * scale, 228f * scale, 334f * scale };
                        foreach (float dx in dividerXs) {
                            g.DrawLine(dividerPen, dx, 246f * scale, dx, 286f * scale);
                        }

                        // Badge 1 Icon: Quick Response (Chat bubble with 3 dots)
                        {
                            float cx = badgeCenters[0];
                            float cy = circleCenterY;
                            g.FillEllipse(whiteBrush, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);
                            g.DrawEllipse(goldPen, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);

                            float bw = 15f * scale;
                            float bh = 11.5f * scale;
                            float bx = cx - bw / 2f;
                            float by = cy - bh / 2f - 1.2f * scale;
                            using (GraphicsPath path = new GraphicsPath()) {
                                float cr = 2.8f * scale;
                                path.AddArc(bx, by, cr * 2f, cr * 2f, 180f, 90f);
                                path.AddArc(bx + bw - cr * 2f, by, cr * 2f, cr * 2f, 270f, 90f);
                                path.AddArc(bx + bw - cr * 2f, by + bh - cr * 2f, cr * 2f, 2f * cr, 0f, 90f);
                                path.AddLine(bx + bw - cr * 2f, by + bh, bx + 4.5f * scale, by + bh);
                                path.AddLine(bx + 4.5f * scale, by + bh, bx + 2f * scale, by + bh + 3.2f * scale);
                                path.AddLine(bx + 2f * scale, by + bh + 3.2f * scale, bx + 3f * scale, by + bh);
                                path.AddArc(bx, by + bh - cr * 2f, cr * 2f, cr * 2f, 90f, 90f);
                                path.CloseFigure();
                                g.DrawPath(navyPen, path);
                            }
                            float dotR = 1.0f * scale;
                            g.FillEllipse(navyBrush, cx - 3.8f * scale - dotR, cy - 1.2f * scale - dotR, dotR * 2f, dotR * 2f);
                            g.FillEllipse(navyBrush, cx - dotR, cy - 1.2f * scale - dotR, dotR * 2f, dotR * 2f);
                            g.FillEllipse(navyBrush, cx + 3.8f * scale - dotR, cy - 1.2f * scale - dotR, dotR * 2f, dotR * 2f);
                        }

                        // Badge 2 Icon: Dedicated Support (3 People Team)
                        {
                            float cx = badgeCenters[1];
                            float cy = circleCenterY;
                            g.FillEllipse(whiteBrush, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);
                            g.DrawEllipse(goldPen, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);

                            // Center person head
                            g.FillEllipse(navyBrush, cx - 2.8f * scale, cy - 7.5f * scale, 5.6f * scale, 5.6f * scale);
                            // Center body
                            g.FillPie(navyBrush, cx - 6.2f * scale, cy - 0.5f * scale, 12.4f * scale, 12.4f * scale, 180f, 180f);

                            // Left person head
                            g.FillEllipse(navyBrush, cx - 7.8f * scale, cy - 5.2f * scale, 4.4f * scale, 4.4f * scale);
                            // Left body
                            g.FillPie(navyBrush, cx - 10.5f * scale, cy + 0.6f * scale, 9f * scale, 9f * scale, 180f, 180f);

                            // Right person head
                            g.FillEllipse(navyBrush, cx + 3.4f * scale, cy - 5.2f * scale, 4.4f * scale, 4.4f * scale);
                            // Right body
                            g.FillPie(navyBrush, cx + 1.5f * scale, cy + 0.6f * scale, 9f * scale, 9f * scale, 180f, 180f);
                        }

                        // Badge 3 Icon: Global Reach (Globe with grid lines)
                        {
                            float cx = badgeCenters[2];
                            float cy = circleCenterY;
                            g.FillEllipse(whiteBrush, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);
                            g.DrawEllipse(goldPen, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);

                            float gr = 7.5f * scale;
                            g.DrawEllipse(navyPen, cx - gr, cy - gr, gr * 2f, gr * 2f);
                            // Equator
                            g.DrawLine(navyPen, cx - gr, cy, cx + gr, cy);
                            // Latitude lines
                            g.DrawArc(navyPen, cx - gr + 1.2f * scale, cy - gr - 2.2f * scale, (gr - 1.2f * scale) * 2f, gr * 2f, 35f, 110f);
                            g.DrawArc(navyPen, cx - gr + 1.2f * scale, cy - gr + 4.5f * scale, (gr - 1.2f * scale) * 2f, gr * 2f, 215f, 110f);
                            // Central Meridian ellipse
                            g.DrawEllipse(navyPen, cx - gr * 0.45f, cy - gr, gr * 0.9f, gr * 2f);
                        }

                        // Badge 4 Icon: Trusted Partner (Shield with checkmark)
                        {
                            float cx = badgeCenters[3];
                            float cy = circleCenterY;
                            g.FillEllipse(whiteBrush, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);
                            g.DrawEllipse(goldPen, cx - circleRadius, cy - circleRadius, circleRadius * 2f, circleRadius * 2f);

                            // Symmetric shield
                            float sw = 14f * scale;
                            float sh = 16f * scale;
                            float sx = cx - sw / 2f;
                            float sy = cy - sh / 2f + 0.5f * scale;
                            using (GraphicsPath shield = new GraphicsPath()) {
                                shield.AddLine(sx, sy, sx + sw, sy);
                                shield.AddLine(sx + sw, sy, sx + sw, sy + sh * 0.42f);
                                
                                PointF pStartR = new PointF(sx + sw, sy + sh * 0.42f);
                                PointF pCtrl1R = new PointF(cx + sw * 0.42f, sy + sh * 0.72f);
                                PointF pCtrl2R = new PointF(cx + sw * 0.16f, sy + sh * 0.95f);
                                PointF pBottom = new PointF(cx, sy + sh);
                                shield.AddBezier(pStartR, pCtrl1R, pCtrl2R, pBottom);

                                PointF pCtrl1L = new PointF(cx - sw * 0.16f, sy + sh * 0.95f);
                                PointF pCtrl2L = new PointF(cx - sw * 0.42f, sy + sh * 0.72f);
                                PointF pEndL = new PointF(sx, sy + sh * 0.42f);
                                shield.AddBezier(pBottom, pCtrl1L, pCtrl2L, pEndL);

                                shield.CloseFigure();
                                g.FillPath(navyBrush, shield);
                            }

                            // White checkmark inside shield
                            using (Pen checkPen = new Pen(Color.White, 1.8f * scale)) {
                                checkPen.StartCap = LineCap.Round;
                                checkPen.EndCap = LineCap.Round;
                                checkPen.LineJoin = LineJoin.Round;
                                PointF p1 = new PointF(cx - 3.4f * scale, cy);
                                PointF p2 = new PointF(cx - 0.8f * scale, cy + 2.5f * scale);
                                PointF p3 = new PointF(cx + 3.8f * scale, cy - 2.0f * scale);
                                g.DrawLines(checkPen, new PointF[] { p1, p2, p3 });
                            }
                        }

                        // Badge Titles and Subtitles
                        float titleFontSize = 9.8f * scale; // ~39.2px in 4K
                        float subFontSize = 8.2f * scale;   // ~32.8px in 4K
                        using (Font fontTitle = new Font(fam, titleFontSize, FontStyle.Bold, GraphicsUnit.Pixel))
                        using (Font fontSub = new Font(fam, subFontSize, FontStyle.Regular, GraphicsUnit.Pixel)) {
                            StringFormat sfCenter = new StringFormat();
                            sfCenter.Alignment = StringAlignment.Center;
                            sfCenter.LineAlignment = StringAlignment.Near;

                            // Badge 1: Quick Response
                            float b1 = badgeCenters[0];
                            g.DrawString("Quick Response", fontTitle, navyBrush, new PointF(b1, 267f * scale), sfCenter);
                            g.DrawString("We reply within\n24 hours", fontSub, mutedBrush, new PointF(b1, 281.5f * scale), sfCenter);

                            // Badge 2: Dedicated Support
                            float b2 = badgeCenters[1];
                            g.DrawString("Dedicated Support", fontTitle, navyBrush, new PointF(b2, 267f * scale), sfCenter);
                            g.DrawString("From our expert team", fontSub, mutedBrush, new PointF(b2, 283.5f * scale), sfCenter);

                            // Badge 3: Global Reach
                            float b3 = badgeCenters[2];
                            g.DrawString("Global Reach", fontTitle, navyBrush, new PointF(b3, 267f * scale), sfCenter);
                            g.DrawString("Across 50+ countries", fontSub, mutedBrush, new PointF(b3, 283.5f * scale), sfCenter);

                            // Badge 4: Trusted Partner
                            float b4 = badgeCenters[3];
                            g.DrawString("Trusted Partner", fontTitle, navyBrush, new PointF(b4, 267f * scale), sfCenter);
                            g.DrawString("For your business growth", fontSub, mutedBrush, new PointF(b4, 283.5f * scale), sfCenter);
                        }
                    }
                }

                // Save Master 4K PNGs
                destBmp.Save(outPng1, ImageFormat.Png);
                destBmp.Save(outPng2, ImageFormat.Png);

                // Save JPEGs
                ImageCodecInfo jpegCodec = null;
                foreach (ImageCodecInfo codec in ImageCodecInfo.GetImageEncoders()) {
                    if (codec.MimeType == "image/jpeg") { jpegCodec = codec; break; }
                }
                if (jpegCodec != null) {
                    EncoderParameters ep = new EncoderParameters(1);
                    ep.Param[0] = new EncoderParameter(Encoder.Quality, 96L);
                    destBmp.Save(outJpg1, jpegCodec, ep);
                    destBmp.Save(outJpg2, jpegCodec, ep);
                }

                // Save high-resolution preview (1800px)
                int prevW = 1800;
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

    private static void DrawWord(Graphics g, string text, Font font, Brush brush, ref float curX, float y) {
        StringFormat sf = StringFormat.GenericTypographic;
        sf.FormatFlags |= StringFormatFlags.MeasureTrailingSpaces | StringFormatFlags.NoWrap;
        g.DrawString(text, font, brush, curX, y, sf);
        SizeF sz = g.MeasureString(text, font, new PointF(curX, y), sf);
        curX += sz.Width;
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$outPng1 = "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner.png"
$outPng2 = "c:\Users\Administrator\Pictures\emports and exports\images\contact_hero_banner.png"
$outJpg1 = "c:\Users\Administrator\Pictures\emports and exports\images\contact_crop\contact_hero_banner.jpg"
$outJpg2 = "c:\Users\Administrator\Pictures\emports and exports\images\contact_hero_banner.jpg"
$previewPath = "C:\Users\Administrator\.gemini\antigravity-ide\brain\9d8682ec-e00e-4217-b32c-8482d10fadfb\new_contact_user_banner_preview.png"

[ContactBannerDeployerV2]::Deploy($src, $fontSansPath, $outPng1, $outPng2, $outJpg1, $outJpg2, $previewPath, 4)
Write-Host "Contact Master 4K Hero Banner deployed successfully!"
