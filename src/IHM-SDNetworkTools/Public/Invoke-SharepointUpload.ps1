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