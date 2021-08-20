﻿Function Start-Log {
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
# SIG # Begin signature block
# MIISHwYJKoZIhvcNAQcCoIISEDCCEgwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUibpejtH8seH3g8rGFJKWoBeB
# /t6ggg5rMIIGsDCCBJigAwIBAgIQCK1AsmDSnEyfXs2pvZOu2TANBgkqhkiG9w0B
# AQwFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVk
# IFJvb3QgRzQwHhcNMjEwNDI5MDAwMDAwWhcNMzYwNDI4MjM1OTU5WjBpMQswCQYD
# VQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lD
# ZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWduaW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEg
# Q0ExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA1bQvQtAorXi3XdU5
# WRuxiEL1M4zrPYGXcMW7xIUmMJ+kjmjYXPXrNCQH4UtP03hD9BfXHtr50tVnGlJP
# DqFX/IiZwZHMgQM+TXAkZLON4gh9NH1MgFcSa0OamfLFOx/y78tHWhOmTLMBICXz
# ENOLsvsI8IrgnQnAZaf6mIBJNYc9URnokCF4RS6hnyzhGMIazMXuk0lwQjKP+8bq
# HPNlaJGiTUyCEUhSaN4QvRRXXegYE2XFf7JPhSxIpFaENdb5LpyqABXRN/4aBpTC
# fMjqGzLmysL0p6MDDnSlrzm2q2AS4+jWufcx4dyt5Big2MEjR0ezoQ9uo6ttmAaD
# G7dqZy3SvUQakhCBj7A7CdfHmzJawv9qYFSLScGT7eG0XOBv6yb5jNWy+TgQ5urO
# kfW+0/tvk2E0XLyTRSiDNipmKF+wc86LJiUGsoPUXPYVGUztYuBeM/Lo6OwKp7AD
# K5GyNnm+960IHnWmZcy740hQ83eRGv7bUKJGyGFYmPV8AhY8gyitOYbs1LcNU9D4
# R+Z1MI3sMJN2FKZbS110YU0/EpF23r9Yy3IQKUHw1cVtJnZoEUETWJrcJisB9IlN
# Wdt4z4FKPkBHX8mBUHOFECMhWWCKZFTBzCEa6DgZfGYczXg4RTCZT/9jT0y7qg0I
# U0F8WD1Hs/q27IwyCQLMbDwMVhECAwEAAaOCAVkwggFVMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwHQYDVR0OBBYEFGg34Ou2O/hfEYb7/mF7CIhl9E5CMB8GA1UdIwQYMBaA
# FOzX44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAK
# BggrBgEFBQcDAzB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9v
# Y3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4
# oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJv
# b3RHNC5jcmwwHAYDVR0gBBUwEzAHBgVngQwBAzAIBgZngQwBBAEwDQYJKoZIhvcN
# AQEMBQADggIBADojRD2NCHbuj7w6mdNW4AIapfhINPMstuZ0ZveUcrEAyq9sMCcT
# Ep6QRJ9L/Z6jfCbVN7w6XUhtldU/SfQnuxaBRVD9nL22heB2fjdxyyL3WqqQz/WT
# auPrINHVUHmImoqKwba9oUgYftzYgBoRGRjNYZmBVvbJ43bnxOQbX0P4PpT/djk9
# ntSZz0rdKOtfJqGVWEjVGv7XJz/9kNF2ht0csGBc8w2o7uCJob054ThO2m67Np37
# 5SFTWsPK6Wrxoj7bQ7gzyE84FJKZ9d3OVG3ZXQIUH0AzfAPilbLCIXVzUstG2MQ0
# HKKlS43Nb3Y3LIU/Gs4m6Ri+kAewQ3+ViCCCcPDMyu/9KTVcH4k4Vfc3iosJocsL
# 6TEa/y4ZXDlx4b6cpwoG1iZnt5LmTl/eeqxJzy6kdJKt2zyknIYf48FWGysj/4+1
# 6oh7cGvmoLr9Oj9FpsToFpFSi0HASIRLlk2rREDjjfAVKM7t8RhWByovEMQMCGQ8
# M4+uKIw8y4+ICw2/O/TOHnuO77Xry7fwdxPm5yg/rBKupS8ibEH5glwVZsxsDsrF
# hsP2JjMMB0ug0wcCampAMEhLNKhRILutG4UI4lkNbcoFUCvqShyepf2gpx8GdOfy
# 1lKQ/a+FSCH5Vzu0nAPthkX0tGFuv2jiJmCG6sivqf6UHedjGzqGVnhOMIIHszCC
# BZugAwIBAgIQC4uUnYEEkqZXl45C8AoenDANBgkqhkiG9w0BAQsFADBpMQswCQYD
# VQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lD
# ZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWduaW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEg
# Q0ExMB4XDTIxMDgxOTAwMDAwMFoXDTI0MDgyMTIzNTk1OVowgZExCzAJBgNVBAYT
# AlVTMQ4wDAYDVQQIEwVUZXhhczEUMBIGA1UEBxMLU2FuIEFudG9uaW8xGDAWBgNV
# BAoTD2lIZWFydE1lZGlhIEluYzEYMBYGA1UEAxMPaUhlYXJ0TWVkaWEgSW5jMSgw
# JgYJKoZIhvcNAQkBFhlqYXNvbmRpYXpAaWhlYXJ0bWVkaWEuY29tMIICIjANBgkq
# hkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAzwFKEHyjnklNdp7ihTgHx2RZF2zj7Pmj
# b7FLColo/q+K7rCe9M8uhP/jV7oTPVVev9FyLbxmQ+nK8ZSGPq51laRVavkElDAm
# 08BnVmg3czAlIHaX8inEDX4OQmLwcZnB+leoVAMiPUkECHSkriv0tlNjLxas/GVk
# 3CYFMwWWfYizg99/z+9nrN5rcQdnJmELUu2+u2Lnf7hmjePVch1MyJVry8j6iHX0
# d3cb9q6kHehi77L/2Rl5PKK/Nr980S8WIv3Yz9uc1BEh+pOle3u/sXXxPXmSzbVs
# v5XzEmpwg5brFo+X1PEjV0uh5fIUV6WhAdlQyoEsgcAcZqlQ19U++3PBBNOxxx3y
# QTM54GHGVuXlKmDX7hv5Pe+AwmfkyNt43pZu5V8SPxnX/IWHNHdU8gFPMAF9TyNk
# Hs2wyc1A129zSMY9n/5ijZTH+K27ys/K66DMAuMWFauShwzflHEL3kdY4vK2yPua
# eDuPmCrE3nH9u52KxT6GrY+4wNNNKLODZ6JVYfLsrWP+0qsw48Ij2yExMNI+8v2/
# klS5CveNlxK38Hj4UUx5aaFAr9cvCz78JzBr6Io5+aToCvCDerlyHAl8L//2XqzJ
# fDnixQakDZgOD/Ct6UIsXaNuBUQj3mgH88c7j/cZDgHitj1Q+eZTNkyjlsKXF9uQ
# Xy/KbRVN06kCAwEAAaOCAiwwggIoMB8GA1UdIwQYMBaAFGg34Ou2O/hfEYb7/mF7
# CIhl9E5CMB0GA1UdDgQWBBRonEnSw4DwkWzLOxVp/+3QoN6KeTAkBgNVHREEHTAb
# gRlqYXNvbmRpYXpAaWhlYXJ0bWVkaWEuY29tMA4GA1UdDwEB/wQEAwIHgDATBgNV
# HSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQw
# OTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAy
# MUNBMS5jcmwwPgYDVR0gBDcwNTAzBgZngQwBBAEwKTAnBggrBgEFBQcCARYbaHR0
# cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMIGUBggrBgEFBQcBAQSBhzCBhDAkBggr
# BgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMFwGCCsGAQUFBzAChlBo
# dHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2Rl
# U2lnbmluZ1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNydDAMBgNVHRMBAf8EAjAAMA0G
# CSqGSIb3DQEBCwUAA4ICAQCR4KHWPWCpnZdNMnMaw/cu9Wyj53axIQLnWmAzz7wP
# qsqaut589HVKLx43on4fWPYWvybKCZSXVtNT+Z5J/KnRWXfYIgAFZHUaNPA8eVyU
# U6BfO0evTCDw3RrVvpmDaYEak+RUv4njQGA7YTwJ6wwvIKwj/CWhY5JuCT9g032W
# ivvnv4TPU6HnbhbSB3jGKzjn5XyaRpnabYmKVmdY6O/UEA62TYAGhExFOf6WOEMk
# RHTFZj+Y9gyGgNEXDz35bvO/wsw8vsa4BRCXRYsEmiedbpdjJHnD/ebBWUDTU8zX
# jDfax0jtkrdM+hfafOl2tdRWD2xd1le/oJAYCwGa4kk0RgHzmfH3p7A7Io1XFz9o
# MTl7sYzZcD/k6Nafbhto5bdwLkVIE6pZllBDydQqC1AtG3Y9TnWQ/2X6vvwK0Jkl
# JG1/itaw2d/GaQfcKEEfC8+TXtb/d1gRHlqiXJGn5/tJ8vpBPInc2/rvPdqPpZUF
# rPzM77bZiSSzKGNEgCgUbHFTdryR2tbERRXX5yiXa/Q+2Ej3ZijPKuHbMoADt/8C
# K0ydNT+oCYDgjglU5Pgm/sF3Ls4YAdizBBvgNyL7g1MsZdYerOoqWphJGLX36Ffp
# +YtG5mHS9bY/o/4Da/PtBl6JkowcAewPHG0RMI5NEA7pIUIgVkjh+a9WyYJPWYo5
# /DGCAx4wggMaAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0
# LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmlu
# ZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMQIQC4uUnYEEkqZXl45C8AoenDAJBgUr
# DgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkq
# hkiG9w0BCQQxFgQUAhFb1t7mmWFyBk0/EiSkzpw0JqcwDQYJKoZIhvcNAQEBBQAE
# ggIAGS1uKkRLiLKVKgqhHtGg4P4JOvJgQ9C6IviZqx5M67+IhdDNkwd2bDLuLFTP
# ygZ7tLx0WKOfgDW5s+LeUDcuiLRwB1XJiRRT/cTVMLmGgCE+1eXUW7r7fG5PwGAp
# dXCtmrYQGGlpLHcPvA43IJWmBrKHlUwM9coVgOQ8zSl04l04oQdoz6myuCpLBSqL
# J2Sulv7wMK/EH7u9Mcfq9m0EqiGFu79rFgNOrcm07Rrv3YECchJoy9792vD9N6/S
# 0RjG5+sE+mTg6x8GCUUfrf+3pAXUIhgh00j9ePuLW8hoZraXF6z1AirHCDLZrNYF
# uQkg3V55G+b5DUh3HZelX+V+f9liXc+y7abH1a2gl9LbBizmn+vj5uAD02pYcYYb
# nr1Pu0FQV6FZU9Ii5LC6VNfTxnEH7CgEyD9t4pa9cdOnYGwJ5xvrUzhfzja50y2d
# WUoeQ7hNRZLYbr0ZHX8n2tBscDPO03u3NuRsAqE1AzFj+/i2IGQnSa7XY9kTLQVz
# pfYrMWYQRZ55TwTRH9p+LILCmTxLSBChywDfn6QCcrZIg+Q67lam0mJeoYcUFcjL
# wGRUF2cCFJMszNb+bHK/b5RH5rm/PnQW8nz0GJrmF8FzO2QIfTW90j9bbRW0984I
# wXUid8KXVTr2h01eRoJ/cX1DyuUmOT5yyzEQ9Q57M178IVU=
# SIG # End signature block
