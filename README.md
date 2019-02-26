# DocsMetadata

This private repo holds a PowerShell Core Script to check or update Metadata in MicrosoftDocs-style repos.

## Requirements
This needs to be run on PowerShell Core 6.1.0 or higher
Important Note: It will work in Windows Powershell but that version's Out-File breaks UTF-8 as inserts BOM bytes at the beginning of the file and also could break double quotes and other special characters, please use PowerShell Core or you will end up messing with your markdown files.

This needs to be run under a git directory to be useful specifying the level at which the markdown files to be edited are located

Example use:

PS> .\Check-DocsMetadata.ps1 -Path "D:\Prof\dev\docs\office-docs-powershell\exchange\exchange-ps\exchange\mailboxes" -Author kenwith -Msauthor kenwith -Write:$true

In this case directory mailboxes contains markdown files that need to be filled with kenwith as author and msauthor

By default, if Write parameter is not specified, it will run only in check mode.