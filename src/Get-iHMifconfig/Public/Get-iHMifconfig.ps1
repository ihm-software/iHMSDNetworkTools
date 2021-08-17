<#
.SYNOPSIS
    Network troubleshooting tool

.DESCRIPTION
    This script checks network information and outputs this IP Address and Network Speedtest results to local text file.
    Then uploads text file to an anonymous sharepoint online document library.

.PARAMETER Filename
    The name of the information file. By default, this is the current time and computer hostname.

.PARAMETER AnonURL
    This is the shared link created by sharepoint online when sharing to "Everyone". This script does not support authenticated links.

.PARAMETER US
    Switch to specify US speedtest servers only

.PARAMETER TestCount
    Switch to specify how many speedtest servers to test

.PARAMETER Size
    Size in Pixels^2 for the download test image (ex $size = "2000" is a 2000x2000 image)

.OUTPUTS
    Text file where script was executed, default is "[DATETIME]_[COMPUTERNAME].txt"
    Text file on sharepoint online library

.NOTES
    Version:        1.0.0
    Author:         Jason Diaz
    Creation Date:  09/08/2021
    Purpose/Change: Network Info and Upload

    Version:        1.0.1
    Author:         Jason Diaz
    Creation Date:  09/08/2021
    Purpose/Change: Speedtest

    Version:        1.0.2
    Author:         Jason Diaz
    Creation Date:  09/08/2021
    Purpose/Change: Error traps, remove (most)debug lines, add line comments

.EXAMPLE
    Upload network information to https://bit.ly/ihmnetwizupload 
    Get-iHMifconfig -AnonURL "https://bit.ly/ihmnetwizupload"

.EXAMPLE
    Upload network information with custom file name to https://bit.ly/ihmnetwizupload 
    Get-iHMifconfig -Filename "Myfile.txt" -AnonURL "https://bit.ly/ihmnetwizupload"
#>
[CmdletBinding(DefaultParameterSetName = "Default")]
param (
    [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $True, HelpMessage = "Please enter a custom name for the output file.")]
    [ValidateNotNullOrEmpty()]
    [String]$Filename = "$($Now)_$([Environment]::MachineName).txt" ,
    [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $True, HelpMessage = "Please enter the shared upload link")]
    [ValidateNotNullOrEmpty()]
    [String]$AnonUrl = 'https://bit.ly/ihmnetwizupload',
    [Parameter(Mandatory=$False)]
    [switch]$US,
    [Parameter(Mandatory=$False)]
    [int32]$TestCount = "5",
    [Parameter(Mandatory=$False)]
    [int32]$Size = "1000"
    )
begin {
    $Now = get-date -Format yyyy-M-d_hh.mm.tt
    $ScriptName = "Get-IHMifconfig"
    $ScriptVersion = "1.0.2"
    $Global:ErrorActionPreference = "Stop" 
    #Initiate Functions
    Function Start-Log {
        [CmdletBinding()]
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
    Function Stop-Log {
        [CmdletBinding()]
        Param ([Parameter(Mandatory = $true)]$LogPath, [Parameter(Mandatory = $false)]$NoExit)
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
    function Invoke-Speedtest {
        [CmdletBinding(DefaultParameterSetName = "Default")]
        param (
            [Parameter(Mandatory=$False)]
            [switch]$US,
            [Parameter(Mandatory=$True)]
            [int32]$TestCount,
            [Parameter(Mandatory=$True)]
            [int32]$Size
        )
        begin{
            $SpeedResults = [System.Collections.ArrayList]@()
            Function downloadSpeed($strUploadUrl) {
                #Transform the server urls needed
                $topServerUrlSpilt = $strUploadUrl -split 'upload'
                $url = $topServerUrlSpilt[0] + "random" + "$($Size)" + "x" + "$($Size)" + ".jpg"
                #Now download some temp files and calculate speed
                $downloadElaspedTime = (measure-command {$webpage1 = Invoke-WebRequest -Uri $url}).totalmilliseconds
                $downSize = ($webpage1.rawcontent.length) / 1Mb
                $downloadSize = [Math]::Round($downSize, 2)
                $downloadTimeSec = $downloadElaspedTime * 0.001
                $downSpeed = ($downloadSize / $downloadTimeSec) * 8
                $downloadSpeed = [Math]::Round($downSpeed, 2)
                #Hashtable containing results
                $SpeedResults.add(
                    [PSCustomObject]@{
                    "Test Site"             = [string]$url.split(":8080/speedtest/")[0]
                    "Speed(Mb)"             = [string]$downloadSpeed
                    "Size(MiB)"             = [string]$downloadSize
                    "Download time(sec)"    = [string]$downloadTimeSec
                    }
                )
            }
        }
        process {
            #Invoke a call to speedtest's config servers
            $SpeedtestConfig = (Invoke-RestMethod -uri "http://www.speedtest.net/speedtest-config.php" -SessionVariable speedtest)
            #Speedtest will provide Latitude and Longitude of client IP
            $ClientLat = $SpeedtestConfig.settings.client.lat
            $ClientLon = $SpeedtestConfig.settings.client.lon
            #Making another request to get the server list from the site.
            $SpeedtestServers = (Invoke-RestMethod -uri "http://www.speedtest.net/speedtest-servers.php" -WebSession $speedtest)
            #$Serverlist is filtered to just US servers in the speedtest.net database.
            $Serverlist = $SpeedtestServers.settings.servers.server | Where-Object {$PSItem.Country -eq "United States"}
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
            $Localservers = ($serverinformation | Sort-Object -Property distance)[0..$TestCount]
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
    function Get-NetworkInfo {
        [CmdletBinding(DefaultParameterSetName = "Default")]
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
                            invoke-webrequest -Uri $302CheckUri -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction SilentlyContinue
                        }
                        "desktop" {
                            invoke-webrequest -Uri $302CheckUri -MaximumRedirection 0 -ErrorAction SilentlyContinue
                        }
                    }
                    switch($302Check.StatusCode){
                        "200"   {Throw "Could not find Sharepoint Library ID"}
                        default {
                            #If we get anything except a 200, build a hashtable of header values transformed into sharepoint uri's
                            if ($302Check.headers.location -match "^http"){
                                #below removes urlencode
                                [system.uri]$redirect = $($302Check.headers.location)
                                Do {$redirect = [System.Web.HttpUtility]::UrlDecode($redirect)}
                                While ($redirect -match '%')
                                #Now build uri paths
                                $SPOUrls = [pscustomobject]@{
                                    [system.uri]"site"          =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])"
                                    [system.uri]"api"           =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])_api"
                                    [system.uri]"apicontext"    =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])_api/contextinfo"
                                    [system.uri]"apiweb"        =   "$($redirect.Scheme)://$($redirect.Host)$($redirect.Segments[0])$($redirect.Segments[1])$($redirect.Segments[2])_api/web"
                                    [system.uri]"sharepointid"  =  if($redirect.OriginalString -match "(id=.+)"){($redirect.OriginalString).Split("id=")[1].split("&")[0]}
                                    "filename"                  =   Split-path $Filepath -Leaf
                                }
                                #If we didn't get the sharepoint id need to check next hop
                                [system.uri]$302CheckUri = $($302Check.headers.location)
                            }
                        }
                    }
                }
                Else {Throw "Could not find Sharepoint Library ID"}
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
            $UploadURI = "$($SPOURLS.apiweb)/GetFolderByServerRelativePath(DecodedUrl='$($SPOUrls.sharepointid)')/Files/Add(overwrite=true,Url='$($SPOUrls.filename)')"
        }
        end {   
            #This is the final invoke that uploads the file to the anonymous shared library
            Invoke-WebRequest -Method POST -Uri $UploadURI -ContentType "application/octet-stream" -Headers $headers -InFile $Filepath -WebSession $Session
            return
        }
    }
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
    $Filepath = Join-Path -Path $ScriptPath -Childpath $Filename
}
process{
    try{
        Add-LogEntry -Logpath $LogFile -Message "[NFO]    Beginning Speedtest"
        Invoke-Speedtest -US -TestCount $TestCount -Size $Size | Out-File -FilePath $Filepath -Append
        Add-LogEntry -Logpath $LogFile -Message "[NFO]    Gathering network information"
        Get-NetworkInfo | Out-File -FilePath $Filepath -Append
        Add-LogEntry -Logpath $LogFile -Message "[NFO]    Complete"
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
#End of File