<#
.SYNOPSIS
    Connects and uploads a specified file to an anonymous sharepoint online shared document library.
    Script supports bit.ly shortened links
.DESCRIPTION
    Cross-Platform Sharepoint API File Upload
.PARAMETER AnonURL
    The anonymous share link from sharepoint. Script supports bit.ly shortened links
.PARAMETER Filepath
    The file to upload
.EXAMPLE
    Invoke-SharepointUpload -AnonUrl 'htttps://bit.ly/ihmnetwizupload' -Filepath d:\test\testfile.txt
#>
function Invoke-SharepointUpload {
    [cmdletbinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Mandatory=$true)][ValidatePattern({^https://*.$})]
        [system.uri]$AnonURL,
        [Parameter(Mandatory=$true)]
        [string]$Filepath
    )
    begin {
        #Anonymous sharepoint links are 302 redirects, let's check
        [system.uri]$302CheckUri = [system.uri]$AnonURL
        do {
            If ($302CheckUri -match "^http"){
                $302Check =
                #powershell core and legacy windows powershell have slightly different error ignore commands (a 302 is an error)
                #note to test this against other version specific attributes for performance tuning later
                switch($PSVersionTable.PSEdition){
                    "core" {
                        Invoke-WebRequest -Uri $302CheckUri -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction SilentlyContinue
                    }
                    "desktop" {
                        Invoke-WebRequest -Uri $302CheckUri -MaximumRedirection 0 -ErrorAction SilentlyContinue
                    }
                }
                switch($302Check.StatusCode){
                    "200"   {throw "Could not find Sharepoint Library ID"}
                    default {
                        #If we get anything except a 200, build a hashtable of header values transformed into sharepoint uri's
                        if ($302Check.headers.location -match "^http"){
                            #below removes urlencode
                            [system.uri]$redirect = $($302Check.headers.location)
                            Do {$redirect = [System.Web.HttpUtility]::UrlDecode($redirect)}
                            While ($redirect -match '%')
                            #Now build uri paths
                            $SPOUrls = [pscustomobject]@{
                                uploadfile                 =   $(Split-Path $Filepath -Leaf)
                                [system.uri]"site"         =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])"
                                [system.uri]"api"          =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])_api"
                                [system.uri]"apicontext"   =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])_api/contextinfo"
                                [system.uri]"apiweb"       =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])_api/web"
                                [system.uri]"sharepointid" =   if ($redirect.OriginalString -match "(id=.+)"){ $( ( ( ($redirect.OriginalString).Split("id=")[1] ).split("&")[0] ) ) }
                            }
                            #If we didn't get the sharepoint id need to check next hop
                            [system.uri]$302CheckUri = $($302Check.headers.location)
                        }
                    }
                }
            }
            Else {throw "Could not find Sharepoint Library ID"}
        }
        #keep doing all that stuff until we get a sharepoint id
        until ($null -ne $SPOUrls.sharepointid)
    }
    process {
        #initial web request to establish session cookiecls
        Invoke-WebRequest -Uri $($AnonURL) -Headers @{accept = "application/json; odata=verbose" } -Method GET -SessionVariable Session
        #Now we can make a context call to get our Request Digest
        $ContextInfo = Invoke-RestMethod -Uri $($SPOUrls.apicontext) -Headers @{accept = "application/json; odata=verbose" } -Method Post -Body $null -ContentType "application/json;odata=verbose" -WebSession $session
        $Digest = $ContextInfo.d.GetContextWebInformation.FormDigestValue
        $Headers = @{
            "Content-Type"    = "application/octet-stream"
            "X-RequestDigest" = $Digest
            "accept"          = "application/json;odata=verbose"
        }
        #Building the upload path below using the digest header
        $UploadURI = "$($SPOURLS.apiweb)/GetFolderByServerRelativePath(DecodedUrl='$($SPOUrls.sharepointid)')/Files/Add(overwrite=true,Url='$($SPOUrls.uploadfile)')"
    }
    end {
        #This is the final invoke that uploads the file to the anonymous shared library
        Invoke-WebRequest -Method POST -Uri $UploadURI -ContentType "application/octet-stream" -Headers $headers -InFile $Filepath -WebSession $Session
        return
    }
}
# SIG # Begin signature block
# MIISHwYJKoZIhvcNAQcCoIISEDCCEgwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnths1tVmZ213y6V1lCJd9Qs1
# MvWggg5rMIIGsDCCBJigAwIBAgIQCK1AsmDSnEyfXs2pvZOu2TANBgkqhkiG9w0B
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
# hkiG9w0BCQQxFgQUOoPFIOx0b+ufAm3vf5ozXe39RVIwDQYJKoZIhvcNAQEBBQAE
# ggIADNHJ9ovgvBOAOHQ0C1/TEKxaUEZMCuH8cZBBPiA/yUtdPuaPA5eUheNpxjso
# geNWG7uTpO1+bTvRjAMlPLbK+lt4OoQfrJ/Smby6fi2p3ZYa+lXaZ16KV1aGOIE2
# Kx5Z/v7+BiKv4CcbT3gZKWe3/Lp/Pwe8CTlltrH63RXHzJB5zV/d4dlVAIck13fx
# AkA9wdfikIeUTnJrawdcV7OwiTg5I3VZekrj3Stx/10v0JV1JZLjCHW9JVSqskqE
# 51dP2qFy6EHdRlps6Geheed1hcJEtPYF/Mo5+sjKIVxy5YbSOJZNSpVVy2/E9o8x
# ElwaH8xU57bYvu4IhB/FDe26t8WXBmEEKfk0C7r3rZkjFUmKDvs5nDEPW+/XlFrt
# ek+RcuvVdAEPRxfrrdyYaPsSXNcPjY0va2sac2cSX1iZ5kNl5UXxx8GmrnKatKCy
# J7wcpUlrhawGEKQLrZkmhWKMlukzTZN3LwFLChQH98NAdC2BwrQVWSKv3V8woV0V
# nG7PD8v9GOaUZyEyajVYQN5bAz+G2H+BLwnE48Eq4zM8r89QpnT7EB7BeCIlDHJr
# j4OgAhPJA/h5kdDDhEbVGsjhb1/p3t5WSphOxng4Ixgu9eK0vCM6jU6NaOfD8LJs
# +zExwToirTVJyZaItgRR+ZTdQRA6yzi+Qq2AAHM8YNiLEyc=
# SIG # End signature block
