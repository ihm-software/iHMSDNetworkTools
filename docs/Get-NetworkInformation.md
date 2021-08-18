---
external help file: iHM-SDNetworkTools-help.xml
Module Name: iHM-SDNetworkTools
online version:
schema: 2.0.0
---

# Get-NetworkInformation

## SYNOPSIS
Gathers netwrork interface information

## SYNTAX

```
Get-NetworkInformation [[-InterfaceStatus] <String>] [[-AddressFamily] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function outputs a system object that contains all interface details for the client

## EXAMPLES

### EXAMPLE 1
```
Get-NetworkInformation -Interfacestatus Up
```

## PARAMETERS

### -InterfaceStatus
Check for only up or down

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AddressFamily
TCPIP version 4 or 6, default is both

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Parameters above
## OUTPUTS

### None
## NOTES

## RELATED LINKS
