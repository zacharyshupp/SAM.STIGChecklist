function New-ChecklistFileName {

	<#
	.SYNOPSIS
		Create a file name for STIG checklists

	.DESCRIPTION
		Create a file name for STIG checklists that include the Hostname, and STIG Name. For the Checklist specific for Websites, Databases, or Database instance will be added to the name as well.

	.EXAMPLE
		PS C:\> New-ChecklistFileName -ChecklistName "U_MS_Dot_Net_Framework_4-0_STIG_V1R9" -HostName "Computer1"

		Output: Computer1-U_MS_Dot_Net_Framework_4-0_STIG_V1R9.ckl

		Thie example demonstrates how to create a file name.

	#>

	[CmdletBinding(DefaultParameterSetName = "Host")]
	[OutputType([String])]
	param (

		# Specifies the default checklist name
		[Parameter(Mandatory)]
		[String]
		$ChecklistName,

		# Specifies the Host Name for the checklist.
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Host")]
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Website")]
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "DBInstance")]
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Database")]
		[string]
		$HostName,

		# Specifies the Host WebSite for the checklist.
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Website")]
		[string]
		$WebSite,

		# Specifies the Host Database Instance for the checklist.
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "DBInstance")]
		[string]
		$DatabaseInstance,

		# Specifies the Host Database for Checklist.
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Database")]
		[string]
		$Database

	)

	process {

		$ckItem = $null

		switch ($PsCmdlet.ParameterSetName) {
			'Website' { $ckItem = $WebSite }
			'DBInstance' { $ckItem = $DatabaseInstance }
			'Database' { $ckItem = $Database }
		}

		if ($ckItem) {
			"{0}-{1}-{2}.ckl" -f $HostName, $ckItem, $ChecklistName
		}
		else {
			"{0}-{1}.ckl" -f $HostName, $ChecklistName
		}

	}

}
