Add-Type -AssemblyName System.Drawing

$user = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')

Write-Host "User image dimensions: $($user.Width) x $($user.Height)"

# Let's inspect the colors in the user image:
# 1. Left navy top, middle, bottom
Write-Host "Left Navy (x=50, y=20): $($user.GetPixel(50, 20))"
Write-Host "Left Navy (x=50, y=70): $($user.GetPixel(50, 70))"
Write-Host "Left Navy (x=50, y=120): $($user.GetPixel(50, 120))"

# 2. Text colors
Write-Host "Eyebrow 'PREMIUM QUALITY' (x=60, y=30): $($user.GetPixel(60, 30))"
Write-Host "Title 'Our' (white) (x=55, y=55): $($user.GetPixel(55, 55))"
Write-Host "Title 'Premium' (gold) (x=130, y=55): $($user.GetPixel(130, 55))"
Write-Host "Subtitle text (x=60, y=78): $($user.GetPixel(60, 78))"

# 3. Badges at bottom
Write-Host "Badge 1 circle ring (x=45, y=125): $($user.GetPixel(45, 125))"
Write-Host "Badge 1 icon (x=45, y=125): $($user.GetPixel(45, 125))"
Write-Host "Badge 1 title (x=65, y=120): $($user.GetPixel(65, 120))"

# 4. Gold bottom wave swoosh
Write-Host "Wave gold line (x=150, y=148): $($user.GetPixel(150, 148))"
Write-Host "Below wave at bottom left (x=20, y=150): $($user.GetPixel(20, 150))"

# 5. Right sky and ship
Write-Host "Sky above ship (x=600, y=25): $($user.GetPixel(600, 25))"
Write-Host "Ship hull (x=580, y=95): $($user.GetPixel(580, 95))"
Write-Host "Cranes (x=800, y=40): $($user.GetPixel(800, 40))"
Write-Host "Plane (x=700, y=25): $($user.GetPixel(700, 25))"
Write-Host "Water (x=600, y=145): $($user.GetPixel(600, 145))"

$user.Dispose()
