<#
.SYNOPSIS
Write closing logging data & exit

.DESCRIPTION
Writes finishing logging data to specified log and then exits the calling script

.PARAMETER LogPath
Mandatory. Full path of the log file you want to write finishing data to. Example: C:\Windows\Temp\Test_Script.log

.PARAMETER NoExit
Optional. If this is set to True, then the function will not exit the calling script, so that further execution can occur

.INPUTS
Parameters above

.OUTPUTS
None

.EXAMPLE
Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log"

.EXAMPLE
Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log" -NoExit $True
#>
Function Stop-Log {
    [CmdletBinding(SupportsShouldProcess)]
    Param ([Parameter(Mandatory = $true)]$LogPath, [Parameter(Mandatory = $false)]$NoExit)
    Process {
        Add-Content -Path $LogPath -Value ""
        Add-Content -Path $LogPath -Value "***************************************************************************************************"
        Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
        Add-Content -Path $LogPath -Value "***************************************************************************************************"
        #Write to screen for debug mode
        Write-Debug ""
        Write-Debug "***************************************************************************************************"
        Write-Debug "Finished processing at [$([DateTime]::Now)]."
        Write-Debug "***************************************************************************************************"
        #Exit calling script if NoExit has not been specified or is set to False
        If (!($NoExit) -or ($NoExit -eq $False)) {
            Exit
        }
    }
}