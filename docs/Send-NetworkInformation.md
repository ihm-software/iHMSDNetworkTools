---
external help file: iHMSDNetworkTools-help.xml
Module Name: iHMSDNetworkTools
online version:
schema: 2.0.0
---

# Send-NetworkInformation

## SYNOPSIS
This script combines functions to check network information and speedtest results.
Local file is named "\[DATETIME\]_\[COMPUTERNAME\].txt" and locationed in script root
Then uploads text file to an anonymous sharepoint online document library.

## SYNTAX

```
Send-NetworkInformation [[-Filename] <String>] [[-AnonUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
Cross Platform Network troubleshooting tool

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

## RELATED LINKS
