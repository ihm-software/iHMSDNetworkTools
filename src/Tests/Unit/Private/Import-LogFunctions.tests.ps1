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
    $functionName = 'Import-LogFunctions'
    Describe "$functionName Function Tests" -Tag Unit {
        BeforeEach {
            $LogPath = "TestDrive:\"
            $LogName = "test_log.txt"
            $LogFile = "TestDrive:\test_log.txt"
            $Message = "Log Message"
            $LineNumber = "1"
        }
        It "Starts Log Content" {
            Start-Log -LogPath $LogPath -LogName $LogName -ScriptVersion 1
            $LogFile | Should -FileContentMatch "Started"
        }
        It "Adds Error Messages" {
            Add-LogError -LogPath $LogFile -ErrorDesc $Message -LineNumber $LineNumber -ExitGracefully $false
            $LogFile | Should -FileContentMatch "Log Message"
        }
        It "Adds Custom Messages" {
            Add-LogMessage -LogPath $LogFile -Message $Message -LineNumber $LineNumber
            $LogFile | Should -FileContentMatch "Log Message"
        }
        It "Stops with Finished header" {
            Stop-Log -LogPath $LogFile -NoExit:$true
            $LogFile | Should -FileContentMatch "Finished"
        }
    }
}