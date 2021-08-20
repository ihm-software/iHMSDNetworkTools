@{
    #________________________________________
    #IncludeDefaultRules
    IncludeDefaultRules = $true
    #________________________________________
    #Severity
    #Specify Severity when you want to limit generated diagnostic records to a sepecific subset: [ Error | Warning | Information ]
    Severity            = @('Error', 'Warning')
    #________________________________________
    #CustomRulePath
    #Specify CustomRulePath when you have a large set of custom rules you'd like to reference
    #CustomRulePath = "Module\InjectionHunter\1.0.0\InjectionHunter.psd1"
    #________________________________________
    #IncludeRules
    #Specify IncludeRules when you only want to run specific subset of rules instead of the default rule set.
    #IncludeRules = @('PSShouldProcess',
    #                 'PSUseApprovedVerbs')
    #________________________________________
    #ExcludeRules
    #Specify ExcludeRules when you want to exclude a certain rule from the the default set of rules.
    #ExcludeRules = @(
    #    'PSUseDeclaredVarsMoreThanAssignments'
    #)
    #________________________________________
    #Rules
    #Here you can specify customizations for particular rules. Several examples are included below:
    #Rules = @{
    #    PSUseCompatibleCmdlets = @{
    #        compatibility = @('core-6.1.0-windows', 'desktop-4.0-windows')
    #    }
    #    PSUseCompatibleSyntax = @{
    #        Enable = $true
    #        TargetVersions = @(
    #            '3.0',
    #            '5.1',
    #            '6.2'
    #        )
    #    }
    #    PSUseCompatibleCommands = @{
    #        Enable = $true
    #        TargetProfiles = @(
    #            'win-8_x64_10.0.14393.0_6.1.3_x64_4.0.30319.42000_core', # PS 6.1 on WinServer-2019
    #            'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework', # PS 5.1 on WinServer-2019
    #            'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # PS 3 on WinServer-2012
    #        )
    #    }
    #    PSUseCompatibleTypes = @{
    #        Enable = $true
    #        TargetProfiles = @(
    #            'ubuntu_x64_18.04_6.1.3_x64_4.0.30319.42000_core',
    #            'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework'
    #        )
    #        # You can specify types to not check like this, which will also ignore methods and members on it:
    #        IgnoreTypes = @(
    #            'System.IO.Compression.ZipFile'
    #        )
    #    }
    #}
    #________________________________________
}

# SIG # Begin signature block
# MIISHwYJKoZIhvcNAQcCoIISEDCCEgwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUMqOtEDscc5DSpim9azwAIBuI
# +Dqggg5rMIIGsDCCBJigAwIBAgIQCK1AsmDSnEyfXs2pvZOu2TANBgkqhkiG9w0B
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
# hkiG9w0BCQQxFgQURwgaZJiK5PWa/WZ1354HCaLmOCYwDQYJKoZIhvcNAQEBBQAE
# ggIAhgomgrCbGSQUHkwOneqGsld7mvivLa7r84FYMp2/R3p8LXk/7ZBv50PkMd0t
# DekBDopoRHf7ly3VIhg1HjiNLwAfkNUGSyuWBNrWsMJ/5WQbvxwGFzh1hHnQvPtB
# Md1+eOOvUW5Ve3JyXVCFISUFIz+PIqhetJeKCi9Q+debIlpjT3SfimF0jNJ9vPqz
# qUOTcNVoR04EZZ16/XGG11L03bIVogDa2WytE8kOgkf1AxlhjY0hdb3mCCt+Omon
# dc6i+H2kObcQr4nw3prKPJERKmFfgok9S+Cfc0twVzhEiMrF35Qfk8ZR8Y9RkPb5
# SgCVbX4uPB5+n+qgPJgbRv5xmiJ2DIgtOo2329SSjmU0QHM4bGig4U1Y3v3wVCPL
# m765GiAvmdK0JJ0bJyZBSRNRgq8/eDh2LXE5zNzy3XtUAAS+kbBvYGuHnLAr5rMV
# 5M/Fvelwt1Lb94EtINhwXM6SFQt1BfaJ5cCrUAm2RNILicTXtdp+/SWT+lgLfZM3
# lx+v5DYM3wgUsqf9fWm6kepK7jDnmR9bVBWNhognoUweGnT2ifMvT+ICwsUWeqgu
# hdSrAzzimZPSKdIjVwRmjV3awcMw91sGBoJcLA2DP+isl5QsvVsfHRqnDliCYBxP
# AgpqHp8+tXDE06Lv4H4X7WJIvsUPzI27/D/llSEUcG7koJs=
# SIG # End signature block
