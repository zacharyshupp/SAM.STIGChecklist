---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# Set-ChecklistAsset

## SYNOPSIS
Sets Checklist Asset Information

## SYNTAX

### FromFile (Default)
```
Set-ChecklistAsset -Path <String> [-HostName <String>] [-HostIP <String>] [-HostMAC <String>]
 [-HostFQDN <String>] [-Comment <String>] [-WebSite <String>] [-DatabaseInstance <String>] [-Database <String>]
 [-AssetType <String>] [-Role <String>] [-TechnologyArea <String>] [<CommonParameters>]
```

### FromObject
```
Set-ChecklistAsset -Checklist <PSObject> [-HostName <String>] [-HostIP <String>] [-HostMAC <String>]
 [-HostFQDN <String>] [-Comment <String>] [-WebSite <String>] [-DatabaseInstance <String>] [-Database <String>]
 [-AssetType <String>] [-Role <String>] [-TechnologyArea <String>] [<CommonParameters>]
```

## DESCRIPTION
Sets Checklist Asset Information across a single checklist or multiple checklists.

## EXAMPLES

### EXAMPLE 1
```
Set-ChecklistAsset -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl" -HostName Computer123 -HostIP 10.0.0.32
```

This example demonstrates how to set the Hostname and Host IP for a given checklist.

### EXAMPLE 2
```
Set-ChecklistAsset -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl" -HostName Computer123 -HostIP 10.0.0.32 -PassThru
```

This example demonstrates how to set the Hostname and Host IP for a set of checklists in a directory.

## PARAMETERS

### -AssetType
Specifies the Asset Type for the checklist..

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

### -Checklist
Specifies the Checklist XML object to be updated.

```yaml
Type: PSObject
Parameter Sets: FromObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Comment
Specifies the Target Comment for the given host.

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

### -Database
Specifies the Host Database for Checklist.

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

### -DatabaseInstance
Specifies the Host Database Instance for the checklist.

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

### -HostFQDN
Specifies the Host FQDN for the checklist.

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

### -HostIP
Specifies the Host IP Address for the checklist.

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

### -HostMAC
Specifies the Host MAC Address for the checklist.

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

### -HostName
Specifies the host name for the checklist.

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
Type: String
Parameter Sets: FromFile
Aliases: FullName, PSPath

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Role
Specifies the Asset Role for the checklist.
Default value is 'None'.

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

### -TechnologyArea
Specifies the Technology Area the STIG Applies to.

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

### -WebSite
Specifies the Host WebSite for the checklist.

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

### System.Void
## NOTES

## RELATED LINKS
