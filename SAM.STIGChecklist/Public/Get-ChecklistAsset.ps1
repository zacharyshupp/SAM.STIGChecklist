function Get-ChecklistAsset {

	<#
		.SYNOPSIS
			Get Checklist Asset Information

		.DESCRIPTION
			Get Checklist Asset Information across a single checklist or multiple checklists.

		.EXAMPLE
			PS C:> Get-ChildItem -Path E:\_Temp\Test -Filter "*.ckl" | Get-ChecklistAsset

			This example demonstrates how to pull Asset Data from multiple checklists in a directory.

		.EXAMPLE
			PS C:> Get-ChecklistAsset -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl"

			ROLE            : Member Server
			ASSET_TYPE      : Computing
			HOST_NAME       : COMPUTER123
			HOST_IP         : 10.0.0.4
			HOST_MAC        : 00-15-5D-E8-33-9D
			HOST_FQDN       : COMPUTER123.FQDN.COM
			TARGET_COMMENT  : This is a test
			WEB_OR_DATABASE : false
			WEB_DB_SITE     :
			WEB_DB_INSTANCE :

			This example demonstrates how to pull Asset Data from a single checklist.

		.EXAMPLE
			PS C:> Import-Checklist -Path "E:\U_MS_Windows_10_V2R2_STIG.ckl" | Get-ChecklistAsset

			ROLE            : Member Server
			ASSET_TYPE      : Computing
			HOST_NAME       : COMPUTER123
			HOST_IP         : 10.0.0.4
			HOST_MAC        : 00-15-5D-E8-33-9D
			HOST_FQDN       : COMPUTER123.FQDN.COM
			TARGET_COMMENT  : This is a test
			WEB_OR_DATABASE : false
			WEB_DB_SITE     :
			WEB_DB_INSTANCE :

			This example demonstrates how to pull Asset Data from a single checklist that was imported using Import-Checklist and piped to Get-ChecklistAsset.
	#>

	[CmdletBinding(DefaultParameterSetName = 'FromFile')]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param (

		# Specify the Checklist XML object to be search.
		[Parameter(Mandatory, ParameterSetName = 'FromObject', ValueFromPipelineByPropertyName)]
		[System.Object[]]
		$Checklist,

		# Specify the Checklist Path, When path is provided the function will import the checklist.
		[Parameter(Mandatory, ParameterSetName = 'FromFile', ValueFromPipelineByPropertyName)]
		[Alias('FullName', 'PSPath')]
		[String[]]
		$Path

	)

	process {

		if ($Path) { $Checklist = Import-Checklist -Path "$Path" }

		$asset = $Checklist.XML.CHECKLIST.ASSET

		$outputData = [ordered] @{
			ROLE            = $asset.ROLE
			ASSET_TYPE      = $asset.ASSET_TYPE
			HOST_NAME       = $asset.HOST_NAME
			HOST_IP         = $asset.HOST_IP
			HOST_MAC        = $asset.HOST_MAC
			HOST_FQDN       = $asset.HOST_FQDN
			TECH_AREA       = $asset.TECH_AREA
			TARGET_KEY      = $asset.TARGET_KEY
			TARGET_COMMENT  = $asset.TARGET_COMMENT
			WEB_OR_DATABASE = $asset.WEB_OR_DATABASE
			WEB_DB_SITE     = $asset.WEB_DB_SITE
			WEB_DB_INSTANCE = $asset.WEB_DB_INSTANCE
			ChecklistPath   = $Checklist.Path
			ChecklistName   = $Checklist.Name
		}

        #Convert to PSObject
        $assetInfo = New-Object -TypeName PSObject -Property $outputData

        # Set Custom Format for object
        $assetInfo.PSObject.TypeNames.Insert(0,'Checklist.Asset')

        Write-Output $assetInfo

	}

}
