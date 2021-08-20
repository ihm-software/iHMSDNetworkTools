---
external help file: iHMSDNetworkTools-help.xml
Module Name: iHMSDNetworkTools
online version:
schema: 2.0.0
---

# Add-LogError

## SYNOPSIS
Add-LogError Writes a pipelined error to a new line at the end of the specified log file.
Used in conjunction with Start-Log and Stop-Log

## SYNTAX

```
Add-LogError [-LogPath] <Object> [-ErrorDesc] <Object> [-ExitGracefully] <Boolean> [[-LineNumber] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Cross-Platform error log to file

## EXAMPLES

### EXAMPLE 1
```
Add-LogError -LogPath "C:\Windows\Temp\Test_Script.log" -ErrorDesc $_.Exception -ExitGracefully $True
```

## PARAMETERS

### -LogPath
Mandatory.
Full path of the log file you want to write to.
Example: C:\Windows\Temp\Test_Script.log

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorDesc
Mandatory.
The description of the error you want to pass (use $_.Exception)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExitGracefully
Mandatory.
Boolean.
If set to True, runs Stop-Log and then exits script

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LineNumber
The breakpoint line carried from error

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
