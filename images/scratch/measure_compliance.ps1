Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile("c:\Users\Administrator\Pictures\emports and exports\images\compliance_crop\compliance_hero_banner.png")

# Eyebrow: QUALITY & COMPLIANCE
# Title: Trusted Quality. Global Compliance.
# Paragraph
# 5 badges at bottom-left: Y ~ 110 to 145
# 4 badges on right: X ~ 730 to 980, Y ~ 90 to 135

Write-Host "Image size: $($b.Width) x $($b.Height)"

# Sample where the right capsule sits:
# In the right capsule at X=750..980, Y=105..135 there's a dark capsule with border
for ($x = 730; $x -lt 760; $x += 5) {
    Write-Host "X=$x, Y=115: $($b.GetPixel($x, 115))"
}

# Sample bottom wave at Y=145..152 across X=0..1019
Write-Host "Wave sample X=0: $($b.GetPixel(0, 145))"
Write-Host "Wave sample X=200: $($b.GetPixel(200, 150))"
Write-Host "Wave sample X=500: $($b.GetPixel(500, 152))"
Write-Host "Wave sample X=800: $($b.GetPixel(800, 152))"
Write-Host "Wave sample X=1018: $($b.GetPixel(1018, 152))"

$b.Dispose()
