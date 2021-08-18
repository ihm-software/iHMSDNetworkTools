---
external help file: iHM-SDNetworkTools-help.xml
Module Name: iHM-SDNetworkTools
online version:
schema: 2.0.0
---

# Add-LogMessage

## SYNOPSIS
Allows for writing a log formatted with the date, line number, and message.

## SYNTAX

```
Add-LogMessage [[-LogPath] <Object>] [[-LineNumber] <Int32>] [[-Message] <Object>] [-Exit] [<CommonParameters>]
```

## DESCRIPTION
Allows for writing a log formatted with the date, line number, and message.

## EXAMPLES

### EXAMPLE 1
```
Add-LogMessage -LogPath $LogPath -LineNumber $PSItem.InvocationInfo.ScriptLineNumber -Message $PSItem.Exception.Message
```

## PARAMETERS

### -LogPath
The Folder for starting log

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $LogPath
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
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The description of the error you want to pass (use $_.Exception)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exit
Used to terminate context after logging error

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
