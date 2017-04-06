
param(
    [string] $dnsName,
    [string] $internalIP,
    [string] $publicIP,
    [string] $username,
    [string] $password,
    [string] $nanoName
)



$dnsName = $dnsName.Trim()
$dnsName
set-item WSMan:\localhost\Client\TrustedHosts -Value $dnsName -Concatenate  -Force -Confirm:$false
set-item WSMan:\localhost\Client\TrustedHosts -Value $publicIP -Concatenate -Force -Confirm:$false
set-item WSMan:\localhost\Client\TrustedHosts -Value $internalIP -Concatenate  -Force -Confirm:$false
Restart-Service winrm -Force -Confirm:$false

New-Item -Type Directory -Path 'C:\Program Files\docker\'  -Force -Confirm:$false
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile "C:\Program Files\docker\dockerd.exe" -UseBasicParsing
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile "C:\Program Files\docker\docker.exe" -UseBasicParsing
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\docker", [EnvironmentVariableTarget]::Machine)
$winrmPort = '5986'

$username = "$nanoName\$username"
$username
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential  $username, $pass
$soptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck 

$s = New-PSSession -ComputerName $dnsName -Credential $cred -port $winrmPort -SessionOption $soptions -UseSSL
$s
"Invoking command"
Invoke-Command -Session $s  -ScriptBlock {
Install-PackageProvider -Name  NanoServerPackage -Force -ForceBootstrap -Verbose
Get-Command -Module NanoServerPackage
Find-NanoServerPackage
Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package -Force -Verbose

} 

Copy-Item -ToSession $s -Path "C:\Program Files\docker\dockerd.exe"  -Destination $env:SystemRoot\system32\ -Force -Confirm:$false 
Copy-Item -ToSession $s -Path "C:\Program Files\docker\docker.exe"  -Destination $env:SystemRoot\system32\ -Force -Confirm:$false
Invoke-Command -Session $s  -ScriptBlock {
restart-computer -Force
} 

Start-Sleep -Seconds 500


$ss = New-PSSession -ComputerName $dnsName -Credential $cred -port $winrmPort -SessionOption $soptions -UseSSL

Invoke-Command -Session $ss  -ScriptBlock {
if ((Get-Service -Name 'docker' -ErrorAction SilentlyContinue) -eq $null)
{
    dockerd --register-service
}
Start-Service docker -Confirm:$false
Get-Service docker

Install-PackageProvider containerImage -Force -ForceBootstrap -Verbose
if ((Get-ContainerImage -Name NanoServer) -eq $null)
{
Install-ContainerImage -Name NanoServer | Out-Null
}
Restart-Service Docker | out-null
Get-ContainerImage
netsh advfirewall firewall add rule name="Docker daemon" dir=in action=allow protocol=TCP localport=2375
New-Item -ItemType File -Path "C:\ProgramData\docker\config\daemon.json" -Value '{"hosts":["tcp://0.0.0.0:2375", "npipe://"]}' -Force -Confirm:$false
Restart-Service docker

}