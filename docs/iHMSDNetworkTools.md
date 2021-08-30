---
Module Name: iHMSDNetworkTools
Module Guid: 92f444eb-b0f0-4597-85bc-05a9d89a2021
Download Help Link: NA
Help Version: 0.0.4
Locale: en-US
---

# iHMSDNetworkTools Module
## Description
This module gathers network information and sends to the a shared network folder for troubleshooting.

## iHMSDNetworkTools Cmdlets
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


