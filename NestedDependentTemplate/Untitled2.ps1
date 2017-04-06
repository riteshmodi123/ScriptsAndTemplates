Login-AzureRmAccount 

Get-AzureRmSubscription | select SubscriptionId, SubscriptionName

Select-AzureRmSubscription -SubscriptionId af75f52f-1ab4-4bec-bed8-4d3d9b8f7eab





New-AzureRmResourceGroup -Name "TotalDocker9" -Location "West Europe"
New-AzureRmResourceGroupDeployment -Name "D2" -ResourceGroupName "TotalDocker9" -Mode Incremental -TemplateFile "C:\AAA\dock\divided Template\torun\azuredeploy.json" -Verbose

New-AzureRmResourceGroupDeployment -Name "D3" -ResourceGroupName "TotalDocker9" -Mode Incremental -TemplateFile "C:\AAA\dock\divided Template\torun\azuredeploy2.json" -Verbose



$storage = Get-AzureRmStorageAccount -ResourceGroupName "win2016devops" -Name "win2016devops"

$storageKey = Get-AzureRmStorageAccountKey -ResourceGroupName "win2016devops" -Name "win2016devops"









Set-AzureStorageBlobContent -File "C:\AAA\dock\divided Template\ContainerConfig.ps1" -Container "armt" -Blob "ContainerConfig.ps1" -BlobType Block -Force -Context $storage.Context

Set-AzureStorageBlobContent -File "C:\AAA\dock\sql1\dockerfile" -Container "armt" -Blob "dockerfile" -BlobType Block -Force -Context $storage.Context
Set-AzureStorageBlobContent -File "C:\AAA\dock\sql1\lcm.ps1" -Container "armt" -Blob "lcm.ps1" -BlobType Block -Force -Context $storage.Context
Set-AzureStorageBlobContent -File "C:\AAA\dock\sql1\lcm1.ps1" -Container "armt" -Blob "lcm1.ps1" -BlobType Block -Force -Context $storage.Context


