
$username = "autonext\administrator"
$pass = ConvertTo-SecureString -AsPlainText -Force -String "Kites123.."
$cred = New-Object System.management.Automation.pscredential ($username, $pass)

$allData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword = $true
        },
        @{
            NodeName="Client13"
            PSDscAllowPlainTextPassword = $true
        }
    )
}


configuration Database
{
    node "client13"
    {
       

       Group LocalGroup
       {
        GroupName =  "Administrators"
        MembersToInclude = "autonext\administrator"
        Credential = $cred
        
       }
       
       xSqlServerInstall InstallSQL
       {
         InstanceName = "MSSQLSERVER"
         SourcePath = "\\Client11\teched\SQL\x64"
         Features = "SQLEngine,SSMS,DQ,CONN,BC"
         DependsOn = "[Group]LocalGroup"
         
       }
       

       

      Package CreateDB
        {
            Ensure = "Present"
            Name = "Windows App Certification Kit Native Components"
            Path = "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe"
            Arguments = "/a:Import /sf:C:\DSCDB.bacpac /tsn:Client13.autonext.com /tdn:DSCDB"
            ProductId = "1D2CEC61-C3F0-C27E-7280-F9D6B10378BE"
            DependsOn = "[xSqlServerInstall]InstallSQL"
        }



    }
}

Database -OutputPath "C:\teched\nodemof\c13" -ConfigurationData $allData
Start-DscConfiguration -wait  -Force -Path "C:\teched\nodemof\c13" -Verbose 

