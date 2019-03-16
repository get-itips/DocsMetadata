
$initialPath = "D:\Prof\dev\docs\windows-powershell-docs\docset\windows\adfs"
$files=get-ChildItem $initialPath  -filter "*.md"

foreach ($file in $files){
    
    $file.FullName
    $pathToFile = $file.FullName
(Get-Content $pathToFile ).replace('ms.author: coreyp', 'ms.author: kenwith') | Set-Content $pathToFile
(Get-Content $pathToFile ).replace('author: coreyp-at-msft', 'author: kenwith') | Set-Content $pathToFile

$getTxtLines = Get-Content $pathToFile
$stringMatch = "title:"
$stringMSReviewer="ms.reviewer:"
$run=$true
if($getTxtLines -cmatch $stringMSReviewer)
{
    Write-Host "##############################"
    Write-Host "Already has ms.reviewer:"
    Write-Host "$pathToFile"
    $run=$false
}


$ble = $getTxtLines -match $stringMatch
if($ble.Count -eq 0)
{
    Write-Host "##############################"
    Write-Host "Doesn't have title string:"
    Write-Host "$pathToFile"
    $run=$false
}


if($run){
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