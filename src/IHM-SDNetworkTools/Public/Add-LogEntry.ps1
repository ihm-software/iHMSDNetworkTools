<#
.SYNOPSIS
Allows for writing a log formatted with the date, line number, and message.

.DESCRIPTION
Allows for writing a log formatted with the date, line number, and message.

.PARAMETER LogPath
The Folder for starting log

.PARAMETER LineNumber
The breakpoint line carried from error

.PARAMETER Exit
Used to terminate context after logging error

.EXAMPLE
Add-LogMessage -LogPath $LogPath -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -Message $PSItem.Exception.Message

Adds a log entry passing a Catch error's script line number & message

.EXAMPLE
Add-LogMessag -LogPath $LogPath -Message 'Custom Message'

Adds a log entry for the custom message.  The line number caught in the log will be the line Add-LogMessag was called from which will get you close to where the source of your log message originated.
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