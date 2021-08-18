function Invoke-Speedtest {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Mandatory=$False)]
        [switch]$Worldwide,
        [Parameter(Mandatory=$True)]
        [int32]$TestCount="5",
        [Parameter(Mandatory=$True)]
        [int32]$Size="1000"
    )
    begin{
        $SpeedResults = [System.Collections.ArrayList]@()
        Function downloadSpeed($strUploadUrl) {
            #Transform the server urls needed
            $Filesize = "$($Size)x$($Size)"
            $topServerUrlSpilt = $strUploadUrl -split 'upload'
            $url = $topServerUrlSpilt[0] + "random" + "$($Filesize)" + ".jpg"
            #Now download some temp files and calculate speed
            $downloadfile = {Invoke-WebRequest -Uri $url}
            $downloadElaspedTime = (Measure-Command $downloadfile).totalmilliseconds
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