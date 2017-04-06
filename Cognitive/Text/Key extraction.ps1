

$EmotionAPIURI = "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases"  
        
##$apiKey = "431c02b6d84642258528de95017cb09a"
$apiKey = "46a595ae64aa477586cfa96b16c21991"

 $query = "?Subscription-Key=$apiKey"
 $uri = $tokenServiceUrl+$query  


$testPicUrl ="https://allarmfiles.blob.core.windows.net/mycontainer/surprise.png"            #Use your own picture URL here
$documents = @()

$bod = @{"language" = "en"; "id" = "1"; "text" = "I had a wonderful experience! The rooms were wonderful and the staff were helpful." };            
$documents += $bod

$final = @{documents = $documents}
$jsbod = ConvertTo-Json $final            
$result = Invoke-RestMethod -Method Post -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -Body $jsbod -ContentType "application/json" -ErrorAction Stop            
$result   
