<#
.SYNOPSIS
    Creates log file with path and name that is passed. Checks if log file exists, and if it does deletes it and creates a new one.
    Once created, writes initial logging data
.DESCRIPTION
    Cross-platform error logging module
.PARAMETER LogPath
    Mandatory. Path of where log is to be created. Example: C:\Windows\Temp
.PARAMETER LogName
    Mandatory. Name of log file to be created. Example: Test_Script.log
.PARAMETER ScriptVersion
    Mandatory. Version of the running script which will be written in the log. Example: 1.5
.EXAMPLE
    Start-Log -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"
#>
Function Start-Log {
    [CmdletBinding(SupportsShouldProcess)]
    Param ([Parameter(Mandatory = $true)]$LogPath, [Parameter(Mandatory = $true)]$LogName, [Parameter(Mandatory = $true)]$ScriptVersion)
    Process {
        $sFullPath = $LogPath + "\" + $LogName

        #Check if file exists and delete if it does
        If ((Test-Path -Path $sFullPath)) {
            Remove-Item -Path $sFullPath -Force
        }

        #Create file and start logging
        New-Item -Path $LogPath -Name $LogName -ItemType File | Out-Null

        Add-Content -Path $sFullPath -Value "***************************************************************************************************"
        Add-Content -Path $sFullPath -Value "Started processing at [$([DateTime]::Now)]."
        Add-Content -Path $sFullPath -Value "***************************************************************************************************"
        Add-Content -Path $sFullPath -Value ""
        Add-Content -Path $sFullPath -Value "Running script version [$ScriptVersion]."
        Add-Content -Path $sFullPath -Value ""
        Add-Content -Path $sFullPath -Value "***************************************************************************************************"
        Add-Content -Path $sFullPath -Value ""

        #Write to screen for debug mode
        Write-Debug "***************************************************************************************************"
        Write-Debug "Started processing at [$([DateTime]::Now)]."
        Write-Debug "***************************************************************************************************"
        Write-Debug ""
        Write-Debug "Running script version [$ScriptVersion]."
        Write-Debug ""
        Write-Debug "***************************************************************************************************"
        Write-Debug ""
    }
}