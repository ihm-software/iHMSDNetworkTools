---
Module Name: iHMSDNetworkTools
Module Guid: 92f444eb-b0f0-4597-85bc-05a9d89a2021
Download Help Link: NA
Help Version: 0.0.1
Locale: en-US
---

# iHMSDNetworkTools Module
## Description
This module gathers network information and sends to the a shared network folder for troubleshooting.

## iHMSDNetworkTools Cmdlets
### [Add-LogError](Add-LogError.md)
Add-LogError Writes a pipelined error to a new line at the end of the specified log file.
Used in conjunction with Start-Log and Stop-Log

### [Add-LogMessage](Add-LogMessage.md)
Allows for writing a log formatted with the date, line number, and message.
Used in conjunction with Start-Log and Stop-Log

### [Get-NetworkInformation](Get-NetworkInformation.md)
This function outputs a system object that contains all network interface details for the client.

### [Invoke-SharepointUpload](Invoke-SharepointUpload.md)
Connects and uploads a specified file to an anonymous sharepoint online shared document library.
Script supports bit.ly shortened links

### [Invoke-Speedtest](Invoke-Speedtest.md)
Connects to speedtest.net, downloads the list of servers, calculates the closest servers, and tests download.
User can select image size and number of servers to test with.

### [Send-NetworkInformation](Send-NetworkInformation.md)
This script combines functions to check network information and speedtest results.
Local file is named "[DATETIME]_[COMPUTERNAME].txt" and locationed in script root
Then uploads text file to an anonymous sharepoint online document library.

### [Start-Log](Start-Log.md)
Creates log file with path and name that is passed. Checks if log file exists, and if it does deletes it and creates a new one.
Once created, writes initial logging data

### [Stop-Log](Stop-Log.md)
Writes finishing logging data to specified log and then exits the calling script


