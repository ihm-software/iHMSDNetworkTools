Function Add-LogError {
    [CmdletBinding()]
    Param ([Parameter(Mandatory = $true)]$LogPath, [Parameter(Mandatory = $true)]$ErrorDesc, [Parameter(Mandatory = $true)][boolean]$ExitGracefully, [Parameter()][int]$LineNumber)
    Process {
        If (-not $PSBoundParameters.LineNumber) {
            $LineNumber = $MyInvocation.ScriptLineNumber
        }
        $LogValue = "{0}    Line {1}    {2}" -f (Get-Date -format G), ("{0:d3}" -f $LineNumber), $ErrorDesc
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