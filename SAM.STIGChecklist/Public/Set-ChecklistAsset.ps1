function Set-ChecklistAsset {

	<#
		.SYNOPSIS
			Sets Checklist Asset Information

		.DESCRIPTION
			Sets Checklist Asset Information across a single checklist or multiple checklists.

		.EXAMPLE
			PS E:> Set-ChecklistAsset -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl" -HostName Computer123 -HostIP 10.0.0.32

			This example demonstrates how to set the Hostname and Host IP for a given checklist.

		.EXAMPLE

			PS E:> Set-ChecklistAsset -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl" -HostName Computer123 -HostIP 10.0.0.32 -PassThru

			This example demonstrates how to set the Hostname and Host IP for a set of checklists in a directory.

	#>

	[CmdletBinding(DefaultParameterSetName = 'FromFile')]
	[OutputType([System.Void])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
		'PSUseDeclaredVarsMoreThanAssignments', '',
		Justification = 'Several Parameters are used just to trigger an error'
	)]
	param (

		# Specifies the Checklist XML object to be updated.
		[Parameter(Mandatory, ParameterSetName = 'FromObject', ValueFromPipelineByPropertyName)]
		[PSObject]
		$Checklist,

		# Specifies the Checklist Path, When path is provided the function will import the checklist.
		[Parameter(Mandatory, ParameterSetName = 'FromFile', ValueFromPipelineByPropertyName)]
		[Alias('FullName', 'PSPath')]
		[String]
		$Path,

		# Specifies the host name for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$HostName,

		# Specifies the Host IP Address for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$HostIP,

		# Specifies the Host MAC Address for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$HostMAC,

		# Specifies the Host FQDN for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$HostFQDN,

		# Specifies the Target Comment for the given host.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$Comment,

		# Specifies the Host WebSite for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$WebSite,

		# Specifies the Host Database Instance for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$DatabaseInstance,

		# Specifies the Host Database for Checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$Database,

		# Specifies the Asset Type for the checklist..
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet('Non-Computing', 'Computing')]
		[string]
		$AssetType,

		# Specifies the Asset Role for the checklist. Default value is 'None'.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet('None', 'Workstation', 'Member Server', 'Domain Controller')]
		[string]
		$Role,

		# Specifies the Technology Area the STIG Applies to.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet(
			"Application Review",
			"Boundary Security",
			"CDS Admin Review",
			"CDS Technical Review",
			"Database Review",
			"Domain Name System (DNS)",
			"Exchange Server",
			"Host Based System Security (HBSS)",
			"Internal Network",
			"Mobility",
			"Releasable Networks (REL)",
			"Traditional Security",
			"UNIX OS",
			"VVOIP Review",
			"Web Review",
			"Windows OS",
			"Other Review"
		)]
		[string]
		$TechnologyArea

	)

	process {

		if ($Path) { $Checklist = Import-Checklist -Path "$Path" }

		$modified = $false
		$asset = $Checklist.XML.CHECKLIST.ASSET

		If ($HostName) {

			$escaped = $(ConvertTo-SafeXML -String $HostName)

			if ( $asset.HOST_NAME -ne $escaped ) {
				$asset.HOST_NAME = "$($escaped.ToUpper())"
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - HostName '$($asset.HOST_NAME)' already matches '$escaped', no change."
			}

		}

		If ($HostIP) {

			# Test if valid IP Address
			try {

				# This will throw an error if its in the wrong format.
				[System.Net.IPAddress]$IP = $HostIP

				if ( $asset.HOST_IP -ne $HostIP ) {
					$asset.HOST_IP = "$HostIP"
					$modified = $true
				}
				else {
					Write-Verbose "$($Checklist.Name) - HostIP '$($asset.HOST_IP)' already matches '$HostIP', no change."
				}

			}
			catch {
				Write-Verbose "$($Checklist.Name) - HostIP - $_"
			}

		}

		if ($HostMAC) {

			if ($HostMAC -match $regexMAC) {

				$escaped = $(ConvertTo-SafeXML -String $HostMAC)

				if ( $asset.HOST_MAC -ne $escaped ) {
					$asset.HOST_MAC = "$escaped"
					$modified = $true
				}
				else {
					Write-Verbose "$($Checklist.Name) - MAC '$($asset.HOST_MAC)' already matches '$escaped', no change."
				}

			}
			else {
				Write-Verbose "$($Checklist.Name) - MAC '$HostMAC' is not a valid format, no change."
			}

		}

		if ($HostFQDN) {

			if ($HostFQDN -match $regexFQDN) {

				$escaped = $(ConvertTo-SafeXML -String $HostFQDN)

				if ( $asset.HOST_FQDN -ne $escaped ) {
					$asset.HOST_FQDN = "$($escaped.ToUpper())"
					$modified = $true
				}
				else {
					Write-Verbose "$($Checklist.Name) - FQDN '$($asset.HOST_FQDN)' already matches '$escaped', no change."
				}

			}
			else {
				Write-Verbose "$($Checklist.Name) - FQDN '$HostFQDN' is not a valid format, no change."
			}

		}

		if ($Comment) {

			$escaped = $(ConvertTo-SafeXML -String $Comment)

			if ( $asset.TARGET_COMMENT -ne $escaped ) {
				$asset.TARGET_COMMENT = "$escaped"
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - Comment '$($asset.TARGET_COMMENT)' already matches '$escaped', no change."
			}

		}

		if ($Role) {

			$escaped = $(ConvertTo-SafeXML -String $Role)

			if ( $asset.ROLE -ne $escaped) {
				$asset.ROLE = "$escaped"
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - Role '$($asset.ROLE)' already matches '$escaped', no change."
			}

		}

		if ($Website) {

			$escaped = $(ConvertTo-SafeXML -String $WebSite)

			if ( $asset.WEB_DB_SITE -ne $escaped -or $asset.WEB_OR_DATABASE -eq 'false') {
				$asset.WEB_DB_SITE = "$($escaped.ToUpper())"
				$asset.WEB_OR_DATABASE = 'true'
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - Website '$($asset.WEB_DB_SITE)' already matches '$escaped', no change."
			}

		}

		If ($Database) {

			$escaped = $(ConvertTo-SafeXML -String $Database)

			if ( $asset.WEB_DB_SITE -ne $escaped -or $asset.WEB_OR_DATABASE -eq 'false') {
				$asset.WEB_DB_SITE = "$escaped"
				$asset.WEB_OR_DATABASE = 'true'
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - Database '$($asset.WEB_DB_SITE)' already matches '$escaped', no change."
			}

		}

		If ($DatabaseInstance) {

			$escaped = $(ConvertTo-SafeXML -String $DatabaseInstance)

			if ( $asset.WEB_DB_INSTANCE -ne $escaped -or $asset.WEB_OR_DATABASE -eq 'false') {
				$asset.WEB_DB_INSTANCE = "$escaped"
				$asset.WEB_OR_DATABASE = 'true'
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - Database Instance '$($asset.WEB_DB_INSTANCE)' already matches '$escaped', no change."
			}

		}

		if ($AssetType) {

			$escaped = $(ConvertTo-SafeXML -String $AssetType)

			if ( $asset.ASSET_TYPE -ne $escaped ) {

				if ($AssetType -eq "Non-Computing") {
					$asset.HOST_IP = ""
					$asset.HOST_MAC = ""
					$asset.HOST_FQDN = ""
					$asset.TARGET_COMMENT = ""
					$asset.ROLE = 'None'
					$asset.WEB_OR_DATABASE = 'false'
					$asset.WEB_DB_SITE = ""
					$asset.WEB_DB_INSTANCE = ""
				}

				$asset.ASSET_TYPE = "$escaped"
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - ASSET_TYPE '$($asset.ASSET_TYPE)' already matches '$escaped', no change."
			}

		}

		if ($TechnologyArea) {

			$escaped = $(ConvertTo-SafeXML -String $TechnologyArea)

			if ( $asset.TECH_AREA -ne $escaped) {
				$asset.TECH_AREA = "$escaped"
				$modified = $true
			}
			else {
				Write-Verbose "$($Checklist.Name) - Technology Area '$($asset.TECH_AREA)' already matches '$escaped', no change."
			}

		}

		If ($modified -eq $true -and $Path) {

			Write-Verbose "$($Checklist.Name) was modified, saving file changes"
			Export-Checklist -Checklist $Checklist
			Write-Verbose "Saved Changes to '$($Checklist.Path)'"

		}

	}

}
