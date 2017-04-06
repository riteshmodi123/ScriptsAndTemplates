
Configuration SMB
{
    Node "Client11"
    {
        

        xSMBShare share
        {
            Name = "teched"
            Path = "C:\teched\Bits"
            Ensure = "Present"
            FolderEnumerationMode = "Unrestricted"
            
        }
    }
}

SMB -outputpath "C:\teched\nodemof"

Start-DscConfiguration -Path "C:\teched\nodemof" -Wait -Force -Verbose