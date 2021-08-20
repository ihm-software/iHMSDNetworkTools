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
        [ValidateNotNullOrEmpty()]
        [String]$Filename = "$(Get-Date -Format yyyy-M-d_hh.mm.tt)_$([Environment]::MachineName).txt" ,
        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $True, HelpMessage = "Please enter the shared upload link")]
        [ValidateNotNullOrEmpty()]
        [String]$AnonUrl = 'https://bit.ly/ihmnetwizupload'
    )
    begin {
        $Now = Get-Date -Format yyyy-M-d_hh.mm.tt
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
            Add-LogError -LogPath $LogFile -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -ErrorDesc "[ERR]: $($PSItem.Exception.Message)" -ExitGracefully $false
        }
    }
    end{
        try{
            Invoke-SharepointUpload -AnonURL $AnonURL -Filepath $Filepath
        }
        catch{
            Add-LogError -LogPath $LogFile -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -ErrorDesc "[ERR]: $($PSItem.Exception.Message)" -ExitGracefully $false
        }
        finally{
            . $filepath
            Stop-Log -LogPath $LogFile
        }
    }
}
#End of File
# SIG # Begin signature block
# MIISHwYJKoZIhvcNAQcCoIISEDCCEgwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5QhrcAKPCEO/zeJsX3n5KE5V
# kDmggg5rMIIGsDCCBJigAwIBAgIQCK1AsmDSnEyfXs2pvZOu2TANBgkqhkiG9w0B
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
# hkiG9w0BCQQxFgQUpDuaB1M+sxTqs/3MbDZ1aid5QG4wDQYJKoZIhvcNAQEBBQAE
# ggIAyoCp9r2ynHpfzx6ioHgdD+aFi2RjZTRXryOGDafNXFujGvN5JRYyi10qaROo
# b3z7xGGm+7X7J+y9z1UXvSkojQAAEV+SKM+2D5Z4OYiZvVQ6GCtJpc0+n2lBxjXj
# YFxZdrUS8V++80I4qheBCljIaD0n78y1FF7juRjvEXvZwYIpK6CczPyOYhbc3YgT
# hFFAgkB457kf/dkLhRzb9s7HA1c7XnlmOQ2QnTHAbFqWcKoGY8h7vDWOP1cS9P9U
# aVWBDF6v2kMkMZ0CkZPiXFPo7/JCvPwCp9YMuYGpsEq6I6SJG/RInkjbGEw9K3P/
# ldBYjNYlIslC3KvuL21RyI6skZJT0lUEIeZBySu49F6Zf1jqtQQf76qPRMdvBK72
# WisTAnh8nxKDnyXbyOV9EoYYrJo+2lCfG/dRnQJRiODyMrg1/YnG4q0KtRKRKJMh
# WjWJtWHLvzBiXOVXUXSrogSvfjXGEVGRgymLOSTIR4UGh0IK6E++Wy/4nPdPcS3k
# 59SXzRxOLjcl4tKOhEUZ+uNp8IM6v2IY6oLcQMWJg7Q+E0486izHcm2rIOOj1sJv
# 7eXh2MGjXgrbzmmtndq7NmxRfuWj6HVxHHIkrjuTaOGn//Ie/jwj76fqNkS9+U0U
# fXZZ/f0Rk4oQQZal/IUdmV/fA4BPkCYBavfL9KranEurTrY=
# SIG # End signature block
