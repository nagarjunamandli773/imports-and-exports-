Get-ChildItem -Path "images", "compliance.*" -Recurse -Filter "*compliance_hero_banner*" | Select-Object FullName, Length, LastWriteTime
Select-String -Path "compliance.html", "compliance.css" -Pattern "compliance_hero_banner", "compliance-hero" | Select-Object Path, LineNumber, Line
