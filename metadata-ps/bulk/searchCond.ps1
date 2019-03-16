$initialPath = "D:\Prof\dev\docs\windows-powershell-docs\"
$files=get-ChildItem $initialPath  -filter "*.md" -Recurse
$withMatch=0
foreach ($file in $files){
    $pathToFile = $file.FullName
    $getTxtLines = Get-Content $pathToFile
    $stringMatch = "ms.author"
    #will contain the matched line number

    if($getTxtLines -cmatch $stringMatch)
    {
        #Write-Host "##############################"
        #Write-Host "Already has ms.author:"

    }
    else {
        Write-Host "$pathToFile"
        $withMatch=$withMatch+1
    }
    
}
$withMatch