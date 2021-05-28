---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Get-ChecklistAsset

## SYNOPSIS
Get Checklist Asset Information

## SYNTAX

### FromFile (Default)
```
Get-ChecklistAsset -Path <String[]> [<CommonParameters>]
```

### FromObject
```
Get-ChecklistAsset -Checklist <Object[]> [<CommonParameters>]
```

## DESCRIPTION
Get Checklist Asset Information across a single checklist or multiple checklists.

## EXAMPLES

### EXAMPLE 1
```
Get-ChildItem -Path E:\_Temp\Test -Filter "*.ckl" | Get-ChecklistAsset
```

This example demonstrates how to pull Asset Data from multiple checklists in a directory.

### EXAMPLE 2
```
Get-ChecklistAsset -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl"
```

	ROLE            : Member Server
	ASSET_TYPE      : Computing
	HOST_NAME       : COMPUTER123
	HOST_IP         : 10.0.0.4
	HOST_MAC        : 00-15-5D-E8-33-9D
	HOST_FQDN       : COMPUTER123.FQDN.COM
	TARGET_COMMENT  : This is a test
	WEB_OR_DATABASE : false
	WEB_DB_SITE     :
	WEB_DB_INSTANCE :

This example demonstrates how to pull Asset Data from a single checklist.

### EXAMPLE 3
```
Import-Checklist -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl" | Get-ChecklistAsset
```

	ROLE            : Member Server
	ASSET_TYPE      : Computing
	HOST_NAME       : COMPUTER123
	HOST_IP         : 10.0.0.4
	HOST_MAC        : 00-15-5D-E8-33-9D
	HOST_FQDN       : COMPUTER123.FQDN.COM
	TARGET_COMMENT  : This is a test
	WEB_OR_DATABASE : false
	WEB_DB_SITE     :
	WEB_DB_INSTANCE :

This example demonstrates how to pull Asset Data from a single checklist that was imported using Import-Checklist and piped to Get-ChecklistAsset.

## PARAMETERS

### -Checklist
Specify the Checklist XML object to be search.

```yaml
Type: Object[]
Parameter Sets: FromObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Specify the Checklist Path, When path is provided the function will import the checklist.

```yaml
Type: String[]
Parameter Sets: FromFile
Aliases: FullName, PSPath

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
