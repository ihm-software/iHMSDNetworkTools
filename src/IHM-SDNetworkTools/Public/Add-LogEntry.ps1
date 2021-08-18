<#
.SYNOPSIS
Allows for writing a log formatted with the date, line number, and message.

.DESCRIPTION
Allows for writing a log formatted with the date, line number, and message.

.EXAMPLE
Add-LogMessage -LogPath $LogPath -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -Message $PSItem.Exception.Message

Adds a log entry passing a Catch error's script line number & message

.EXAMPLE
Add-LogMessag -LogPath $LogPath -Message 'Custom Message'

Adds a log entry for the custom message.  The line number caught in the log will be the line Add-LogMessag was called from which will get you close to where the source of your log message originated.

.NOTES
Version:        1.0
Author:         Rick Arroues
Creation Date:  12/01/17
Purpose/Change: Written by Rick A, December 2017

Version:        1.1
Author:         Jason Diaz
Creation Date:  08/01/2020
Purpose/Change: Renamed functions to approved verbs and copied into  logging module
#>
Function Add-LogEntry {
    [CmdletBinding()]
    param(
        [Parameter()]
        $LogPath = $LogPath,
        [Parameter()]
        [int]$LineNumber,
        [Parameter()]
        $Message,
        [Parameter()]
        [switch]$Exit
    )
    begin {}
    process	{
        If (-not $PSBoundParameters.LineNumber) {
            $LineNumber = $MyInvocation.ScriptLineNumber
        }
        $LogValue = "{0}    Line {1}    {2}" -f (Get-Date -Format G), ("{0:d3}" -f $LineNumber), $Message
        Add-Content -Path $LogPath -Value $LogValue
        If ($PSBoundParameters.Exit -eq $True) {
            Get-PSSession | Remove-PSSession
            Exit
        }
    }
    end {}
}