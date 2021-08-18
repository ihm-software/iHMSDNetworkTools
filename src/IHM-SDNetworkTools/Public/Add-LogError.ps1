<#
.SYNOPSIS
Writes an error to a log file

.DESCRIPTION
Writes the passed error to a new line at the end of the specified log file

.PARAMETER LogPath
Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log

.PARAMETER LineNumber
The breakpoint line carried from error

.PARAMETER ErrorDesc
Mandatory. The description of the error you want to pass (use $_.Exception)

.PARAMETER ExitGracefully
Mandatory. Boolean. If set to True, runs Stop-Log and then exits script

.INPUTS
Parameters above

.OUTPUTS
None

.EXAMPLE
Add-LogError -LogPath "C:\Windows\Temp\Test_Script.log" -ErrorDesc $_.Exception -ExitGracefully $True
#>
Function Add-LogError {
    [CmdletBinding()]
    Param ([Parameter(Mandatory = $true)]$LogPath, [Parameter(Mandatory = $true)]$ErrorDesc, [Parameter(Mandatory = $true)][boolean]$ExitGracefully, [Parameter()][int]$LineNumber)
    Process {
        If (-not $PSBoundParameters.LineNumber) {
            $LineNumber = $MyInvocation.ScriptLineNumber
        }
        $LogValue = "{0}    Line {1}    {2}" -f (Get-Date -Format G), ("{0:d3}" -f $LineNumber), $ErrorDesc
        Add-Content -Path $LogPath -Value $LogValue
        #Write to screen for debug mode
        Write-Debug $LogValue
        #If $ExitGracefully = True then run Stop-Log and exit script
        If ($PSBoundParameters.ExitGracefully -eq $True) {
            Stop-Log -LogPath $PSBoundParameters.LogPath
            Break
        }
    }
}