---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Export-Checklist

## SYNOPSIS
Export STIG Checklist to File

## SYNTAX

```
Export-Checklist [-Checklist] <PSObject> [-Destination <String>] [<CommonParameters>]
```

## DESCRIPTION
Export STIG Checklist to File

## EXAMPLES

### EXAMPLE 1
```
$CKL Object
	Name   : Windows_Server-2016
	STIGID : Windows_Server_2016_STIG
	XML    : #document
	Path   : E:\_Temp\Windows_Server-2016.ckl
```

PS C:\\\> Export-Checklist -Checklist $CKL

         This example shows how to Export a checklist.
$CKL is passed with the xml data and then it is saved to the location listed in $CKL.Path.

### EXAMPLE 2
```
$CKL Object
	Name   : Windows_Server-2016
	STIGID : Windows_Server_2016_STIG
	XML    : #document
	Path   : E:\_Temp\Windows_Server-2016.ckl
```

PS C:\\\> $ckl | Export-Checklist -Destination "E:\$($ckl.Name)\`-v1.ckl"

This example shows how you can use an imported checklist to export it to another file to create a copy.

### EXAMPLE 3
```
$CKL Object
	Name   : Windows_Server-2016
	STIGID : Windows_Server_2016_STIG
	XML    : #document
	Path   : E:\_Temp\Windows_Server-2016.ckl
```

PS C:\\\> $ckl | Export-Checklist

This example shows how you can use an imported checklist and pipe it to Export-Checklist.
In this example, Export-Checklist will export the Checklist to whats listed in $CKL.Path

## PARAMETERS

### -Checklist
Specifies the XML Object created from Import-Checklist.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Destination
Specifies the path to the STIG Checklist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
