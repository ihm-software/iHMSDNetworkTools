<#
.SYNOPSIS
    This script combines functions to check network information and speedtest results.
    Local file is named "[DATETIME]_[COMPUTERNAME].txt" and locationed in script root
    Then uploads text file to an anonymous sharepoint online document library.
.DESCRIPTION
    Cross Platform Network troubleshooting tool
.PARAMETER Filename
    The name of the information file. By default, this is the current time and computer hostname.
.PARAMETER AnonURL
    This is the shared link created by sharepoint online when sharing to "Everyone". This script does not support authenticated links.
.OUTPUTS
    Text file where script was executed, default is "[DATETIME]_[COMPUTERNAME].txt"
    Text file on sharepoint online library
.EXAMPLE
    Upload network information to https://bit.ly/ihmnetwizupload
    Send-NetworkInfo -AnonURL "https://bit.ly/ihmnetwizupload"
.EXAMPLE
    Upload network information with custom file name to https://bit.ly/ihmnetwizupload
    Send-NetworkInfo -Filename "Myfile.txt" -AnonURL "https://bit.ly/ihmnetwizupload"
#>
function Send-NetworkInformation {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $True, HelpMessage = "Please enter a custom name for the output file.")]
        [String]$Filename = "$([Environment]::MachineName).txt" ,
        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $True, HelpMessage = "Please enter the shared upload link")]
        [ValidateNotNullOrEmpty()]
        [String]$AnonUrl = 'https://bit.ly/ihmnetwizupload'
    )
    begin {
        $Now = Get-Date -Format yyyy-M-d_hh.mm.tt
        If ($null -ne $Now){$Filename = "$($Now)_$([Environment]::MachineName).txt"}
        $ScriptName = "Send-NetworkInformation"
        $ScriptVersion = "1.0.2"
        $Global:ErrorActionPreference = "Stop"
        #Initiate Functions
        
        
        #Creating logging and file paths
        [string]$ScriptPath =
        If ($PSScriptRoot) { $PSScriptRoot }
        ElseIf ($PSCommandPath) { Split-Path -Parent -Path $PSCommandPath -ErrorAction SilentlyContinue }
        ElseIf ($PWD) { $PWD }
        ElseIf ($MyInvocation.InvocationName) { Split-Path -Parent -Path $MyInvocation.InvocationName -ErrorAction SilentlyContinue }
        [string]$LogPath =
        if (Test-Path "$ScriptPath\Logs") { "$ScriptPath\Logs" }
        else { New-Item -ItemType Directory -Path "$ScriptPath\Logs" }
        [string]$LogName = "$($now)_$($ScriptName).log"
        [string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName
        #Starting log as soon as we create path above
        Start-Log -LogPath $LogPath -LogName $LogName -ScriptVersion $ScriptVersion
        #Output file path
        $Filepath = Join-Path -Path $ScriptPath -ChildPath $Filename
    }
    process{
        try{
            Add-LogMessage -LogPath $LogFile -Message "[NFO]    Beginning Speedtest"
            Invoke-Speedtest | Out-File -FilePath $Filepath -Append
            Add-LogMessage -LogPath $LogFile -Message "[NFO]    Gathering network information"
            Get-NetworkInformation | Out-File -FilePath $Filepath -Append
            Add-LogMessage -LogPath $LogFile -Message "[NFO]    Complete"
        }
        catch{
            Add-LogError -LogPath $LogFile -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -ErrorDesc "[ERR]:   $($PSItem.Exception.Message)" -ExitGracefully $false
        }
    }
    end{
        try{
            Add-LogMessage -LogPath $LogFile -Message "[NFO]    Uploading results to $AnonURL"
            Invoke-SharepointUpload -AnonURL $AnonURL -Filepath $Filepath
        }
        catch{
            Add-LogError -LogPath $LogFile -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -ErrorDesc "[ERR]:   $($PSItem.Exception.Message)" -ExitGracefully $false
        }
        finally{
            . $filepath
            Stop-Log -LogPath $LogFile
        }
    }
}
#End of File




