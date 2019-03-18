$initialPath = "E:\Prof\Dev\docs\windows-powershell-docs\docset\winserver2012r2-ps\"

#$lettersArray =[char[]]([char]'A'..[char]'Z') -join ''

$lettersArray = @("w")
$stringMaster="ms.assetid:"
#foreach($letter in $lettersArray)
foreach($letter in $lettersArray)
{

    $batchPath = Get-ChildItem $initialPath  -filter "$letter*"
    
    foreach($path in $batchPath){
        Write-Host $path.FullName -ForegroundColor Red
        $files=get-ChildItem $path  -filter "*.md"
        foreach ($file in $files){
            
            #$file.FullName
            $pathToFile = $file.FullName
            #$pathToFile = "D:\Prof\dev\docs\OfficeDocs-SkypeForBusiness_\Skype\SfbServer\plan-your-deployment\enterprise-voice-solution\call-management-features.md"
            $run=$true

            $runMsReviewer=$true
            #Check if author or ms.author are already present 
            $getTxtLines = Get-Content $pathToFile
            $stringMatch = "ms.author"

            #will contain the matched line number


            if($getTxtLines -cmatch "author: brianlic")
            {
                #Write-Host "##############################"
                #Write-Host "Already has author: $pathToFile" -ForegroundColor Blue
                #Write-Host ""
                $run=$true
            }
            else
            {
                $run=$false
            }
            
            if($getTxtLines -cmatch $stringMSReviewer)
            {
                #Write-Host "##############################"
                Write-Host "Already has ms.reviewer: "$pathToFile"" -ForegroundColor Green

                $runMsReviewer=$false
                $run=$false
            }
            

            $stringMatch = $stringMaster
            $ble = $getTxtLines -match $stringMatch



            if($ble.Count -eq 0)
            {
                Write-Host "Doesn't have title or schema string: "$pathToFile"" -ForegroundColor Red

                $run=$false
            }


            #Check ends


            if($run){
                $file.FullName
                


                if($runMsReviewer)
                {
                    #PHASE 3 - Adding ms.reviewer:
                    #################################
                    #################################
                    $getTxtLines = Get-Content $pathToFile
                    $stringMatch = $stringMaster
                    $stringMSReviewer="ms.reviewer: brianlic"
                    Write-Host "Need to reviewer" -BackgroundColor Yellow

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
}