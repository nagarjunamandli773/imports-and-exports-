Add-Type -AssemblyName System.Drawing

$pfc = New-Object System.Drawing.Text.PrivateFontCollection
$fontPath = "c:\Users\Administrator\Pictures\emports and exports\images\PlusJakartaSans.ttf"
if (Test-Path $fontPath) {
    $pfc.AddFontFile($fontPath)
    Write-Host "Loaded font from $fontPath"
    $fontFamilyName = $pfc.Families[0].Name
    Write-Host "Font Family: $fontFamilyName"
} else {
    $fontFamilyName = "Segoe UI"
    Write-Host "Using Segoe UI"
}

$csharp = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class HighDpiServiceBanner {
    public static void GenerateBanner(string srcPath, string outPath, string fontPath, int scale) {
        using (Bitmap srcBmp = new Bitmap(srcPath)) {
            int targetW = srcBmp.Width * scale;
            int targetH = srcBmp.Height * scale;

            using (Bitmap destBmp = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb)) {
                using (Graphics g = Graphics.FromImage(destBmp)) {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw upscaled base banner
                    g.DrawImage(srcBmp, 0, 0, targetW, targetH);

                    // 2. We need to inpaint the navy blue card area on the left
                    // In 1x scale: X=0 to ~340, Y=0 to 148 (above the bottom curve)
                    // Let's create a smooth navy blue gradient brush matching the design:
                    // Top: #09203c, Middle: #03152d, Bottom: #021227
                    // Right edge smoothly fades into the port skyline (from X = 270*scale to 350*scale)
                    
                    int cardRightX = 355 * scale;
                    int fadeStartX = 265 * scale;
                    int fadeWidth = cardRightX - fadeStartX;

                    // Inpaint column by column with smooth alpha transition
                    // To preserve the bottom-left white curve and gold trim:
                    // Any pixel in src that is the white/gold bottom border is preserved!
                    
                    // First, sample the bottom boundary curve from srcBmp at 1x
                    int[] curveY = new int[srcBmp.Width];
                    for (int x = 0; x < srcBmp.Width; x++) {
                        curveY[x] = srcBmp.Height; // default
                        for (int y = srcBmp.Height - 1; y >= 0; y--) {
                            Color c = srcBmp.GetPixel(x, y);
                            // If it's the white page below or gold stroke
                            // Gold stroke has high R, high G, low B (e.g. R>170, G>130, B<90)
                            // White has R>235, G>235, B>235
                            if (c.R > 235 && c.G > 235 && c.B > 235) {
                                curveY[x] = y;
                            } else {
                                break;
                            }
                        }
                    }

                    // Draw smooth navy background over the text area
                    // Use a bitmap patch for the inpaint
                    using (Bitmap patch = new Bitmap(cardRightX, targetH, PixelFormat.Format32bppArgb)) {
                        for (int y = 0; y < targetH; y++) {
                            double yFrac = (double)y / targetH;
                            // Vertical navy gradient:
                            // Top (yFrac=0): #09213e
                            // Mid-top (yFrac=0.3): #041731
                            // Mid-bot (yFrac=0.7): #031329
                            // Bottom (yFrac=1.0): #020f20
                            int r = (int)(9 * (1.0 - yFrac) + 2 * yFrac);
                            int gr = (int)(33 * (1.0 - yFrac) + 15 * yFrac);
                            int b = (int)(62 * (1.0 - yFrac) + 32 * yFrac);

                            for (int x = 0; x < cardRightX; x++) {
                                int origSrcX = x / scale;
                                int origSrcY = y / scale;

                                // Check if we are above the bottom curve (do NOT paint over the white curve)
                                if (origSrcX < srcBmp.Width && origSrcY >= curveY[origSrcX] - 2) {
                                    continue; // leave bottom curve intact!
                                }

                                // Alpha fade at right edge
                                double alpha = 1.0;
                                if (x >= fadeStartX) {
                                    double f = (double)(x - fadeStartX) / fadeWidth;
                                    // Smooth cosine ease-out
                                    alpha = 0.5 * (1.0 + Math.Cos(f * Math.PI));
                                }

                                // Also feather top 2px
                                if (y < 2 * scale) {
                                    alpha *= (double)y / (2 * scale);
                                }

                                Color col = Color.FromArgb((int)(alpha * 255), r, gr, b);
                                patch.SetPixel(x, y, col);
                            }
                        }

                        // Blend patch onto destBmp
                        g.DrawImage(patch, 0, 0);
                    }

                    // 3. Load font
                    PrivateFontCollection pfc = new PrivateFontCollection();
                    if (!string.IsNullOrEmpty(fontPath) && System.IO.File.Exists(fontPath)) {
                        pfc.AddFontFile(fontPath);
                    }
                    FontFamily fam = pfc.Families.Length > 0 ? pfc.Families[0] : new FontFamily("Segoe UI");

                    // 4. Draw Typography
                    // Scale coordinates from master layout:
                    // Left margin: 38 * scale
                    float startX = 38f * scale;

                    // Eyebrow: OUR SERVICES
                    using (Font eyebrowFont = new Font(fam, 7.8f * scale, FontStyle.Bold))
                    using (SolidBrush goldBrush = new SolidBrush(Color.FromArgb(243, 202, 101))) {
                        // Letter-spaced draw
                        string eyebrowText = "O U R   S E R V I C E S";
                        g.DrawString(eyebrowText, eyebrowFont, goldBrush, startX, 15f * scale);
                    }

                    // Heading: End-to-End Trade (White)
                    using (Font titleFont = new Font(fam, 16.5f * scale, FontStyle.Bold))
                    using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush amberBrush = new SolidBrush(Color.FromArgb(244, 192, 74))) {
                        g.DrawString("End-to-End Trade", titleFont, whiteBrush, startX - (0.5f * scale), 27.5f * scale);
                        // Heading: Solutions (Gold)
                        g.DrawString("Solutions", titleFont, amberBrush, startX - (0.5f * scale), 46.5f * scale);
                    }

                    // Paragraph: 3 lines
                    using (Font descFont = new Font(fam, 6.1f * scale, FontStyle.Regular))
                    using (SolidBrush descBrush = new SolidBrush(Color.FromArgb(226, 237, 248))) {
                        string line1 = "From sourcing to delivery, we handle the complexities";
                        string line2 = "so you can focus on growth. Our comprehensive services";
                        string line3 = "ensure seamless, secure and efficient global trade.";

                        float lineSpacing = 8.8f * scale;
                        float descStartY = 70.5f * scale;
                        g.DrawString(line1, descFont, descBrush, startX, descStartY);
                        g.DrawString(line2, descFont, descBrush, startX, descStartY + lineSpacing);
                        g.DrawString(line3, descFont, descBrush, startX, descStartY + lineSpacing * 2);
                    }

                    // 5. Draw 4 Badges (Horizontal Row at Y ~ 103..132 in 1x scale)
                    float badgeY = 104f * scale;
                    float circleRadius = 10f * scale;
                    float circleDiam = circleRadius * 2;

                    float[] badgeX = new float[] {
                        38f * scale,
                        112f * scale,
                        185f * scale,
                        258f * scale
                    };

                    string[][] badgeTexts = new string[][] {
                        new string[] { "Global", "Network" },
                        new string[] { "Expert", "Support" },
                        new string[] { "Secure", "& Reliable" },
                        new string[] { "On-Time", "Delivery" }
                    };

                    using (Pen circlePen = new Pen(Color.FromArgb(235, 185, 75), 1.4f * scale))
                    using (SolidBrush circleFill = new SolidBrush(Color.FromArgb(50, 243, 202, 101)))
                    using (SolidBrush iconBrush = new SolidBrush(Color.FromArgb(250, 215, 120)))
                    using (Pen iconPen = new Pen(Color.FromArgb(250, 215, 120), 1.2f * scale))
                    using (Font badgeFont = new Font(fam, 5.2f * scale, FontStyle.Bold))
                    using (SolidBrush textWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                    using (SolidBrush textBlue = new SolidBrush(Color.FromArgb(215, 230, 246))) {
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
                            float tx = bx + circleDiam + (3.5f * scale);
                            g.DrawString(badgeTexts[i][0], badgeFont, textWhite, tx, badgeY + (1.5f * scale));
                            g.DrawString(badgeTexts[i][1], badgeFont, textBlue, tx, badgeY + (8.5f * scale));
                        }
                    }
                }

                destBmp.Save(outPath, ImageFormat.Png);
            }
        }
    }

    private static void DrawBadgeIcon(Graphics g, int index, float cx, float cy, float r, Pen pen, SolidBrush brush) {
        float s = r * 0.58f;
        switch (index) {
            case 0: // Globe
                g.DrawEllipse(pen, cx - s, cy - s, s * 2, s * 2);
                g.DrawLine(pen, cx - s, cy, cx + s, cy);
                g.DrawLine(pen, cx, cy - s, cx, cy + s);
                g.DrawEllipse(pen, cx - s * 0.45f, cy - s, s * 0.9f, s * 2);
                break;
            case 1: // Expert Support (Users)
                // Head
                float hr = s * 0.38f;
                g.FillEllipse(brush, cx - hr, cy - s * 0.85f, hr * 2, hr * 2);
                // Body
                GraphicsPath body = new GraphicsPath();
                body.AddArc(cx - s * 0.8f, cy - s * 0.1f, s * 1.6f, s * 1.4f, 190, 160);
                body.CloseFigure();
                g.FillPath(brush, body);
                // Star/sparkle badge on side
                g.FillEllipse(brush, cx + s * 0.35f, cy - s * 0.85f, s * 0.3f, s * 0.3f);
                break;
            case 2: // Secure & Reliable (Shield with check)
                GraphicsPath shield = new GraphicsPath();
                shield.AddLine(cx - s * 0.75f, cy - s * 0.8f, cx + s * 0.75f, cy - s * 0.8f);
                shield.AddLine(cx + s * 0.75f, cy - s * 0.8f, cx + s * 0.75f, cy + s * 0.1f);
                shield.AddBezier(cx + s * 0.75f, cy + s * 0.1f, cx + s * 0.5f, cy + s * 0.7f, cx, cy + s * 0.95f, cx, cy + s * 0.95f);
                shield.AddBezier(cx, cy + s * 0.95f, cx - s * 0.5f, cy + s * 0.7f, cx - s * 0.75f, cy + s * 0.1f, cx - s * 0.75f, cy + s * 0.1f);
                shield.CloseFigure();
                g.DrawPath(pen, shield);
                // Checkmark inside shield
                using (Pen checkPen = new Pen(brush.Color, pen.Width * 1.1f)) {
                    g.DrawLine(checkPen, cx - s * 0.4f, cy, cx - s * 0.05f, cy + s * 0.35f);
                    g.DrawLine(checkPen, cx - s * 0.05f, cy + s * 0.35f, cx + s * 0.45f, cy - s * 0.3f);
                }
                break;
            case 3: // On-Time Delivery (Clock)
                g.DrawEllipse(pen, cx - s * 0.85f, cy - s * 0.85f, s * 1.7f, s * 1.7f);
                // Clock ticks at 12, 3, 6, 9
                g.DrawLine(pen, cx, cy - s * 0.85f, cx, cy - s * 0.65f);
                g.DrawLine(pen, cx, cy + s * 0.65f, cx, cy + s * 0.85f);
                g.DrawLine(pen, cx - s * 0.85f, cy, cx - s * 0.65f, cy);
                g.DrawLine(pen, cx + s * 0.65f, cy, cx + s * 0.85f, cy);
                // Hands pointing to 10:10
                using (Pen handPen = new Pen(brush.Color, pen.Width * 1.1f)) {
                    g.DrawLine(handPen, cx, cy, cx - s * 0.35f, cy - s * 0.35f);
                    g.DrawLine(handPen, cx, cy, cx + s * 0.45f, cy - s * 0.2f);
                }
                break;
        }
    }
}
'@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing

$src = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\services_hero_banner.png"
$testOut = "c:\Users\Administrator\Pictures\emports and exports\images\services_crop\test_services_banner_4x.png"

[HighDpiServiceBanner]::GenerateBanner($src, $testOut, $fontPath, 4)
Write-Host "Generated test_services_banner_4x.png successfully!"
