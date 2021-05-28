---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Set-ChecklistItem

## SYNOPSIS
Set Checklist item details

## SYNTAX

### FromImport
```
Set-ChecklistItem -Checklist <Object[]> [-VulnID <String>] [-Details <String>] [-Comments <String>]
 [-Status <String>] [-SeverityOverride <String>] [-SeverityJustification <String>] [<CommonParameters>]
```

### FromFile
```
Set-ChecklistItem -Path <String[]> [-VulnID <String>] [-Details <String>] [-Comments <String>]
 [-Status <String>] [-SeverityOverride <String>] [-SeverityJustification <String>] [<CommonParameters>]
```

## DESCRIPTION
Set Checklist item details for a single or multiple checklists.

## EXAMPLES

### EXAMPLE 1
```
Set-ChecklistItem -Path "E:\_Temp\U_A10_Networks_ADC_ALG_STIG_V2R1.ckl" -VulnID V-237032 -Details "This is not a finding" -Status NotAFinding
```

This example demonstrates how to set a single checklist item.

### EXAMPLE 2
```
Get-ChildItem -Path E:\_Temp\Checklists -Filter "*.ckl" | Set-ChecklistItem -VulnID V-237032 -Details "This is not a finding" -Status NotAFinding
```

This example demonstrates how to set a single checklist item on multiple checklists of the same type.

### EXAMPLE 3
```
$ckl = Import-Checklist -Path "E:\_Temp\U_A10_Networks_ADC_ALG_STIG_V2R1.ckl"
PS C:\> Set-ChecklistItem -Checklist $ckl -VulnID V-237032 -Details "This is not a finding" -Status NotAFinding
PS C:\>	$ckl | Export-Checklist
```

This example demonstrates how to import a checklist, calling Set-ChecklistItem, and then exporting the checklist to save the changes.
This is useful for when your setting multiple items and want to save time on save to the file each time a change is made.

## PARAMETERS

### -Checklist
Specifies the Checklist XML object to be search.

```yaml
Type: Object[]
Parameter Sets: FromImport
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Comments
Specifies the Comments to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Details
Specifies the Details to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Specifies the Checklist Path, When path is provided the function will import the checklist.

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

### -SeverityJustification
Specifies the Severity Override Justification for the checklist item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SeverityOverride
Specifies the Severity Override value for the checklist item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
Specifies the Status of the Checklist Item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VulnID
Specifies the STIG VulnID to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
