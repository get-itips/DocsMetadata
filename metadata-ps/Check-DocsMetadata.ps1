#Check-docsMetadata.ps1
#Todo: Add control if the md file lacks schema string
#Author: Andres Gorzelany
#GitHub Handle: get-itips

        param(
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
            [string]$Path="",

            [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [string]$Author="",
    
            [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [string]$Msauthor="",

            [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [string]$Msreviewer="",
            
            [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [switch]$Write = $false
        )

        Write-Host "###########################"
        Write-Host "Check-DocsMetadata.ps1 Version 0.1"
        Write-Host "Runtime values set by user:"
        Write-Host "###########################"
        Write-Host "Value for path " $Path
        Write-Host "Value for author " $Author
        Write-Host "Value for ms.author " $Msauthor
        Write-Host "Value for ms.reviewer " $Msreviewer
        Write-Host "Write Mode " $Write
        


        #Initial checks
        #Are we running in PS Core?
        if(!$PSVersionTable.PSEdition.Equals("Core"))
        {
            throw "You need to run this Script in PowerShell Core edition"
        }

        #Are we running with write mode on or off?
        #Are all variable values being provided?
        if($write){
            if($Author.Length -le 1)
            {
                throw "We need a value for author when Write mode equals true"

            }
            if($Msauthor.Length -le 1)
            {
                throw "We need a value for ms.author when Write mode equals true"

            }
                
        }
        else {
            if($Author.Length -gt 1)
            {
                Write-Host "author value provided will not be used because Write mode equals false"

            }
            if($Msauthor.Length -gt 1)
            {
                Write-Host "ms.author value provided will not be used because Write mode equals false"

            }
        }

        $files=get-ChildItem $Path  -filter "*.md"
        Write-Host "##############################"
        Write-Host "Begin processing..."
        $matchedFiles = @();
        $stringAuthorLabel = "author"
        $stringMsAuthorLabel = "ms.author"
        $stringMsreviewerLabel = "ms.reviewer"
        $stringSchema = "schema: 2.0.0"
        foreach ($file in $files){
            #$file.FullName
            $getTxtLines = Get-Content $file.FullName


            
            if(!($getTxtLines -cmatch $stringMsAuthorLabel -or $getTxtLines -cmatch $stringAuthorLabel -or $getTxtLines -cmatch $stringMsreviewerLabel))
            {
                $matchedFiles+=$file.FullName
                
            }

        }            
        if($matchedFiles.Length -gt 0){
            Write-Host "Missing either author or ms.author:"
            foreach($pathToFile in $matchedFiles){
                $pathToFile
            }
        }
        if($Write -eq $true){
            foreach($pathToFile in $matchedFiles){
                $pathToFile

                $getTxtLines = Get-Content $pathToFile
                #Find the string to match
                #Line after the match string, insert the new string
        
        
                $stringAuthor=$stringAuthorLabel+": "+$Author
                $stringMSAuthor=$stringMsauthorLabel+": "+$Msauthor
        
        
                #PHASE 1.1: IDENTIFY POSITION TO ADD
                #
                #will contain the matched line number
                $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringSchema)
        
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
                $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringSchema)
        
                #put back the save data
                $getTxtLines[$getStringposNumber]="$xsave"
        
                #insert the new string to the newly added line
                $getTxtLines[$xpos]=$stringAuthor
                #finally save the file again (the final output)
                $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8
        
                #PHASE 2 - Adding MS.AUTHOR
                #################################
                #################################
                $getTxtLines = Get-Content $pathToFile
                #$stringMatch = $stringAuthor
        
            
                #PHASE 2.1: IDENTIFY POSITION TO ADD MS.AUTHOR
                #
                #will contain the matched line number
                $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringAuthor)
        
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
                $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringAuthor)
        
                #put back the save data
                $getTxtLines[$getStringposNumber]="$xsave"
        
                #insert the new string to the newly added line
                $getTxtLines[$xpos]=$stringMSAuthor
                #finally save the file again (the final output)
                $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8
        
        
                #PHASE 3 - Adding ms.reviewer:
                #################################
                #################################
                $getTxtLines = Get-Content $pathToFile
                #$stringMatch = $stringMSAuthor
                $stringMSReviewer="ms.reviewer:"
            
                #PHASE 3.1: IDENTIFY POSITION TO ADD MS.reviewer
                #
                #will contain the matched line number
                $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringMSAuthor)
        
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
                $getStringposNumber = [array]::indexof($getTxtLines, $getTxtLines -match $stringMSAuthor)
        
                #put back the save data
                $getTxtLines[$getStringposNumber]="$xsave"
        
                #insert the new string to the newly added line
                $getTxtLines[$xpos]=$stringMSReviewer
                #finally save the file again (the final output)
                $getTxtLines | Out-File -FilePath $pathToFile -Encoding utf8

            }
        }