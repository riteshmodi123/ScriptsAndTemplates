$apiKey = "875c36e332094ea2828553371d801caf"
$EmotionAPIURI = "https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=Description,Tags&subscription-key=$apiKey"    

$testPicUrl ="https://allarmfiles.blob.core.windows.net/armfiles/Optimized-IMG_20161121_081620.jpg"            #Use your own picture URL here
$result = Invoke-RestMethod -Method Post -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -InFile "D:\Abhijit Jana.jpg" -ContentType "application/octet-stream" -ErrorAction Stop            


$Path = "D:\Abhijit Jana.jpg"
$apiKey = "32e03ef94c3341ffada638bed0bef246"
$EmotionAPIURI = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&returnFaceAttributes=age,gender&subscription-key=$apiKey"    

$testPicUrl ="https://allarmfiles.blob.core.windows.net/armfiles/Optimized-IMG_20161121_081620.jpg"            #Use your own picture URL here
$result = Invoke-RestMethod -Method Post -Uri $EmotionAPIURI -Header @{ "Ocp-Apim-Subscription-Key" = $apiKey } -InFile $Path -ContentType "application/octet-stream" -ErrorAction Stop     

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Image = [System.Drawing.Image]::fromfile($Path)
    $Graphics = [System.Drawing.Graphics]::FromImage($Image)

    Foreach($R in $result)
    {
    #Individual Emotion score and rectangle dimensions of all Faces identified
    $Age = $R.faceAttributes.Age
    $Gender = $R.faceAttributes.Gender
    $FaceRect = $R.faceRectangle

    $LabelText = "$Age, $Gender"
    
    #Create a Rectangle object to box each Face
    $FaceRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,$FaceRect.top,$FaceRect.width,$FaceRect.height)

    #Create a Rectangle object to Sit above the Face Rectangle and express the emotion
    $AgeGenderRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,($FaceRect.top-22),$FaceRect.width,22)
    $Pen = New-Object System.Drawing.Pen ([System.Drawing.Brushes]::crimson,5)

    #Creating the Rectangles
    $Graphics.DrawRectangle($Pen,$FaceRectangle)    
    $Graphics.DrawRectangle($Pen,$AgeGenderRectangle)
    $Region = New-Object System.Drawing.Region($AgeGenderRectangle)
    $Graphics.FillRegion([System.Drawing.Brushes]::Crimson,$Region)

    #Defining the Fonts for Emotion Name
    $FontSize = 14
    $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold) 
    
      $TextWidth = ($Graphics.MeasureString($LabelText,$Font)).width
    $TextHeight = ($Graphics.MeasureString($LabelText,$Font)).Height

        #A While Loop to reduce the size of font until it fits in the Emotion Rectangle
        While(($Graphics.MeasureString($LabelText,$Font)).width -gt $AgeGenderRectangle.width -or ($Graphics.MeasureString($LabelText,$Font)).Height -gt $AgeGenderRectangle.height )
        {
        $FontSize = $FontSize-1
        $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold)  
        }

    #Inserting the Emotion Name in the EmotionRectabgle
    $Graphics.DrawString($LabelText,$Font,[System.Drawing.Brushes]::White,$AgeGenderRectangle.x,$AgeGenderRectangle.y)
}

    #Define a Windows Form to insert the Image
    $Form = New-Object system.Windows.Forms.Form
    $Form.BackColor = 'white'
    $Form.AutoSize = $true
    $Form.StartPosition = "CenterScreen"
    $Form.Text = "Get-AgeAndGender | Microsoft Project Oxford"

    #Create a PictureBox to place the Image
    $PictureBox = New-Object System.Windows.Forms.PictureBox
    $PictureBox.Image = $Image
    $PictureBox.Height =  700
    $PictureBox.Width = 600
    $PictureBox.Sizemode = 'autosize'
    $PictureBox.BackgroundImageLayout = 'stretch'
    
    #Adding PictureBox to the Form
    $Form.Controls.Add($PictureBox)
    
    [System.Drawing.Bitmap] $bitmap = new-object System.Drawing.Bitmap -ArgumentList $result[0].faceRectangle.width, $result[0].faceRectangle.Height

    [System.Drawing.Graphics] $gg = [System.Drawing.Graphics]::FromImage($bitmap)
    $gg.DrawImage($Image, 0,0,(New-Object System.Drawing.Rectangle ( $result[0].faceRectangle.left,$result[0].faceRectangle.top,$result[0].faceRectangle.width,$result[0].faceRectangle.Height)), [System.Drawing.GraphicsUnit]::Pixel)
    $bitmap.Save("D:\modis.png")


    #Making Form Visible
    [void]$Form.ShowDialog()

    #Disposing Objects and Garbage Collection
    $Image.Dispose()
    $Pen.Dispose()
    $PictureBox.Dispose()
    $Graphics.Dispose()
    $Form.Dispose()
    [GC]::Collect()       