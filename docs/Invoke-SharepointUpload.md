---
external help file: iHMSDNetworkTools-help.xml
Module Name: iHMSDNetworkTools
online version:
schema: 2.0.0
---

# Invoke-SharepointUpload

## SYNOPSIS
Connects and uploads a specified file to an anonymous sharepoint online shared document library.
Script supports bit.ly shortened links

## SYNTAX

```
Invoke-SharepointUpload [-AnonURL] <Uri> [-Filepath] <String> [<CommonParameters>]
```

## DESCRIPTION
Cross-Platform Sharepoint API File Upload

## EXAMPLES

### EXAMPLE 1
```
Invoke-SharepointUpload -AnonUrl 'htttps://bit.ly/ihmnetwizupload' -Filepath d:\test\testfile.txt
```

## PARAMETERS

### -AnonURL
The anonymous share link from sharepoint.
Script supports bit.ly shortened links

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filepath
The file to upload

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
