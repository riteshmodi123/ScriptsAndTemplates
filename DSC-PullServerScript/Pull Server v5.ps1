$cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName DevDSCPull

$ComputerName = "Localhost"
$PowershellRootFeatureName = "PowershellRoot" 
$Powershell4FeatureName = "Powershell" 
$PowershellISEFeatureName = "Powershell-ISE" 
$IISWindowsFeature = "Web-Server"
$NET35WindowsFeature = "NET-Framework-Features"
$NET45WindowsFeature = "NET-Framework-45-Features"
$ODataWindowsFeature = "ManagementOData"
$DSCWindowsFeatureName = "DSC-Service"


$PULLServerWebDirectory = "C:\PSDSCPullServer"
$PULLServerSubDirectory = "bin"
$iisAppPoolName = "DSCPullServer"
$iisAppPoolDotNetVersion = "v4.0"
$iisAppName = "PSDSCPullServer"
$port = "9100"
$certificateThumbPrint = $cert.Thumbprint



Install-WindowsFeature -Name $PowershellRootFeatureName -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $Powershell4FeatureName -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $PowershellISEFeatureName -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $IISWindowsFeature -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $NET35WindowsFeature -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $NET45WindowsFeature -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $ODataWindowsFeature -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName
Install-WindowsFeature -Name $DSCWindowsFeatureName -IncludeManagementTools -IncludeAllSubFeature -ComputerName $ComputerName

New-item -Path $PULLServerWebDirectory -ItemType Directory -Force
New-item -Path $($PULLServerWebDirectory + "\" + $PULLServerSubDirectory) -ItemType Directory -Force

Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\Global.asax" `
          -Destination "$PULLServerWebDirectory\Global.asax"
Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\PSDSCPullServer.mof" `
          -Destination "$PULLServerWebDirectory\PSDSCPullServer.mof"
Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\PSDSCPullServer.svc" `
          -Destination "$PULLServerWebDirectory\PSDSCPullServer.svc"
Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\PSDSCPullServer.xml" `
          -Destination "$PULLServerWebDirectory\PSDSCPullServer.xml"
Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\PSDSCPullServer.config" `
          -Destination "$PULLServerWebDirectory\web.config"

Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\IISSelfSignedCertModule.dll" `
    -Destination "$($PULLServerWebDirectory + "\" + $PULLServerSubDirectory + "\IISSelfSignedCertModule.dll")"

Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\Microsoft.Powershell.DesiredStateConfiguration.Service.dll" `
    -Destination "$($PULLServerWebDirectory + "\" + $PULLServerSubDirectory + "\Microsoft.Powershell.DesiredStateConfiguration.Service.dll")"



$siteID = ((Get-Website | % { $_.Id } | Measure-Object -Maximum).Maximum + 1)
$null = New-WebAppPool -Name $iisAppPoolName

$appPoolItem = Get-Item IIS:\AppPools\$iisAppPoolName
    $appPoolItem.managedRuntimeVersion = "v4.0"
    $appPoolItem.enable32BitAppOnWin64 = $true
    $appPoolItem.processModel.identityType = 0
    $appPoolItem | Set-Item

$webSite = New-WebSite -Name $iisAppName -Id $siteID -Port $port -IPAddress "*" -PhysicalPath $PULLServerWebDirectory -ApplicationPool $iisAppPoolName -Ssl

        # Remove existing binding for $port
Remove-Item IIS:\SSLBindings\0.0.0.0!$port -ErrorAction Ignore

        # Create a new binding using the supplied certificate
$null = Get-Item CERT:\LocalMachine\MY\$certificateThumbPrint | New-Item IIS:\SSLBindings\0.0.0.0!$port

  
Start-Website -Name $iisAppName




$appcmd = "$env:windir\system32\inetsrv\appcmd.exe" 

& $appCmd set AppPool $appPoolItem.name /processModel.identityType:LocalSystem
& $appCmd unlock config -section:access
& $appCmd unlock config -section:anonymousAuthentication
& $appCmd unlock config -section:basicAuthentication
& $appCmd unlock config -section:windowsAuthentication


Copy-Item -Path "$pshome\modules\psdesiredstateconfiguration\pullserver\Devices.mdb" `
          -Destination "$env:programfiles\WindowsPowerShell\DscService\Devices.mdb"

New-Item -ItemType File -Value $([guid]::NewGuid()) -Path "C:\Program Files\WindowsPowerShell\DscService" -Name "RegistrationKeys.txt"

  $xml = [XML](Get-Content "$PULLServerWebDirectory\web.config")                                                                                   
  $RootDoc = $xml.get_DocumentElement()                                                                                                                          
  $subnode = $xml.CreateElement("add")  
  $subnode.SetAttribute("key", "dbprovider")                                                                                                                    
  $subnode.SetAttribute("value", "System.Data.OleDb")                                                                                                                    
  $RootDoc.appSettings.AppendChild($subnode) 
  
  $subnode = $xml.CreateElement("add")  
  $subnode.SetAttribute("key", "dbconnectionstr")                                                                                                                    
  $subnode.SetAttribute("value", "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files\WindowsPowerShell\DscService\Devices.mdb;")                                                                                                                    
  $RootDoc.appSettings.AppendChild($subnode) 

  $subnode = $xml.CreateElement("add")  
  $subnode.SetAttribute("key", "ConfigurationPath")                                                                                                                    
  $subnode.SetAttribute("value", "C:\Program Files\WindowsPowerShell\DscService\Configuration")                                                                                                                    
  $RootDoc.appSettings.AppendChild($subnode) 

  $subnode = $xml.CreateElement("add")  
  $subnode.SetAttribute("key", "ModulePath")                                                                                                                    
  $subnode.SetAttribute("value", "C:\Program Files\WindowsPowerShell\DscService\Modules")                                                                                                                    
  $RootDoc.appSettings.AppendChild($subnode) 

  $subnode = $xml.CreateElement("add")  
  $subnode.SetAttribute("key", "RegistrationKeyPath")                                                                                                                    
  $subnode.SetAttribute("value", "C:\Program Files\WindowsPowerShell\DscService")                                                                                                                    
  $RootDoc.appSettings.AppendChild($subnode) 
                                                                                                                      
  $xml.Save("$PULLServerWebDirectory\web.config")  
  CD C:\ 
 
 New-NetFirewallRule -Name "Ninety" -DisplayName "Ninety" -Protocol tcp -LocalPort $port -Action Allow -Enabled True
