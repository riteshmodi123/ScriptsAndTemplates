Configuration ExampleConfiguration{

    Import-DscResource -Module nx

    Node  "dscnode"{
    nxFile ExampleFile {

        DestinationPath = "/tmp/example"
        Contents = "hello world `n"
        Ensure = "Present"
        Type = "File"
    }

    }
}
ExampleConfiguration -OutputPath:"C:\temp1"


$o = New-CimSessionOption -UseSsl -SkipCACheck -SkipCNCheck -SkipRevocationCheck 
$s = New-CimSession -ComputerName dscnode -Credential root -Authentication Basic -SessionOption $o 
Start-DscConfiguration  -CimSession $s -Path "C:\temp1" -Wait -Verbose 
