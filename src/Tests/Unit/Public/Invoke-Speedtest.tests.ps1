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
    $functionName = 'Invoke-Speedtest'
    Describe "$functionName Function Tests" -Tag Unit {
        It "Outputs an Object" {
            Invoke-Speedtest -testcount 1 -size 500 | Should -BeOfType [PSCustomObject]
        }
    
    }
}
