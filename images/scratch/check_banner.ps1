Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile('C:\Users\Administrator\.gemini\antigravity-ide\brain\9fcb4606-3501-46e5-a251-c5bfc6304003\.user_uploaded\media_1790449157481.png')
Write-Host "Uploaded banner Width: $($b.Width) Height: $($b.Height)"
$b.Dispose()
