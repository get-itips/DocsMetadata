#Replace-HttpToSecure.ps1
#Todo:
#Author: Andres Gorzelany
#GitHub Handle: get-itips



param(
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [string]$Path="",

    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    [string]$FileFilter="",

    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    [string]$UrlToBeReplaced="",

    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    [string]$NewUrl=""
)

Write-Host "###########################" -ForegroundColor Blue
Write-Host "Replace-HttpToSecure.ps1 Version 0.1" -ForegroundColor White
Write-Host "Runtime values set by user:" -ForegroundColor White
Write-Host "###########################" -ForegroundColor Blue
Write-Host "Value for path " $Path -ForegroundColor Blue
Write-Host "Value for FileFilter " $FileFilter -ForegroundColor Blue
Write-Host "Value for UrlToBeReplaced " $UrlToBeReplaced -ForegroundColor Blue
Write-Host "Value for NewUrl " $NewUrl -ForegroundColor Blue

$files=get-ChildItem $Path  -filter "$fileFilter*.md" -Recurse
if($null -eq $files)
{
    throw "Did not find any Markdown files in the supplied Path"
}

        #let's ask if we are ok to continue
        $confirmation = Read-Host "Are you Sure You Want To Proceed [y/n]"
        if ($confirmation -ne 'y') {
        # exit
            throw "Operation was cancelled"
        }
        Write-Host "##############################"
        Write-Host "Begin processing..."

        foreach ($file in $files){

    
            $pathToFile = $file.FullName
            #$file.FullName
            $getTxtLines = Get-Content $pathToFile
            if($getTxtLines -match [RegEx]::Escape($UrlToBeReplaced))
            {
               (Get-Content $pathToFile -Encoding UTF8).replace($UrlToBeReplaced, $NewUrl) | Set-Content $pathToFile -Encoding UTF8
               write-host $file.FullName -ForegroundColor Yellow
            }
        }