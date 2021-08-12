function Get-NetworkInfo {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $False)]
        [ValidateSet("Up", "Down")]
        [string]$InterfaceStatus,

        [Parameter(Mandatory = $False)]
        [ValidateSet("IPv4", "IPv6")]
        [string]$AddressFamily
    )

    ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####

    if ($AddressFamily) {
        if ($AddressFamily -eq "IPv4") {
            $AddrFam = "InterNetwork"
        }
        if ($AddressFamily -eq "IPv6") {
            $AddrFam = "InterNetworkV6"
        }
    }

    ##### END Variable/Parameter Transforms and PreRun Prep #####


    ##### BEGIN Main Body #####

    [System.Collections.Arraylist]$PSObjectCollection = @()
    $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()

    $InterfacesToExplore = $interfaces
    if ($InterfaceStatus) {
        $InterfacesToExplore = $InterfacesToExplore | Where-Object { $_.OperationalStatus -eq $InterfaceStatus }
    }
    if ($AddressFamily) {
        $InterfacesToExplore = $InterfacesToExplore | Where-Object { $($_.GetIPProperties().UnicastAddresses | foreach { $_.Address.AddressFamily }) -contains $AddrFam }
    }

    foreach ($adapter in $InterfacesToExplore) {
        $ipprops = $adapter.GetIPProperties()
        $ippropsPropertyNames = $($ipprops | Get-Member -MemberType Property).Name

        if ($AddressFamily) {
            $UnicastAddressesToExplore = $ipprops.UnicastAddresses | Where-Object { $_.Address.AddressFamily -eq $AddrFam }
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

    $PSObjectCollection

    ##### END Main Body #####
        
}
#Here's the direct sharing link
$AnonURL = "https://iheartmedia.sharepoint.com/:f:/t/CentralizedSupport/ElVPSo2ua5JJsxrfFniDXfIBGErCYawkNZsWKaAHhsoZug"

#Anonymous sharepoint links are 302 redirects, let's check
If ($PSVersionTable.PSEdition -eq "core") {
    $302Check = invoke-webrequest -Uri $AnonURL -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction SilentlyContinue
}
Elseif ($PSVersionTable.PSEdition -eq "desktop") {
    $302Check = invoke-webrequest -Uri $AnonURL -MaximumRedirection 0 -ErrorAction SilentlyContinue
}
#If we did see a 302 then update the url.
If ( (($302Check).StatusCode -eq "302") -and ($302Check.headers.location -like "*sharepoint.com*") ) {
    $SPOAnonURL = $302Check.headers.location
}
Else {$SPOAnonURL = $AnonURL}

#initial web request to establish session
Invoke-WebRequest -Uri $($AnonURL) -Headers @{accept = "application/json; odata=verbose" } -Method GET -SessionVariable Session

#Assuming this is sharepoint, remove extra view info after "&"
$FullURL = ($SPOAnonURL.split("&")[0])

#This will split the FullURL to get a relativefoldername
$SPOfolder = $FullURL.split("=")[1] -replace "Forms.*$", ""

#This will split the fullURL, remove a bunch of end text and add _API address
[string]$SPOApi = ($FullURL -replace "Network.*$") + ("_api")
[string]$ContextURI = ($SPOApi) + ("/contextinfo" )


#Get the output file we just made
$Now = get-date -Format yyyy-M-d_hh.mm.tt
$Localpath = "$pwd"
$LocalFile = "$($Now)_$([Environment]::MachineName).txt"
$Filepath = Join-Path -Path $Localpath -Childpath $LocalFile

#Now we can make a context call to get our Request Digest
$ContextInfo = Invoke-RestMethod -Uri $($ContextURI) -Headers @{accept = "application/json; odata=verbose" } -Method Post -Body $null -ContentType "application/json;odata=verbose" -WebSession $session
$Digest = $ContextInfo.d.GetContextWebInformation.FormDigestValue

$Headers = @{
    "Content-Type"    = "application/octet-stream"
    "X-RequestDigest" = $Digest
    "accept"          = "application/json;odata=verbose"
}
$Upload = "$($SPOApi)/web/GetFolderByServerRelativePath(DecodedUrl='$SPOFolder')/Files/Add(overwrite=true,Url='$LocalFile')"

Get-NetworkInfo | Out-File -FilePath $Filepath
Invoke-WebRequest -Method POST -Uri $Upload -ContentType "application/octet-stream" -Headers $headers -InFile $Filepath -WebSession $Session