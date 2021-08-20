Function Start-Log {
    <#
  .SYNOPSIS
    Creates log file

  .DESCRIPTION
    Creates log file with path and name that is passed. Checks if log file exists, and if it does deletes it and creates a new one.
    Once created, writes initial logging data

  .PARAMETER LogPath
    Mandatory. Path of where log is to be created. Example: C:\Windows\Temp

  .PARAMETER LogName
    Mandatory. Name of log file to be created. Example: Test_Script.log

  .PARAMETER ScriptVersion
    Mandatory. Version of the running script which will be written in the log. Example: 1.5

  .INPUTS
    Parameters above

  .OUTPUTS
    Log file created

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support

    Version:        1.2
    Author:         Jason Diaz
    Creation Date:  08/01/2020
    Purpose/Change: Renamed functions to approved verbs

  .EXAMPLE
    Start-Log -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"
  #>

    [CmdletBinding(SupportsShouldProcess)]

    Param ([Parameter(Mandatory = $true)][string]$LogPath, [Parameter(Mandatory = $true)][string]$LogName, [Parameter(Mandatory = $true)][string]$ScriptVersion)

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
Function Add-LogMessage {
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
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$LogPath = $LogPath,

        [Parameter()]
        [int]$LineNumber,

        [Parameter()]
        [string]$Message,

        [Parameter()]
        [switch]$Exit
    )

    begin {}
    process	{
        If (-not $PSBoundParameters.LineNumber) {
            $LineNumber = $MyInvocation.ScriptLineNumber
        }

        $LogValue = "{0}`tLine {1}`t{2}" -f (Get-Date -Format G), ("{0:d3}" -f $LineNumber), $Message
        Add-Content -Path $LogPath -Value $LogValue

        If ($PSBoundParameters.Exit -eq $True) {
            Get-PSSession | Remove-PSSession
            Exit
        }
    }
    end {}
}
Function Add-LogError {
    <#
  .SYNOPSIS
    Writes an error to a log file

  .DESCRIPTION
    Writes the passed error to a new line at the end of the specified log file

  .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log

  .PARAMETER ErrorDesc
    Mandatory. The description of the error you want to pass (use $_.Exception)

  .PARAMETER ExitGracefully
    Mandatory. Boolean. If set to True, runs Stop-Log and then exits script

  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support. Added -ExitGracefully parameter functionality

    Version:        1.2
    Author:         Jason Diaz
    Creation Date:  08/01/2020
    Purpose/Change: Replaced Most\All of Process with Rick.A Function.

  .EXAMPLE
    Add-LogError -LogPath "C:\Windows\Temp\Test_Script.log" -ErrorDesc $_.Exception -ExitGracefully $True
  #>

    [CmdletBinding()]

    Param ([Parameter(Mandatory = $true)][string]$LogPath, [Parameter(Mandatory = $true)][string]$ErrorDesc, [Parameter(Mandatory = $true)][boolean]$ExitGracefully, [Parameter()][int]$LineNumber)

    Process {

        If (-not $PSBoundParameters.LineNumber) {
            $LineNumber = $MyInvocation.ScriptLineNumber
        }

        $LogValue = "{0}`tLine {1}`t{2}" -f (Get-Date -Format G), ("{0:d3}" -f $LineNumber), $ErrorDesc
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
Function Stop-Log {
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

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  01/08/12
    Purpose/Change: Added option to not exit calling script if required (via optional parameter)

  .EXAMPLE
    Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log"

  .EXAMPLE
    Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log" -NoExit $True
  #>

    [CmdletBinding(SupportsShouldProcess)]

    Param ([Parameter(Mandatory = $true)][string]$LogPath, [Parameter(Mandatory = $false)][string]$NoExit)

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
Function Send-Log {
    <#
  .SYNOPSIS
    Emails log file to list of recipients

  .DESCRIPTION
    Emails the contents of the specified log file to a list of recipients

  .PARAMETER LogPath
    Mandatory. Full path of the log file you want to email. Example: C:\Windows\Temp\Test_Script.log

  .PARAMETER EmailFrom
    Mandatory. The email addresses of who you want to send the email from. Example: "admin@9to5IT.com"

  .PARAMETER EmailTo
    Mandatory. The email addresses of where to send the email to. Seperate multiple emails by ",". Example: "admin@9to5IT.com, test@test.com"

  .PARAMETER EmailSubject
    Mandatory. The subject of the email you want to send. Example: "Cool Script - [" + (Get-Date).ToShortDateString() + "]"

  .INPUTS
    Parameters above

  .OUTPUTS
    Email sent to the list of addresses specified

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  05.10.12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Jason Diaz
    Creation Date:  08/01/2020
    Purpose/Change: Renamed functions to approved verbs

  .EXAMPLE
    Send-Log -LogPath "C:\Windows\Temp\Test_Script.log" -EmailFrom "admin@9to5IT.com" -EmailTo "admin@9to5IT.com, test@test.com" -EmailSubject "Cool Script - [" + (Get-Date).ToShortDateString() + "]"
  #>

    [CmdletBinding()]

    Param ([Parameter(Mandatory = $true)][string]$LogPath, [Parameter(Mandatory = $true)][string]$EmailFrom, [Parameter(Mandatory = $true)][string]$EmailTo, [Parameter(Mandatory = $true)][string]$EmailSubject)

    Process {
        Try {
            $sBody = (Get-Content $LogPath | Out-String)

            #Create SMTP object and send email
            $sSmtpServer = "smtp.iheartmedia.com"
            $oSmtp = New-Object Net.Mail.SmtpClient($sSmtpServer)
            $oSmtp.Send($EmailFrom, $EmailTo, $EmailSubject, $sBody)
            Exit 0
        }

        Catch {
            Exit 1
        }
    }
}