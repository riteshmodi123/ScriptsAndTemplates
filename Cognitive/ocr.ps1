
Add-Type -AssemblyName "System.Net.Http" 
$EmotionAPIURI = "https://westus.api.cognitive.microsoft.com/vision/v1.0/describe"  
      $EmotionAPIURI =   "https://westus.api.cognitive.microsoft.com/vision/v1.0/ocr"
##$apiKey = "431c02b6d84642258528de95017cb09a"
$apiKey = "5c3911e21d464982a8f5f1272d294cc3"

 $query = "?Subscription-Key=$apiKey"
 $uri = $EmotionAPIURI+$query  

 #$body = Get-Content("D:\images.png") -raw -ReadCount 0

 [byte[]]$body = Get-Content "D:\unnamed.jpg" -Encoding Byte -ReadCount 0
 $aa = new-object System.Net.Http.ByteArrayContent -ArgumentList @(,  $body)
 
 $result = Invoke-RestMethod -Method Post -Uri $uri -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -InFile "D:\unnamed.png" -ContentType "application/octet-stream" -ErrorAction Stop            

# $result = Invoke-RestMethod -Method Post -Uri $uri -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey }  -ContentType "application/octet-stream" -UseBasicParsing -Body $bb -ErrorAction Stop            


