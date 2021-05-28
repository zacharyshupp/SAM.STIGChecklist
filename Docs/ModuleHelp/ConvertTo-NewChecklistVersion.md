---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# ConvertTo-NewChecklistVersion

## SYNOPSIS
Convert Checklist to a new version.

## SYNTAX

```
ConvertTo-NewChecklistVersion [-XCCDF] <String> [-OrginalChecklist] <String> [-Destination] <String>
 [[-ChecklistName] <String>] [-Force] [[-Search] <String>] [[-Classification] <String>] [<CommonParameters>]
```

## DESCRIPTION
Convert Checklist to a new version while keeping the orginal values.
This function handles searching LegacyIDs as well if you are importing a checklist before their IDs were converted.

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-NewChecklistVersion -XCCDF "E:\U_MS_DotNet_Framework_4-0_V2R1_STIG.zip" -OrginalChecklist "E:\U_MS_Dot_Net_Framework_4-0_STIG_V1R9-Convert.ckl" -Destination E:\ConvertTest -Force -Verbose
```

This example demonstrates how to convert a single checklist the new checklist version.

## PARAMETERS

### -ChecklistName
Specifies the custom checklist name to use when creationg the new STIG checklist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Classification
Specifies the Classification for the checklist.
Default value is 'UNCLASSIFIED'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: UNCLASSIFIED
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Destination
Specifies the destination to save new STIG checklits.
If the destination doesent exist the function will create it.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Specifies to overwrite the checklist if there is one of the same name.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OrginalChecklist
Specifies the path to the orginal checklist to convert.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName, PSPath

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Search
Specifies the regex string used to pull the xccdf file from the STIG Archive.
By default it will pull all files that end in '_Manual-xccdf.xml'.
If the zip archive has multiple xccdf files you will want to set the search.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -XCCDF
Specifies the path to the XCCDF benchmark file.
The file must end in '*_Manual-xccdf.xml' or .zip.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### System.Void
## NOTES

## RELATED LINKS
