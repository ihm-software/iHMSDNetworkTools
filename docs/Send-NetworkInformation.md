---
external help file: iHM-SDNetworkTools-help.xml
Module Name: iHM-SDNetworkTools
online version:
schema: 2.0.0
---

# Send-NetworkInformation

## SYNOPSIS
Network troubleshooting tool

## SYNTAX

```
Send-NetworkInformation [[-Filename] <String>] [[-AnonUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
This script checks network information and outputs this IP Address and Network Speedtest results to local text file.
Then uploads text file to an anonymous sharepoint online document library.

## EXAMPLES

### EXAMPLE 1
```
Upload network information to https://bit.ly/ihmnetwizupload
Send-NetworkInfo -AnonURL "https://bit.ly/ihmnetwizupload"
```

### EXAMPLE 2
```
Upload network information with custom file name to https://bit.ly/ihmnetwizupload
Send-NetworkInfo -Filename "Myfile.txt" -AnonURL "https://bit.ly/ihmnetwizupload"
```

## PARAMETERS

### -Filename
The name of the information file.
By default, this is the current time and computer hostname.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$($Now)_$([Environment]::MachineName).txt"
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AnonUrl
This is the shared link created by sharepoint online when sharing to "Everyone".
This script does not support authenticated links.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Https://bit.ly/ihmnetwizupload
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Text file where script was executed, default is "[DATETIME]_[COMPUTERNAME].txt"
### Text file on sharepoint online library
## NOTES
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

## RELATED LINKS
