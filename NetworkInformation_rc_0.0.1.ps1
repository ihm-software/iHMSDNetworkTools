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
function Get-NetworkInformation {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType('System.Object[]')]
    param (
        [Parameter(Mandatory=$False)][ValidateSet("Up","Down")]
        [string]$InterfaceStatus,
        [Parameter(Mandatory=$False)][ValidateSet("IPv4","IPv6")]
        [string]$AddressFamily
    )
    begin{
        if ($AddressFamily) {
            if ($AddressFamily -eq "IPv4") {
                $AddrFam = "InterNetwork"
            }
            if ($AddressFamily -eq "IPv6") {
                $AddrFam = "InterNetworkV6"
            }
        }
    }
    process {
        [System.Collections.Arraylist]$PSObjectCollection = @()
        $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
        $InterfacesToExplore = $interfaces
        if ($InterfaceStatus) {
            $InterfacesToExplore = $InterfacesToExplore | Where-Object {$_.OperationalStatus -eq $InterfaceStatus}
        }
        if ($AddressFamily) {
            $InterfacesToExplore = $InterfacesToExplore | Where-Object {$($_.GetIPProperties().UnicastAddresses | ForEach-Object {$_.Address.AddressFamily}) -contains $AddrFam}
        }
        foreach ($adapter in $InterfacesToExplore) {
            $ipprops = $adapter.GetIPProperties()
            $ippropsPropertyNames = $($ipprops | Get-Member -MemberType Property).Name
            if ($AddressFamily) {
                $UnicastAddressesToExplore = $ipprops.UnicastAddresses | Where-Object {$_.Address.AddressFamily -eq $AddrFam}
            }
            else {
                $UnicastAddressesToExplore = $ipprops.UnicastAddresses
            }
            foreach ($ip in $UnicastAddressesToExplore) {
                $FinalPSObject = [pscustomobject]@{}
                $adapterPropertyNames = $($adapter | Get-Member -MemberType Property).Name
                foreach ($adapterPropName in $adapterPropertyNames) {
                    $FinalPSObjectMemberCheck = $($FinalPSObject | Get-Member -MemberType NoteProperty).Name
                    if ($FinalPSObjectMemberCheck -notcontains $adapterPropName) {
                        $FinalPSObject | Add-Member -MemberType NoteProperty -Name $adapterPropName -Value $($adapter.$adapterPropName)
                    }
                }
                foreach ($ippropsPropName in $ippropsPropertyNames) {
                    $FinalPSObjectMemberCheck = $($FinalPSObject | Get-Member -MemberType NoteProperty).Name
                    if ($FinalPSObjectMemberCheck -notcontains $ippropsPropName -and
                        $ippropsPropName -ne "UnicastAddresses" -and $ippropsPropName -ne "MulticastAddresses") {
                        $FinalPSObject | Add-Member -MemberType NoteProperty -Name $ippropsPropName -Value $($ipprops.$ippropsPropName)
                    }
                }
                $ipUnicastPropertyNames = $($ip | Get-Member -MemberType Property).Name
                foreach ($UnicastPropName in $ipUnicastPropertyNames) {
                    $FinalPSObjectMemberCheck = $($FinalPSObject | Get-Member -MemberType NoteProperty).Name
                    if ($FinalPSObjectMemberCheck -notcontains $UnicastPropName) {
                        $FinalPSObject | Add-Member -MemberType NoteProperty -Name $UnicastPropName -Value $($ip.$UnicastPropName)
                    }
                }
                $null = $PSObjectCollection.Add($FinalPSObject)
            }
        }
    }
    end {
        return $PSObjectCollection
    }
}
New-Alias -Name ifconfig -Value Get-NetworkInformation
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
function Invoke-Speedtest {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Mandatory=$False)]
        [switch]$Worldwide,
        [Parameter(Mandatory=$False)]
        [int32]$TestCount="5",
        [Parameter(Mandatory=$False)]
        [int32]$Size="2000"
    )
    begin{
        $SpeedResults = [System.Collections.ArrayList]@()
        $Filesize = "$($Size)x$($Size)"
        Function downloadSpeed($strUploadUrl) {
            #Transform the server urls needed
            $topServerUrlSpilt = $strUploadUrl -split 'upload'
            $url = $topServerUrlSpilt[0] + "random" + "$($Filesize)" + ".jpg"
            #Now download some temp files and calculate speed
            $downloadElaspedTime = (Measure-Command {$script:downloadfile = Invoke-WebRequest -Uri $url}).totalmilliseconds
            $downSize = (($downloadfile).rawcontent.length) / 1Mb
            $downloadSize = [Math]::Round($downSize, 2)
            $downloadTimeSec = $downloadElaspedTime * 0.001
            $downSpeed = ($downloadSize / $downloadTimeSec) * 8
            $downloadSpeed = [Math]::Round($downSpeed, 2)
            #Hashtable containing results
            $SpeedResults.add(
                [PSCustomObject]@{
                    "Test Site"          = [string]$url.split(":8080/speedtest/")[0]
                    "Speed(Mb)"          = [string]$downloadSpeed
                    "Size(MiB)"          = [string]$downloadSize
                    "Download time(sec)" = [string]$downloadTimeSec
                    "Image Size"         = [string]$Filesize
                }
            )
        }
    }
    process {
        #Invoke a call to speedtest's config servers
        $SpeedtestConfig = (Invoke-RestMethod -Uri "http://www.speedtest.net/speedtest-config.php" -SessionVariable speedtest)
        #Speedtest will provide Latitude and Longitude of client IP
        $ClientLat = $SpeedtestConfig.settings.client.lat
        $ClientLon = $SpeedtestConfig.settings.client.lon
        #Making another request to get the server list from the site.
        $SpeedtestServers = (Invoke-RestMethod -Uri "http://www.speedtest.net/speedtest-servers.php" -WebSession $speedtest)
        #$Serverlist can be filtered to just US servers in the speedtest.net database.
        $Serverlist = switch ($Worldwide){
            $True   {$SpeedtestServers.settings.servers.server }
            $False  {$SpeedtestServers.settings.servers.server | Where-Object {$PSItem.Country -eq "United States"}}
        }
        #Below we calculate servers relative closeness to you by doing some math against latitude and longitude.
        foreach($Server in $Serverlist) {
            $R = 6371;
            [float]$dlat = ([float]$ClientLat - [float]$Server.lat) * 3.14 / 180;
            [float]$dlon = ([float]$ClientLon - [float]$Server.lon) * 3.14 / 180;
            [float]$a = [math]::Sin([float]$dLat/2) * [math]::Sin([float]$dLat/2) + [math]::Cos([float]$ClientLat * 3.14 / 180 ) * [math]::Cos([float]$Server.lat * 3.14 / 180 ) * [math]::Sin([float]$dLon/2) * [math]::Sin([float]$dLon/2);
            [float]$c = 2 * [math]::Atan2([math]::Sqrt([float]$a ), [math]::Sqrt(1 - [float]$a));
            [float]$d = [float]$R * [float]$c;
            $ServerInformation +=
            @([pscustomobject]@{Distance = $d; Country = $Server.country; Sponsor = $Server.sponsor; Url = $Server.url })
        }
        #Now create a list of closest servers to client
        $Localservers = ($serverinformation | Sort-Object -Property distance)[0..($TestCount)]
        ForEach ($lserver in $Localservers) {
            $currenturl = $lserver.url
            downloadSpeed($currenturl) | Out-Null
        }
        $SpeedResults = $SpeedResults | Sort-Object -Property Speed
    }
    end {
        Return $SpeedResults
    }
}
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

Send-NetworkInformation
# SIG # Begin signature block
# MIISHwYJKoZIhvcNAQcCoIISEDCCEgwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUQGpG4n9EAN56zcIr4fxEo7Bd
# 2PSggg5rMIIGsDCCBJigAwIBAgIQCK1AsmDSnEyfXs2pvZOu2TANBgkqhkiG9w0B
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
# hkiG9w0BCQQxFgQU2ArQNWr9nVq/E3ICVSBGNuLYFLswDQYJKoZIhvcNAQEBBQAE
# ggIASuzGses6A1VRH8l7uJ/+uEOeANc3pKDKIwNFN95uhg2ZbJyjiGy7nWq+oV4+
# PfISs8YTg/YJxgAHk2W3rrKP3MvapILjdPCjxS/2WrQrLpUBvm6c1j6IgmX+AY8X
# p0+439NtfbXrs2O1zs+/9P7gkiqFzJjVi92f4ww3soZ1MV4T8JfnyFcmFmlHIw9z
# m5lNvAEEtXVfYTFqGpMMV7xeMqkIGFwVbjsNoBFQ4qjRh2N1IDcxQwfJ3LdnzokX
# Ok9DHUPiZVsfg8IidmaFWrssice28/vCEMS2j/6rM10GMQbQuTqQzUq1O2t5cpC2
# T0ZutnKRCWvlcGb986ys9/+Gs8hu4QKEQcGA0JDY24SRZXzrThXebRq7J99nGiQ3
# 3Ih9nzuVNnGqt9iKrzwJm9gYnT5uEoSqrhSIUJGRpY8jlXrSijvS4neTdZpWHE5v
# 5wsDktybDZZ9HP0M75OyTia/0RrPDnNtcZyzby85jOWCmfbEF94oIvp5urWAmug0
# F5s7QgSD4fgZcTJIlcuDvf4Rw+A36G8saLfixHSLZqJ2ANpnTq86MU+tSSJnVdNQ
# fF+wu+fYMXi5bAp/ce4pNQbB3Z/wr2PysB602auxn0f0RkITLyj+x8BHm+x6NUyq
# Ozxxr9m6cxpUvtPAZZ/rKRknIWM64nlPTVDSJ9bchqbiCfM=
# SIG # End signature block
