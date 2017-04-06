Configuration PRSPoverSSH_CentOS{ 

 
     Import-DscResource -Module nx 
 
 
     Node "dscnode" { 
         # Install PowerShell 
         
         nxPackage libunwind { 
             PackageManager = "Yum" 
             Name = "libunwind" 
             Ensure = "Present" 
         } 
         nxPackage libicu { 
             PackageManager = "Yum" 
             Name = "libicu" 
             Ensure = "Present" 
         } 
         nxPackage PowerShell { 
             PackageManager = "Yum" 
             Name = "powershell" 
             FilePath = "https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.10/powershell-6.0.0_alpha.10-1.el7.centos.x86_64.rpm" 
             Ensure = "Present" 
             DependsOn = "[nxPackage]libunwind", "[nxPackage]libicu" 
         } 
 

         # Configure SSHd and /etc/ssh/sshd_config 
         nxPackage SSHD { 
             PackageManager = "yum" 
             Name = "openssh-server" 
             Ensure = "Present" 
             DependsOn = "[nxPackage]PowerShell" 
         } 
         nxService SSHDStatus { 
             Controller = "systemd" 
             Name = "sshd" 
             Enabled = $true 
             State = "Running" 
             DependsOn = "[nxPackage]SSHD" 
         } 
         nxFileLine PSRPoverSSH { 
             FilePath = "/etc/ssh/sshd_config" 
             ContainsLine = "Subsystem powershell powershell -sshs -NoLogo -NoProfile" 
             DependsOn = "[nxService]SSHDStatus" 
         } 

     } 
 } 
 PRSPoverSSH_CentOS -OutputPath:"C:\temp" 
