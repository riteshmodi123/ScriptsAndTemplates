$str = "Ritesh Modi"
$Task = Get-ScheduledTask -TaskName TestTask -ErrorAction SilentlyContinue
if($Task -eq $null)
{
    
    Write-Output "Creating scheduled task action ..."

    $scriptToExecute = $script:MyInvocation.MyCommand.Path


    $args = "& $($scriptToExecute) -str $str"
      #  $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "& 'c:\Run.ps1' -str 'Ritesh'"
      $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $args

        Write-Output "Creating scheduled task trigger..."
        $trigger = New-ScheduledTaskTrigger -AtLogOn

       # $trigger = New-ScheduledTaskTrigger -

        Write-Output "Registering script to re-run at next user logon..."
        Register-ScheduledTask -TaskName "TestTask" -Action $action -Trigger $trigger -RunLevel Highest -User system | Out-Null
}
else
{
    $script:MyInvocation.MyCommand.Path

    if((Test-Path -Path "c:\aa.txt") -eq $false)
    {
        new-item -Path "C:\aa.txt" -ItemType File -Value "Header" -Force
    }

    Add-Content -Path "C:\aa.txt" -Value ([DateTime]::Now )
    Add-Content -Path "C:\aa.txt" -Value ($str )
}