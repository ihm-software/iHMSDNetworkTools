---
external help file: iHM-SDNetworkTools-help.xml
Module Name: iHM-SDNetworkTools
online version:
schema: 2.0.0
---

# Invoke-Speedtest

## SYNOPSIS
measures download from speedtest.net

## SYNTAX

```
Invoke-Speedtest [-Worldwide] [[-TestCount] <Int32>] [[-Size] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
connects and downloads image files from servers to measure download speed

## EXAMPLES

### EXAMPLE 1
```
Invoke-Speedtest -Testcount 1 -Size 500
```

## PARAMETERS

### -Worldwide
Searchs all servers for closest locations.
Default is USA only.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestCount
The number of servers to connect to and repeat the test

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
The pixel size^2 of the download image.
Bigger = larger download.
Default is 1000x1000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1000
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
