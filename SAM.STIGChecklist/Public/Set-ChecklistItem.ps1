function Set-ChecklistItem {

	<#
		.SYNOPSIS
			Set Checklist item details

		.DESCRIPTION
			Set Checklist item details for a single or multiple checklists.

		.EXAMPLE
			PS C:\> Set-ChecklistItem -Path "E:\_Temp\U_A10_Networks_ADC_ALG_STIG_V2R1.ckl" -VulnID V-237032 -Details "This is not a finding" -Status NotAFinding

			This example demonstrates how to set a single checklist item.

		.EXAMPLE
			PS C:\> Get-ChildItem -Path E:\_Temp\Checklists -Filter "*.ckl" | Set-ChecklistItem -VulnID V-237032 -Details "This is not a finding" -Status NotAFinding

			This example demonstrates how to set a single checklist item on multiple checklists of the same type.

		.EXAMPLE
			PS C:\> $ckl = Import-Checklist -Path "E:\_Temp\U_A10_Networks_ADC_ALG_STIG_V2R1.ckl"
			PS C:\> Set-ChecklistItem -Checklist $ckl -VulnID V-237032 -Details "This is not a finding" -Status NotAFinding
			PS C:\>	$ckl | Export-Checklist

			This example demonstrates how to import a checklist, calling Set-ChecklistItem, and then exporting the checklist to save the changes. This is useful for when your setting multiple items and want to save time on save to the file each time a change is made.
	#>

	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param (

		# Specifies the Checklist XML object to be search.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName="FromImport")]
		[System.Object[]]
		$Checklist,

		# Specifies the Checklist Path, When path is provided the function will import the checklist.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName="FromFile")]
		[Alias('FullName', 'PSPath')]
		[String[]]
		$Path,

		# Specifies the STIG VulnID to update.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$VulnID,

		# Specifies the Details to update.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$Details,

		# Specifies the Comments to update.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$Comments,

		# Specifies the Status of the Checklist Item.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet("Open", "NotAFinding", "Not_Reviewed", "Not_Applicable")]
		[String]
		$Status,

		# Specifies the Severity Override value for the checklist item.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet("High", "Medium", "Low")]
		[String]
		$SeverityOverride,

		# Specifies the Severity Override Justification for the checklist item.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$SeverityJustification

	)

	process {

		$modified = $false

		if ($Path) { $Checklist = Import-Checklist -Path "$Path" }

		$xPath = "//STIG_DATA[VULN_ATTRIBUTE='Vuln_Num' and ATTRIBUTE_DATA='$VulnID']"

		Select-Xml -Xml $Checklist.XML -XPath $xPath | ForEach-Object {

			$item = $_.Node.ParentNode

			if ($PSBoundParameters.Details) {

				$escaped = $(ConvertTo-SafeXML -String $Details)

				if ( $item.FINDING_DETAILS -ne $escaped ) {
					$item.FINDING_DETAILS = "$escaped"
					$modified = $true
				}
				else {
					Write-Verbose "$vulnId - FINDING_DETAILS '$($item.FINDING_DETAILS)' already matches '$escaped', no change."
				}

			}

			if ($PSBoundParameters.Comments) {

				$escaped = $(ConvertTo-SafeXML -String $Comments)

				if ( $item.COMMENTS -ne $escaped ) {
					$item.COMMENTS = "$escaped"
					$modified = $true
				}
				else {
					Write-Verbose "$vulnId - COMMENTS '$($item.COMMENTS)' already matches '$escaped', no change."
				}

			}

			if ($PSBoundParameters.Status) {

				if ( $item.STATUS -ne $STATUS ) {
					$item.STATUS = "$STATUS"
					$modified = $true
				}
				else {
					Write-Verbose "$vulnId - STATUS '$($item.STATUS)' already matches '$Status', no change."
				}

			}

			if ($PSBoundParameters.SeverityOverride) {

				$escaped = $(ConvertTo-SafeXML -String $SeverityOverride)

				if ( $item.SeverityOverride -ne $escaped ) {
					$item.SeverityOverride = "$escaped"
					$modified = $true
				}
				else {
					Write-Verbose "$vulnId - SeverityOverride '$($item.SeverityOverride)' already matches '$escaped', no change."
				}

			}

			if ($PSBoundParameters.SeverityJustification) {

				$escaped = $(ConvertTo-SafeXML -String $SeverityJustification)

				if ( $item.SeverityJustification -ne $escaped ) {
					$item.SeverityJustification = "$escaped"
					$modified = $true
				}
				else {
					Write-Verbose "$vulnId - SeverityOverride '$($item.SeverityJustification)' already matches '$escaped', no change."
				}

			}

		}

		If ($modified -eq $true -and $Path) {

			Write-Verbose "$($Checklist.Name) was modified, saving file changes"
			Export-Checklist -Checklist $Checklist
			Write-Verbose "Saved Changes to '$($Checklist.Path)'"

		}

	}

}
