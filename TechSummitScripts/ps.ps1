
Set-Location -Path "C:\gitrepo\docker\TechSummitScripts"

$i = Invoke-WebRequest https://api.github.com
$i
$i.GetType()
$i.Content
$i.Content.GetType()
$i.Content | get-member

$obj = $i.Content | ConvertFrom-Json
$obj
$obj.GetType()

$k = Invoke-RestMethod https://api.github.com
$k
$k.GetType()
$k | gm
$k | get-member repo*


$repo = irm https://api.github.com/repos/powershell/powershell
$repo
$repo | gm issue*

$issues  = irm https://api.github.com/repos/powershell/powershell/issues
$issues

. .\Get-Issues.ps1

$issues = Get-Issue -username powershell -Repo powershell
$issues.Count
$issues | gm
$issues | Sort-Object -Descending comments
$issues | Sort-Object -Descending comments | Format-Table comments, title
$issues | Sort-Object -Descending comments | Select-Object -First 10 | Format-Table comments, title