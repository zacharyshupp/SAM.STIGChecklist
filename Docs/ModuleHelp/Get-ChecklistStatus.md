---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Get-ChecklistStatus

## SYNOPSIS

Get Metrics from a STIG Checklist

## SYNTAX

### FromFile (Default)

``` PowerShell
Get-ChecklistStatus -Path <String[]> [<CommonParameters>]
```

### FromObject

``` PowerShell
Get-ChecklistStatus -Checklist <Object[]> [<CommonParameters>]
```

## DESCRIPTION

Get Metrics on Total Items, Item Status, and Open CAT Findings from a STIG Checklist.
CATI, CATII, and CATIII are pulled from items that are in an Open status, this wont include items that are still not reviewd.

## EXAMPLES

### EXAMPLE 1

``` PowerShell
Get-ChecklistStatus -Path "E:\_Temp\U_MS_Windows_Server_2016_STIG_V2R2.ckl"
```

This example demonstrates how to get metrics from a single

Output
HostName : Computer1
STIGID : Windows_Server_2016_STIG
FileName : U_MS_Windows_Server_2016_STIG_V2R2.ckl
VulnCount : 273
Open : 13
NotAFinding : 197
NotReviewed : 52
NotApplicable : 11
CATI : 2
CATII : 11
CATIII : 0
VulnDetails : {NotReviewed, Open, NotAFinding, NotApplicable}
FileInfo : {CreationTime, LastAccessTime, LastWriteTime, FileHash…}

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
