function ConvertTo-NewChecklistVersion {

	<#
		.SYNOPSIS
			Convert Checklist to a new version.

		.DESCRIPTION
			Convert Checklist to a new version while keeping the orginal values. This function handles searching LegacyIDs as well if you are importing a checklist before their IDs were converted.

		.EXAMPLE
			PS C:\> ConvertTo-NewChecklistVersion -XCCDF "E:\U_MS_DotNet_Framework_4-0_V2R1_STIG.zip" -OrginalChecklist "E:\U_MS_Dot_Net_Framework_4-0_STIG_V1R9-Convert.ckl" -Destination E:\ConvertTest -Force -Verbose

			This example demonstrates how to convert a single checklist the new checklist version.
	#>

	[CmdletBinding()]
	[OutputType([System.Void])]
	param (

		# Specifies the path to the XCCDF benchmark file. The file must end in '*_Manual-xccdf.xml' or .zip.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateScript( {
				if (-Not ($_ | Test-Path) ) { throw "XCCDF does not exist" }
				if ($_ -notmatch "\-xccdf.xml|\.zip") {
					throw "The file specified in the Path argument must be '*-xccdf.xml' or '.zip'"
				}
				return $true
			})]
		[String]
		$XCCDF,

		# Specifies the path to the orginal checklist to convert.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateScript( {
				if (-Not ($_ | Test-Path) ) { throw "Checklist does not exist" }
				if ($_ -notmatch "\.ckl") {
					throw "The file specified in the Path argument must be '.ckl'"
				}
				return $true
			})]
		[Alias('FullName', 'PSPath')]
		[String]
		$OrginalChecklist,

		# Specifies the destination to save new STIG checklits. If the destination doesent exist the function will create it.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[String]
		$Destination,

		# Specifies the custom checklist name to use when creationg the new STIG checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$ChecklistName,

		# Specifies to overwrite the checklist if there is one of the same name.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Switch]
		$Force,

		# Specifies the regex string used to pull the xccdf file from the STIG Archive. By default it will pull all files that end in '_Manual-xccdf.xml'. If the zip archive has multiple xccdf files you will want to set the search.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$Search,

		# Specifies the Classification for the checklist. Default value is 'UNCLASSIFIED'.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet('UNCLASSIFIED', 'CLASSIFIED')]
		[string]
		$Classification = "UNCLASSIFIED"
	)

	process {

		# Import Orginal Checklist
		$orginalCKL = Import-Checklist -Path $OrginalChecklist
		$oAsset = $orginalCKL.XML.CHECKLIST.ASSET
		# Create New Checklist and Import
		$newParams = [ordered]@{
			Path           = $XCCDF
			Destination    = $Destination
			Classification = $Classification
			PassThru       = $true
		}

		if ($ChecklistName) { $newParams.Add('ChecklistName', $ChecklistName) }
		if ($force) { $newParams.Add('Force', $true) }
		if ($Search) { $newParams.Add('Search', $Search) }

		if ($oAsset.ROLE ) { $newParams.Add('Role', $oAsset.ROLE) }
		if ($oAsset.ASSET_TYPE) { $newParams.Add('AssetType', $oAsset.ASSET_TYPE) }
		if ($oAsset.HOST_NAME) { $newParams.Add('HostName', $oAsset.HOST_NAME) }
		if ($oAsset.HOST_IP) { $newParams.Add('HostIP', $oAsset.HOST_IP) }
		if ($oAsset.HOST_MAC) { $newParams.Add('HostMAC', $oAsset.HOST_MAC) }
		if ($oAsset.HOST_FQDN) { $newParams.Add('HostFQDN', $oAsset.HOST_FQDN) }
		if ($oAsset.TARGET_COMMENT) { $newParams.Add('Comment', $oAsset.TARGET_COMMENT) }
		if ($oAsset.TECH_AREA) { $newParams.Add('TechArea', $oAsset.TECH_AREA) }

		#TODO: Look into a method to determine if the CKL is for a website or database
		if ($oAsset.WEB_DB_SITE) { $newParams.Add('Website', $oAsset.WEB_DB_SITE) }
		if ($oAsset.WEB_DB_INSTANCE) { $newParams.Add('DatabaseInstance', $oAsset.WEB_DB_INSTANCE) }

		$newCKL = New-Checklist @newParams

		# Get new Checklist Vulns
		$nVulns = Get-ChecklistItem -Checklist $newCKL

		# Loop through old checklists and update new checklist
		$orginalCKL.XML.CHECKLIST.STIGS.iSTIG.VULN | ForEach-Object {

			$vuln = $_

			$id = ($vuln.STIG_DATA | Where-Object { $_.VULN_ATTRIBUTE -eq 'Vuln_Num' }).ATTRIBUTE_DATA

			# Search the new checklist for the Vuln and Legacy IDs
			$nVuln = $nVulns | Where-Object { $_.Vuln_Num -eq $id -or $_.LEGACY_ID -contains $id }

			if ($nVuln) {

				if ($nVuln.Count -eq 1) {

					$params = @{
						Checklist = $newCKL
						VulnID    = $nVuln.Vuln_Num
						Status    = $vuln.STATUS
						Details   = $vuln.FINDING_DETAILS
						Comments  = $vuln.COMMENTS
					}

					if ($vuln.Severity_Overide) {
						$params.add('SeverityOverride', $vuln.Severity_Overide)
						$params.add('SeverityJustification', $vuln.Severity_Justification)
					}

					Set-ChecklistItem @params

				}
				else {

					Write-Verbose "Found multiple entries for VULN_ID '$id'"

				}

			}
			else {

				Write-Verbose "No VULN_ID Found for '$id'"

			}

		}

		Export-Checklist -Checklist $newCKL

	}

}
