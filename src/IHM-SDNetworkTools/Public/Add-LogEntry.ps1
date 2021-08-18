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
        $LogValue = "{0}    Line {1}    {2}" -f (Get-Date -format G), ("{0:d3}" -f $LineNumber), $Message
        Add-Content -Path $LogPath -Value $LogValue
        If ($PSBoundParameters.Exit -eq $True) {
            Get-PSSession | Remove-PSSession
            Exit
        }
    }
    end {}
}