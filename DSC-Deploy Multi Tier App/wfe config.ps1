
Configuration WFE
{
   # import-dscresource -module xWebAdministration
    node Client12
    {
      

        WindowsFeature IIS
        {
            Name = "Web-Server"
            Ensure = "Present"
            IncludeAllSubFeature = $true
        }
      
        WindowsFeature AppServer
        {
            Name = "Application-server"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]IIS"
        }

          WindowsFeature DotNetFramework
        {
            Name = "As-NET-Framework"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]AppServer"
        }

        WindowsFeature WasSupport
        {
            Name = "As-was-support"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]DotNetFramework"
        }
        WindowsFeature AspDotNet
        {
            Name = "net-framework-45-Core"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]WasSupport"
        }

        
        WindowsFeature AspNet45
        {
            Ensure          = "Present"
            Name            = "Web-Asp-Net45"
            DependsOn = "[WindowsFeature]AspDotNet"
        }

        xWebAppPool WebsiteApplicationPool
        {
            Name = "techedsite"
            Ensure = "Present"
            State = "Started"
            DependsOn = "[WindowsFeature]AspNet45"

        }


         file CopyWebFiles
        {
            DestinationPath = "C:\Inetpub\wwwroot\BinaryBakery"
            Ensure = "Present"
            Type = "Directory"
            SourcePath = "\\client11\teched\website"
            Recurse = $true
            DependsOn = "[xWebAppPool]WebsiteApplicationPool"
        }

        xWebsite CreateWebsite
        {
            Name = "teched"
            PhysicalPath = "C:\Inetpub\wwwroot\BinaryBakery"
            Ensure = "Present"
            State = "Started"
            ApplicationPool = "techedsite"
            BindingInfo = MSFT_xWebBindingInformation{
                port ="8080"
            }
            DependsOn = "[file]CopyWebFiles"
        }
        
       
        xWebConfigKeyValue AddWebConnectionString
        {
            WebsitePath = "IIS:\Sites\teched"
            Ensure = "Present"
            Key = "SQLConnection"
            value = "server=client13;Database=DSCDB;Integrated Security=True;"
            ConfigSection = "AppSettings"
            IsAttribute = $false
            DependsOn = "[xWebsite]CreateWebsite"
        }
       



    }
}

WFE -outputpath "C:\teched\nodemof\c12"

Start-DscConfiguration -Path "C:\teched\nodemof\c12"  -Force -verbose -Wait 

