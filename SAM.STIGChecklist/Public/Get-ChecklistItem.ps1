function Get-ChecklistItem {

	<#
		.SYNOPSIS
			Get Checklist item details

		.DESCRIPTION
			Get all Checklist Vulns or search for specific ones across a single checklist or multiple checklists,

		.EXAMPLE
			$CKL Object
				Name      : Windows_Server-2016
				STIGID    : Windows_Server_2016_STIG
				Checklist : #document
				Path      : E:\_Temp\Windows_Server-2016.ckl

			PS C:\> Get-ChecklistItem -Checklist $ckl

			This example shows how get all vuln items from a single checklist.

		.EXAMPLE

			PS C:\> Get-ChildItem -Path E:\_Temp\Test -Filter "*.ckl" | Get-ChecklistItem -VulnID "V-224820"

			This example shows how to use Get-ChildItem to pull .ckl files from a directory and get a specific VulnID from each checklist.

		.EXAMPLE
			$CKL Object
				Name      : Windows_Server-2016
				STIGID    : Windows_Server_2016_STIG
				Checklist : #document
				Path      : E:\_Temp\Windows_Server-2016.ckl

			PS C:\> Get-ChecklistItem -Checklist $ckl -VulnID 'V-224820'

			Output:
				HostName               : COMPUTER123
				Vuln_Num               : V-224820
				Status                 : NotAFinding
				Severity               : medium
				Finding_Details        : This is a detail
				Comments               : This is a Comment
				Severity_Overide       :
				Severity_Justification :

			This example shows how get a single vuln item from a STIG Checklist.

		.EXAMPLE
			$CKL Object
				Name      : Windows_Server-2016
				STIGID    : Windows_Server_2016_STIG
				Checklist : #document
				Path      : E:\_Temp\Windows_Server-2016.ckl

			PS C:\> Get-ChecklistItem -Checklist $ckl -VulnID "V-224820", "V-224825"

			Output:
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
	#>

	[CmdletBinding(DefaultParameterSetName = 'FromFile')]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param (

		# Specify the Checklist XML object to be search.
		[Parameter(ParameterSetName = "FromObject", ValueFromPipelineByPropertyName)]
		[System.Object[]]
		$Checklist,

		# Specify the Checklist Path, When path is provided the function will import the checklist.
		[Parameter(ParameterSetName = "FromFile", ValueFromPipelineByPropertyName)]
		[Alias('FullName', 'PSPath')]
		[String[]]
		$Path,

		# Specify the STIG VulnID to search for.
		[Parameter(ParameterSetName = "FromObject", ValueFromPipelineByPropertyName)]
		[Parameter(ParameterSetName = "FromFile", ValueFromPipelineByPropertyName)]
		[String[]]
		$VulnID

	)

	process {

		if ($Path) { $Checklist = Import-Checklist -Path "$Path" }

		$cklHost = "$($Checklist.XML.CHECKLIST.ASSET.HOST_NAME)"
		$cklPath = $Checklist.Path

		if ($PSBoundParameters.VulnID) {

			# Poormans xPath Builder
			$xPath = "//STIG_DATA[VULN_ATTRIBUTE='Vuln_Num'"

			$count = 0

			$VulnID | ForEach-Object {

				if ($count -eq 0) {
					$xPath = $xPath + " and ATTRIBUTE_DATA='$_'"
				}
				else {
					$xPath = $xPath + " or ATTRIBUTE_DATA='$_'"
				}

				$count++

			}

			$xPath = $xPath + "]"

			Select-Xml -XML $Checklist.XML -XPath $xPath | ForEach-Object {
				Get-VulnItem -Object $_.Node.ParentNode -ChecklistPath $cklPath -HostName $cklHost
			}

		}
		else {

			$Checklist.XML.CHECKLIST.STIGS.iSTIG.VULN | ForEach-Object {
				Get-VulnItem -Object $_ -ChecklistPath $cklPath -HostName $cklHost
			}

		}

	}

}
