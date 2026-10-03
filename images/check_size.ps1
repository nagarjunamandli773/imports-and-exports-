Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\Administrator\.gemini\antigravity-ide\brain\a586a637-359c-4b07-b22b-d173549ff3ff\.user_uploaded\media_1789365771431.jpg")
Write-Host "Width: $($img.Width) Height: $($img.Height)"
$img.Dispose()
