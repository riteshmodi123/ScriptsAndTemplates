

#C:\Users\rimodi\Pictures\IMG_20161001_161544.png

$apiKey = "32e03ef94c3341ffada638bed0bef246"
$EmotionAPIURI = "https://api.projectoxford.ai/face/v1.0/facelists/myfirstlist"    

$ap = New-Object -TypeName Object
$ap | Add-Member -MemberType NoteProperty -Name "name" -Value "myfirstlist" 
$ap | Add-Member -MemberType NoteProperty -Name "userData" -Value "list consisting of all faces" 

$qq = ConvertTo-Json -InputObject $ap

$result = Invoke-RestMethod -Method Put -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -Body $qq -ContentType "application/json" -ErrorAction Stop     

#======================Get Face list start============================
#$result = Invoke-RestMethod -Method Get -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey }  -ErrorAction Stop 
#======================Get Face list end============================    

#======================List Face list start============================
#$EmotionAPIURI = "https://api.projectoxford.ai/face/v1.0/facelists" 

#$result = Invoke-RestMethod -Method Get -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey }  -ErrorAction Stop     
#======================List Face list start============================


$apiKey = "39517ae020ff4bafbef9997e849b1eb7"
$EmotionAPIURI = "https://api.projectoxford.ai/video/v1.0/trackface "  
$Path = "D:\Clip_1080_5sec_10mbps_h264.mp4"

$result = Invoke-RestMethod -Method Post -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -InFile $Path -ContentType "application/octet-stream" -ErrorAction Stop  
