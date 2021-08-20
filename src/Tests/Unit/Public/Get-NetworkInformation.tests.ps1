#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'iHMSDNetworkTools'
#-------------------------------------------------------------------------
#if the module is already in memory, remove it
Get-Module $ModuleName | Remove-Module -Force
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
InModuleScope $ModuleName {
    $functionName = 'Get-NetworkInformation'
    Describe "$functionName Function Tests" -Tag Unit {
        It "Create an Object" {
            Get-NetworkInformation | Should -BeOfType [PSCustomObject]
        }
    }
}

