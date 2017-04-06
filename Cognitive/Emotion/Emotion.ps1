$EmotionAPIURI = "https://api.projectoxford.ai/emotion/v1.0/recognize"  
        
##$apiKey = "431c02b6d84642258528de95017cb09a"
$apiKey = "57400337ba6b4256a17be75d84e075c0"

 $query = "?Subscription-Key=$apiKey"
 $uri = $tokenServiceUrl+$query  

#From URL                       
#$testPicUrl ="https://allarmfiles.blob.core.windows.net/mycontainer/IMG_20161001_161541.jpg"            #Use your own picture URL here
$testPicUrl ="https://allarmfiles.blob.core.windows.net/mycontainer/surprise.png"            #Use your own picture URL here
$bod = @{url = $testPicUrl };            
$jsbod = ConvertTo-Json $bod            
$result = Invoke-RestMethod -Method Post -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -Body $jsbod -ContentType "application/json" -ErrorAction Stop            
$faceCount = $result.Count            
write-host "$faceCount" faces            
$result.scores | foreach {            
    write-host $(get-MaxEmotion $_)            
    }


function global:get-MaxEmotion($ScoreSet){            
if ($scoreset -ne $null) {            
    $maxEmotionScore = $scoreSet.anger;            
    $maxEmotionName = "Anger"            
    if ($scoreSet.contempt -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.contempt; $maxEmotionName = "Contempt"}            
    if ($scoreSet.disgust -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.disgust; $maxEmotionName = "Disgust"}            
    if ($scoreSet.fear -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.fear; $maxEmotionName = "Fear"}            
    if ($scoreSet.hapiness -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.happiness; $maxEmotionName = "Happy"}            
    if ($scoreSet.neutral -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.neutral; $maxEmotionName = "Neutral"}            
    if ($scoreSet.sadness -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.sadness; $maxEmotionName = "Sad"}            
    if ($scoreSet.surprise -gt $maxEmotionScore) { $maxEmotionScore = $scoreSet.surprise; $maxEmotionName = "Surprise"}            
    }            
else             
    {$maxEmotionName="no data"}            
return $maxEmotionName;            
}
