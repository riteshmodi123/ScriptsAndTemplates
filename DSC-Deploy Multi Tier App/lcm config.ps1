
Configuration LCM
{
    node @("Client12", "Client13")
    {
        Localconfigurationmanager
        {
            RebootNodeIfNeeded = $true
        }
    }

}

LCM -OutputPath "C:\teched\lcmmof"

Set-DscLocalConfigurationManager -Path "C:\teched\lcmmof"

