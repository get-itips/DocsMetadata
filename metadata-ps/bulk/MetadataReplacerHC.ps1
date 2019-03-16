
$initialPath = "E:\Prof\dev\docs\windows-powershell-docs\docset\windows\"

$lettersArray = @("d","e","f")
git status

foreach($letter in $lettersArray)
{

    $batchPath = Get-ChildItem $initialPath  -filter "$letter*"
    Write-Host $batchPath.FullName -ForegroundColor Red
    foreach($path in $batchPath){

        $files=get-ChildItem $path  -filter "*.md"

        foreach ($file in $files){
            
            #$file.FullName
            $pathToFile = $file.FullName
        (Get-Content $pathToFile -Encoding UTF8).replace('ms.author: coreyp', 'ms.author: kenwith') | Set-Content $pathToFile  -Encoding utf8
        (Get-Content $pathToFile -Encoding UTF8).replace('author: coreyp-at-msft', 'author: kenwith') | Set-Content $pathToFile  -Encoding utf8
        
        $getTxtLines = Get-Content $pathToFile
        $stringMatch = "title:"
        $stringMSReviewer="ms.reviewer:"
        $run=$true
        if($getTxtLines -cmatch $stringMSReviewer)
        {

            Write-Host "Already has ms.reviewer: "$pathToFile"" -ForegroundColor Green

            $run=$false
        }
        
        
        $ble = $getTxtLines -match $stringMatch
        if($ble.Count -eq 0)
        {

            Write-Host "Doesn't have title string: "$pathToFile"" -ForegroundColor Green

            $run=$false
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

$message = "folders starting with "+ $lettersArray[0]+ " " + $lettersArray[1]+ " "+$lettersArray[2]
$message
read-host "Press enter to commit"
git commit -a -m "Changed coreyp to kenwith as author" -m $message

