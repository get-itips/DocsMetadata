
$initialPath = "E:\Prof\dev\docs\windows-powershell-docs\docset\winserver2012r2-ps\"

$lettersArray = @("a")


foreach($letter in $lettersArray)
{

    $batchPath = Get-ChildItem $initialPath  -filter "$letter*"
    
    foreach($path in $batchPath){
        Write-Host $path.FullName -ForegroundColor Red

        $files=get-ChildItem $path  -filter "*.md"

        foreach ($file in $files){
            
            #$file.FullName
            $pathToFile = $file.FullName
        (Get-Content $pathToFile -Encoding UTF8).replace('ms.author: coreyp', 'ms.author: kenwith') | Set-Content $pathToFile  -Encoding utf8
        (Get-Content $pathToFile -Encoding UTF8).replace('author: coreyp-at-msft', 'author: kenwith') | Set-Content $pathToFile  -Encoding utf8
        
        $getTxtLines = Get-Content $pathToFile
        $stringMatch = ""
        $stringTitle = "title:"
        $stringSchema = "schema:"
        $stringMSReviewer="ms.reviewer:"
        $run=$true
        if($getTxtLines -cmatch $stringMSReviewer)
        {

            Write-Host "Already has ms.reviewer: "$pathToFile"" -ForegroundColor Green

            $run=$false
        }
        
        
        $ble = $getTxtLines -match $stringTitle
        if($ble.Count -eq 0) #title not found
        {

           
            $ble2 = $getTxtLines -match $stringSchema
            if($ble2.Count -eq 0) #neither found
            {
                Write-Host "Doesn't have title or schema string: "$pathToFile"" -ForegroundColor Green
                $run=$false
            }
            else { #we found Schema String
                $stringMatch=$stringSchema
            }
           
        }
        else { #we found title string
            $stringMatch=$stringTitle


        }
        
        
        if($run){
            $file.FullName
            #PHASE 3.1: IDENTIFY POSITION TO ADD MS.reviewer
            #
            #will contain the matched line number
            $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringMatch)
        
            #Add 1 to the matched line number
            #Add 1 so the new line to be inserted is below the matched string
            $xpos = $getStringposNumber+1
        
            #save the match string to a variable
            $xsave = $getTxtLines[$getStringposNumber]
        
            #Insert new lines
            $getTxtLines[$getStringposNumber]="`n`r"
            $getTxtLines[$getStringposNumber]=[Environment]::NewLine
        
            #save the text files with the new lines
            $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8
        
            #PHASE 3.2 - Adding ms.AUTHOR
            #
            #Open again the text file with the new index array numbers
            $getTxtLines = Get-Content $pathToFile
            $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringMatch)
        
            #put back the save data
            $getTxtLines[$getStringposNumber]="$xsave"
        
            #insert the new string to the newly added line
            $getTxtLines[$xpos]=$stringMSReviewer
            #finally save the file again (the final output)
            $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8
            }
        
        
        }

    }

}
$message = "folders starting with "
foreach($letter in $lettersArray)
{
    $message=$message + $letter
    $message=$message + " "
}


#$message
#Start-Sleep -s 15
#git -C "E:\Prof\dev\docs\windows-powershell-docs\" commit -a -m "Changed coreyp to kenwith as author" -m $message

