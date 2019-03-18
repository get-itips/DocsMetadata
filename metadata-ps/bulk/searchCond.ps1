$initialPath = "E:\Prof\Dev\docs\OfficeDocs-SkypeForBusiness"
$files=get-ChildItem $initialPath  -filter "*.md" -Recurse
$withMatch=0
foreach ($file in $files){
    $pathToFile = $file.FullName
    $getTxtLines = Get-Content $pathToFile
    $stringMatch = "author:"
    #will contain the matched line number

    if($getTxtLines -cmatch $stringMatch)
    {
        #Write-Host "##############################"
        #Write-Host "Already has ms.author:"

    }
    else {
        Write-Host $file.FullName
        $withMatch=$withMatch+1
    }
    
}
$withMatch