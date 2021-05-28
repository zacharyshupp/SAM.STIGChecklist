---
external help file: SAM.STIGChecklist-help.xml
Module Name: SAM.STIGChecklist
online version:
schema: 2.0.0
---

# New-Checklist

## SYNOPSIS
Create a New STIG Checklist

## SYNTAX

```
New-Checklist -Path <String> -Destination <String> [-ChecklistName <String>] [-Classification <String>]
 [-Force] [-PassThru] [-Search <String>] [-HostName <String>] [-HostIP <String>] [-HostMAC <String>]
 [-HostFQDN <String>] [-Comment <String>] [-WebSite <String>] [-DatabaseInstance <String>] [-Database <String>]
 [-AssetType <String>] [-Role <String>] [-TechnologyArea <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new STIG Checklist from the DoD Cyber Exchange.

## EXAMPLES

### EXAMPLE 1
```
$ckl = New-Checklist -Path "E:\_Temp\U_MS_Windows_Server_2016_V2R2_STIG.zip" -Destination E:\_Temp -PassThru
```

This example shows how to create a new checklist from the zip file downloaded from Cyber.mil.
This example also leverages the -PassThru switch that will output the Checklist object to use with other functions.

### EXAMPLE 2
```
Directory: E:\_Temp\Test
```

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           5/12/2021  9:56 AM         535864 U_A10_Networks_ADC_ALG_V2R1_STIG.zip
-a---           5/12/2021  9:56 AM         276032 U_A10_Networks_ADC_NDM_V1R1_STIG.zip
-a---           5/12/2021  9:56 AM         681814 U_AAA_Services_V1R2_SRG.zip
-a---           5/12/2021  9:56 AM         640328 U_Active_Directory_Domain_V2R13_STIG.zip
-a---           5/12/2021  9:56 AM         444331 U_Active_Directory_Forest_V2R8_STIG.zip
-a---           5/12/2021  9:57 AM         680792 U_Adobe_Acrobat_Pro_DC_Classic_V2R1_STIG.zip

PS C:\>Get-ChildItem -Path E:\_Temp\Test -Filter "*.zip" | New-Checklist -Destination E:\_Temp\Checklists

This example shows how to pull a directory full of zip files from Cyber.mil and convert them to Checklists.
This will use the name of the zip file for the Checklist name

Directory: E:\_Temp\Checklists

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           5/19/2021  8:20 AM         186660 U_A10_Networks_ADC_ALG_STIG_V2R1.ckl
-a---           5/19/2021  8:20 AM         214704 U_A10_Networks_ADC_NDM_STIG_V1R1.ckl
-a---           5/19/2021  8:20 AM         371142 U_AAA_Services_SRG_V1R2.ckl
-a---           5/19/2021  8:20 AM         207120 U_Active_Directory_Domain_STIG_V2R13.ckl
-a---           5/19/2021  8:20 AM          33416 U_Active_Directory_Forest_STIG_V2R8.ckl
-a---           5/19/2021  8:20 AM         141849 U_Adobe_Acrobat_Pro_DC_Classic_V2R1.ckl

## PARAMETERS

### -AssetType
Specifies the Asset Type for the checklist.
Default value is Computing.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Computing
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ChecklistName
Specifies the custom Checklist name to use when creationg the Stig Checklist.

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

### -Classification
Specifies the Classification for the checklist.
Default value is 'UNCLASSIFIED'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: UNCLASSIFIED
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

### -Destination
Specifies the destination to save new STIG Checklits.
If the Destination doesent exist the function will create it.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Specifies to overwrite the Checklist if there is one of the same name.

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
Specifies the host name for the checklist for either computer or non-computer checklists.

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

### -PassThru
Specifies if the function should return the checklist information

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

### -Path
Specifies the path to the XCCDF Benchmark file.
The file must end in '*_Manual-xccdf.xml' or .zip.

```yaml
Type: String
Parameter Sets: (All)
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

### -Search
Specifies the regex string used to pull the xccdf file from the STIG Archive.
By default it will pull all files that end in '_Manual-xccdf.xml'.
If the zip archive has multiple xccdf files you will want to set the search.

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
