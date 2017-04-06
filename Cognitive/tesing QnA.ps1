#https://qnamaker.ai/
#https://azure.microsoft.com/en-in/support/faq/

$responseString = "";

#$query = “Where is Azure Support available?”; 
#$knowledgebaseId = “a4a0ee57-a911-4fb7-b78d-961bafa66b83”; 
#$qnamakerSubscriptionKey = “5898bcf6ca954f07bd6920ba29572bc4”; 

$query = “Where is Azure Support available?”; 
$knowledgebaseId = “a4a0ee57-a911-4fb7-b78d-961bafa66b83”; 
$qnamakerSubscriptionKey = “5898bcf6ca954f07bd6920ba29572bc4”; 

$url = "https://westus.api.cognitive.microsoft.com/qnamaker/v1.0/knowledgebases/$knowledgebaseId/generateAnswer"


$postBody = "{""question"": ""$query""}";

Invoke-RestMethod -Method Post -Headers @{"Ocp-Apim-Subscription-Key"=$qnamakerSubscriptionKey; "Content-Type"="application/json";} -Uri $url -Body $postBody


