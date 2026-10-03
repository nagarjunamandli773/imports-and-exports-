$script = Get-Content 'c:\Users\Administrator\Pictures\emports and exports\images\scratch\gen_navy_home_banner.ps1' -Raw
$script = $script.Replace('home_hero_banner.png', 'scratch\prev_test.png')
Invoke-Expression $script
$item = Get-Item 'c:\Users\Administrator\Pictures\emports and exports\images\scratch\prev_test.png'
Write-Host "prev_test.png size: $($item.Length)"
