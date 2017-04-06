
$a = find-module *Azure*
$a | Sort-Object Author | Format-Table version, name, author,description
$a | where-object Author -EQ 'Microsoft Corporation'


find-module * | ? Author -eq "powershellTeam"

find-module -Includes DscResource 

find-module -DscResource xFirewall

find-module -tag 'Linux'