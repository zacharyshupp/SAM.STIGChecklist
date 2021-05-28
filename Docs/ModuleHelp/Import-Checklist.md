---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Import-Checklist

## SYNOPSIS
Import STIG Checklist (CKL)

## SYNTAX

```
Import-Checklist [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Load a CKL file as an \[XML\] element.
This can then be passed to other functions in this module.

## EXAMPLES

### EXAMPLE 1
```
$ckl = Import-Checklist -Checklist C:\Temp\U_Windows10.ckl
```

This example shows how to import a checklist.

OUTPUT
------
Name      : Path
STIGID    : IIS_10-0_Site_STIG
Checklist : #document
Path      : E:\_Temp\Checklists\U_MS_IIS_10-0_Site_STIG_V2R2.ckl

## PARAMETERS

### -Path
Specify the path to the STIG Checklist.
When function is ran, it will validate the file passed exists and is a .ckl file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName, PSPath

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
