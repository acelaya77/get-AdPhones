. (Join-Path $PSScriptRoot Get-ADPhones.ps1)

<#
$path = (join-path . "Get-AdPhones.psd1")
$guid = [guid]::NewGuid().guid

$paramHash = @{
    Path = $path
    RootModule = "Get-AdPhones.psm1"
    Author = "Anthony J. Celaya"
    CompanyName = ""
    ModuleVersion = "1.0"
    Guid = $guid
    PowerShellVersion = "5.0"
    Description = "My Modules"
    FunctionsToExport = "Get-AdPhones"
    AliasesToExport = "gadphones"
    VariablesToExport = ""
    CmdletsToExport = ""
   }
New-ModuleManifest @paramHash
#>
