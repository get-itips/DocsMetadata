
$initialPath = "E:\Prof\Dev\docs\windows-powershell-docs\docset\winserver2012r2-ps"

#$lettersArray =[char[]]([char]'A'..[char]'Z') -join ''

$lettersArray = @("w")


foreach($letter in $lettersArray)
{

    $batchPath = Get-ChildItem $initialPath  -filter "$letter*"
    
    foreach($path in $batchPath){
        Write-Host $path.FullName -ForegroundColor Red

        $files=get-ChildItem $path  -filter "*.md"

        foreach ($file in $files){
            
            #$file.FullName
            $pathToFile = $file.FullName
        #(Get-Content $pathToFile -Encoding UTF8).replace('ms.author: coreyp', 'ms.author: kenwith') | Set-Content $pathToFile  -Encoding utf8
        (Get-Content $pathToFile -Encoding UTF8).replace('author: brianlic', 'author: kenwith') | Set-Content $pathToFile  -Encoding utf8
        }
    }
}

#$message = "folders starting with "
#foreach($letter in $lettersArray)
#{
#    $message=$message + $letter
#    $message=$message + " "
#}


#$message
#Start-Sleep -s 15
#git -C "E:\Prof\dev\docs\windows-powershell-docs\" commit -a -m "Changed coreyp to kenwith as author" -m $message