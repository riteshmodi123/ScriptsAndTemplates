#$accountKey = "0427d14bc3394f038898ecc09163d537"
$accountKey = "4cc25bf4369a46988305b73d5258f41a"
 $tokenServiceURL = "https://api.cognitive.microsoft.com/sts/v1.0/issueToken"
 $query = "?Subscription-Key=$accountKey"
 $uri = $tokenServiceUrl+$query

 $token = Invoke-RestMethod -Uri $uri -Method Post
 $token

 $auth = "Bearer "+$token
 $header = @{Authorization = $auth}
 $header

 $fromLang = "en" #English
 $toLang = "fr"   #Spanish
 $text = Read-Host "Enter text to translate"

 $translationURL = "http://api.microsofttranslator.com/v2/Http.svc/Translate"
 $query = "?text=" + [System.Web.HttpUtility]::UrlEncode($text)
 $query += "&from=" + $fromLang
 $query += "&to=" + $toLang
 $query += "&contentType=text/plain"
 $uri = $translationUrl+$query

 $ret = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
 $ret.string.'#text'