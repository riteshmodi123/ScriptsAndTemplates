
configuration FirewallDemo{
    Import-DscResource -ModuleName xNetworking -ModuleVersion 3.1.0.0

    xFirewall sshport{
        Name='SSH'
        Ensure = "Present"
        Enabled = "True"
        Profile = 'Domain', 'Private', 'Public'
        Action = 'Allow'
        RemotePort = 22
        LocalPort = 22
        Protocol = 'TCP'
        Service = 'sshd'
        Direction = 'Inbound'
        InterfaceType = 'Any'
    }
}

FirewallDemo -OutputPath .\FirewallDemo

Start-DscConfiguration -wait -Force -Verbose -Path .\FirewallDemo

Get-DscLocalConfigurationManager



