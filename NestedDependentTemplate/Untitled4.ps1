

param
(
    [string] $HostName = $(throw "HostName is required."),
    [string] $username,
    [string] $password,
    [string] $nanoName
)


New-Item -Path $PSScriptRoot\downloads -ItemType Directory -Force -Confirm:$false
Invoke-WebRequest -UseBasicParsing -Uri "https://win2016devops.blob.core.windows.net/armt/dockerfile?sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2016-12-31T14:21:11Z&st=2016-07-14T06:21:11Z&spr=https&sig=%2Fad6Mall1um1QM00h3MQ4GjFNzT8UchehimejynOAMo%3D" -OutFile $PSScriptRoot\downloads\dockerfile 
Invoke-WebRequest -UseBasicParsing -Uri "https://win2016devops.blob.core.windows.net/armt/lcm.ps1?sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2016-12-31T14:21:11Z&st=2016-07-14T06:21:11Z&spr=https&sig=%2Fad6Mall1um1QM00h3MQ4GjFNzT8UchehimejynOAMo%3D" -OutFile $PSScriptRoot\downloads\lcm.ps1 
Invoke-WebRequest -UseBasicParsing -Uri "https://win2016devops.blob.core.windows.net/armt/lcm1.ps1?sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2016-12-31T14:21:11Z&st=2016-07-14T06:21:11Z&spr=https&sig=%2Fad6Mall1um1QM00h3MQ4GjFNzT8UchehimejynOAMo%3D" -OutFile $PSScriptRoot\downloads\lcm1.ps1 


if (!(Get-NetFirewallRule | where {$_.Name -eq "Http"})) {
    New-NetFirewallRule -Name "Http" -DisplayName "Http" -Protocol tcp -LocalPort 80 -Action Allow -Enabled True
}

if (!(Get-NetFirewallRule | where {$_.Name -eq "Docker"})) {
    New-NetFirewallRule -Name "Docker" -DisplayName "Docker" -Protocol tcp -LocalPort 2375 -Action Allow -Enabled True
}

if (!(Get-NetFirewallRule | where {$_.Name -eq "SSH"})) {
    New-NetFirewallRule -Name "SSH" -DisplayName "SSH" -Protocol tcp -LocalPort 22 -Action Allow -Enabled True
}
if (!(Get-NetFirewallRule | where {$_.Name -eq "SQL"})) {
    New-NetFirewallRule -Name "SQL" -DisplayName "SQL" -Protocol tcp -LocalPort 1433 -Action Allow -Enabled True
}

#Install Windows Container feature before script below to skip its reboot cycle
if( (Get-WindowsFeature -Name containers) -eq $null )
{
    Install-WindowsFeature containers
}
#wget -uri https://aka.ms/tp5/Install-ContainerHost -OutFile c:\Install-ContainerHost.ps1
#powershell -NoProfile -ExecutionPolicy Bypass c:\install-ContainerHost.ps1 | out-null


if( (get-item -Path $env:windir\system32\dockerd.exe -force -ErrorAction SilentlyContinue) -eq $null )
{
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile $env:windir\system32\dockerd.exe -UseBasicParsing
}
if( (get-item -Path $env:windir\system32\docker.exe -force -ErrorAction SilentlyContinue) -eq $null )
{
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile $env:windir\system32\docker.exe -UseBasicParsing
}

 $envpath = [Environment]::GetEnvironmentVariable("path")
 if(($envpath.IndexOf("$env:windir\system32;") -eq -1) )
 {
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:windir\system32", [EnvironmentVariableTarget]::Machine)
}
else
{
    if(($envpath.IndexOf(";$env:windir\system32") -eq -1) )
    {
            [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:windir\system32", [EnvironmentVariableTarget]::Machine)
    }
}
if ((Get-Service -Name 'docker' -ErrorAction SilentlyContinue) -eq $null)
{
    dockerd --register-service
}
Start-Service docker -Confirm:$false
Get-Service docker
Install-PackageProvider containerImage -Force -ForceBootstrap -Verbose

$username = "$nanoName\$username"
$username
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential  $username, $pass
$soptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck 

$s = New-PSSession -ComputerName $env:computername -Credential $cred  -SessionOption $soptions

Invoke-Command -Session $s  -ScriptBlock {
    if ((Get-ContainerImage -Name WindowsServerCore) -eq $null)
    {
         Install-ContainerImage -Name WindowsServerCore | Out-Null
    }

} 
Restart-Service Docker | out-null
Invoke-Command -Session $s  -ScriptBlock { param($pathfiles)
   #docker pull microsoft/mssql-server-2014-express-windows
   Set-Location $pathfiles
   docker build -t sqlimage .
} -ArgumentList $PSScriptRoot\downloads


Restart-Service Docker | out-null

$cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName $HostName
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $cert.Thumbprint –Force
New-NetFirewallRule -DisplayName 'Windows Remote Management (HTTPS-In)' -Name 'Windows Remote Management (HTTPS-In)' -Profile Any -LocalPort 5986 -Protocol TCP
Restart-Service winrm

# Install Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))


#choco install -y docker-machine -version 0.7.0





