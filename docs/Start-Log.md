---
external help file: iHMSDNetworkTools-help.xml
Module Name: iHMSDNetworkTools
online version:
schema: 2.0.0
---

# Start-Log

## SYNOPSIS
Creates log file with path and name that is passed.
Checks if log file exists, and if it does deletes it and creates a new one.
Once created, writes initial logging data

## SYNTAX

```
Start-Log [-LogPath] <Object> [-LogName] <Object> [-ScriptVersion] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Cross-platform error logging module

## EXAMPLES

### EXAMPLE 1
```
Start-Log -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"
```

## PARAMETERS

### -LogPath
Mandatory.
Path of where log is to be created.
Example: C:\Windows\Temp

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

### -LogName
Mandatory.
Name of log file to be created.
Example: Test_Script.log

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

### -ScriptVersion
Mandatory.
Version of the running script which will be written in the log.
Example: 1.5

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

## OUTPUTS

## NOTES

## RELATED LINKS
