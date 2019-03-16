$initialPath = "E:\Prof\Dev\docs\windows-powershell-docs\docset\windows\"
$files=get-ChildItem $initialPath  -filter "*.md"
foreach ($file in $files){
    
    #$file.FullName
    $pathToFile = $file.FullName
    #$pathToFile = "D:\Prof\dev\docs\OfficeDocs-SkypeForBusiness_\Skype\SfbServer\plan-your-deployment\enterprise-voice-solution\call-management-features.md"
    $run=$true
    $runAuthor=$true
    $runMsAuthor=$true
    $runMsReviewer=$true
    #Check if author or ms.author are already present 
    $getTxtLines = Get-Content $pathToFile
    $stringMatch = "ms.author"
    #will contain the matched line number

    if($getTxtLines -cmatch $stringMatch)
    {
        #Write-Host "##############################"
        Write-Host "Already has ms.author: $pathToFile" -ForegroundColor Cyan
        #Write-Host ""
        $runMsAuthor=$false
    }
    if($getTxtLines -cmatch "author:")
    {
        #Write-Host "##############################"
        Write-Host "Already has author: $pathToFile" -ForegroundColor Blue
        #Write-Host ""
        $runAuthor=$false
    }
    
    if($getTxtLines -cmatch $stringMSReviewer)
    {
        #Write-Host "##############################"
        Write-Host "Already has ms.reviewer: "$pathToFile"" -ForegroundColor Green

        $runMsReviewer=$false
    }
    

    $stringMatch = "title:"
    $ble = $getTxtLines -match $stringMatch

    $stringMatch2 = "schema:"
    $ble2 = $getTxtLines -match $stringMatch2

    if($ble.Count -eq 0 -and $ble2.Count -eq 0)
    {
        Write-Host "##############################"
        Write-Host "Doesn't have title string:"
        Write-Host "$pathToFile"
        $run=$false
    }


    #Check ends


    if($run){
        $file.FullName
        if($runAuthor){
            $stringAuthor="author: kenwith"
            #PHASE 1 - Adding AUTHOR
            #################################
            #################################

            $getTxtLines = Get-Content $pathToFile
            #Find the string to match
            #Line after the match string, insert the new string
            #PHASE 1.1: IDENTIFY POSITION TO ADD
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

            #PHASE 1.2 - Adding AUTHOR
            #
            #Open again the text file with the new index array numbers
            $getTxtLines = Get-Content $pathToFile
            $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringMatch)

            #put back the save data
            $getTxtLines[$getStringposNumber]="$xsave"

            #insert the new string to the newly added line
            $getTxtLines[$xpos]=$stringAuthor
            #finally save the file again (the final output)
            $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8
            
        }



        if($runMsAuthor)
        {

        
            $stringMSAuthor="ms.author: kenwith"




            #PHASE 2 - Adding MS.AUTHOR
            #################################
            #################################
            $getTxtLines = Get-Content $pathToFile
            $stringMatch = "title:"

        
            #PHASE 2.1: IDENTIFY POSITION TO ADD MS.AUTHOR
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

            #PHASE 2.2 - Adding ms.AUTHOR
            #
            #Open again the text file with the new index array numbers
            $getTxtLines = Get-Content $pathToFile
            $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringMatch)

            #put back the save data
            $getTxtLines[$getStringposNumber]="$xsave"

            #insert the new string to the newly added line
            $getTxtLines[$xpos]=$stringMSAuthor
            #finally save the file again (the final output)
            $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8
            
        }

        if($runMsReviewer)
        {
            #PHASE 3 - Adding ms.reviewer:
            #################################
            #################################
            $getTxtLines = Get-Content $pathToFile
            $stringMatch = "title:"
            $stringMSReviewer="ms.reviewer:"
        
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