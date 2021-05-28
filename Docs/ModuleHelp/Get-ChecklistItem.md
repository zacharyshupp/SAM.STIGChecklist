---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Get-ChecklistItem

## SYNOPSIS
Get Checklist item details

## SYNTAX

### FromFile (Default)
```
Get-ChecklistItem [-Path <String[]>] [-VulnID <String[]>] [<CommonParameters>]
```

### FromObject
```
Get-ChecklistItem [-Checklist <Object[]>] [-VulnID <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get all Checklist Vulns or search for specific ones across a single checklist or multiple checklists,

## EXAMPLES

### EXAMPLE 1
```
$CKL Object
	Name      : Windows_Server-2016
	STIGID    : Windows_Server_2016_STIG
	Checklist : #document
	Path      : E:\_Temp\Windows_Server-2016.ckl
```

PS C:\\\> Get-ChecklistItem -Checklist $ckl

This example shows how get all vuln items from a single checklist.

### EXAMPLE 2
```
Get-ChildItem -Path E:\_Temp\Test -Filter "*.ckl" | Get-ChecklistItem -VulnID "V-224820"
```

This example shows how to use Get-ChildItem to pull .ckl files from a directory and get a specific VulnID from each checklist.

### EXAMPLE 3
```
$CKL Object
	Name      : Windows_Server-2016
	STIGID    : Windows_Server_2016_STIG
	Checklist : #document
	Path      : E:\_Temp\Windows_Server-2016.ckl
```

PS C:\\\> Get-ChecklistItem -Checklist $ckl -VulnID 'V-224820'

	HostName               : COMPUTER123
	Vuln_Num               : V-224820
	Status                 : NotAFinding
	Severity               : medium
	Finding_Details        : This is a detail
	Comments               : This is a Comment
	Severity_Overide       :
	Severity_Justification :

This example shows how get a single vuln item from a STIG Checklist.

### EXAMPLE 4
```
$CKL Object
	Name      : Windows_Server-2016
	STIGID    : Windows_Server_2016_STIG
	Checklist : #document
	Path      : E:\_Temp\Windows_Server-2016.ckl
```

PS C:\\\> Get-ChecklistItem -Checklist $ckl -VulnID "V-224820", "V-224825"

	HostName               : COMPUTER123
	Vuln_Num               : V-224820
	Status                 : NotAFinding
	Severity               : medium
	Finding_Details        : This is a detail
	Comments               : This is a Comment
	Severity_Overide       :
	Severity_Justification :

	HostName               : COMPUTER123
	Vuln_Num               : V-224825
	Status                 : Not_Reviewed
	Severity               : medium
	Finding_Details        :
	Comments               :
	Severity_Overide       :
	Severity_Justification :

This example shows how get a multiple vuln items from a STIG Checklist.

## PARAMETERS

### -Checklist
Specify the Checklist XML object to be search.

```yaml
Type: Object[]
Parameter Sets: FromObject
Aliases:

Required: False
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

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VulnID
Specify the STIG VulnID to search for.

```yaml
Type: String[]
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
