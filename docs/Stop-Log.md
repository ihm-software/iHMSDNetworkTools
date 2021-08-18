---
external help file: iHM-SDNetworkTools-help.xml
Module Name: iHM-SDNetworkTools
online version:
schema: 2.0.0
---

# Stop-Log

## SYNOPSIS
Write closing logging data & exit

## SYNTAX

```
Stop-Log [-LogPath] <Object> [[-NoExit] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Writes finishing logging data to specified log and then exits the calling script

## EXAMPLES

### EXAMPLE 1
```
Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log"
```

### EXAMPLE 2
```
Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log" -NoExit $True
```

## PARAMETERS

### -LogPath
Mandatory.
Full path of the log file you want to write finishing data to.
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

### -NoExit
Optional.
If this is set to True, then the function will not exit the calling script, so that further execution can occur

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
