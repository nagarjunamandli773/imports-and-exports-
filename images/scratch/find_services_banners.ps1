Get-ChildItem -Path "images" -Recurse -Filter "*services_hero_banner*" | Select-Object FullName, Length, LastWriteTime
