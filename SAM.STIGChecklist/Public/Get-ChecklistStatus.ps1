function Get-ChecklistStatus {

	<#
		.SYNOPSIS
			Get Metrics from a STIG Checklist

		.DESCRIPTION
			Get Metrics on Total Items, Item Status, and Open CAT Findings from a STIG Checklist. CATI, CATII, and CATIII are pulled from items that are in an Open status, this wont include items that are still not reviewd.

		.EXAMPLE
			PS C:\> Get-ChecklistStatus -Path "E:\_Temp\U_MS_Windows_Server_2016_STIG_V2R2.ckl"

			This example demonstrates how to get metrics from a single

			Output
				HostName      : Computer1
				STIGID        : Windows_Server_2016_STIG
				FileName      : U_MS_Windows_Server_2016_STIG_V2R2.ckl
				VulnCount     : 273
				Open          : 13
				NotAFinding   : 197
				NotReviewed   : 52
				NotApplicable : 11
				CATI          : 2
				CATII         : 11
				CATIII        : 0
				VuldDetails   : {NotReviewed, Open, NotAFinding, NotApplicable}
				FileInfo      : {CreationTime, LastAccessTime, LastWriteTime, FileHash…}
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

		$openFinding = @()
		$notAFinding = @()
		$notApplicable = @()
		$notReviewed = @()

		if ($Path) { $Checklist = Import-Checklist -Path "$Path" }

		$cklHostName = $($Checklist.XML.CHECKLIST.ASSET.HOST_NAME)
		$vulnCount = 0
		$catIFinding = 0
		$catIFinding = 0
		$catIIIFinding = 0

		$checklist.XML.CHECKLIST.STIGS.iSTIG.VULN | ForEach-Object {

			$vuln = $_
			$severity = $($vuln.STIG_DATA | Where-Object { $_.VULN_ATTRIBUTE -eq "Severity" }).ATTRIBUTE_DATA

			switch ($vuln.Status) {
				"Open" {

					$openFinding += $(Get-VulnItem -Object $vuln -ChecklistPath $Checklist.Path -HostName $cklHostName)

					Switch -regex ($severity) {
						'high|critical' { $catIFinding++ }
						'medium' { $catIIFinding++ }
						'low' { $catIIIFinding++ }
					}

				}
				"NotAFinding" { $notAFinding += $(Get-VulnItem -Object $vuln -ChecklistPath $Checklist.Path -HostName $cklHostName) }
				"Not_Reviewed" { $notReviewed += $(Get-VulnItem -Object $vuln -ChecklistPath $Checklist.Path -HostName $cklHostName) }
				"Not_Applicable" { $notApplicable += $(Get-VulnItem -Object $vuln -ChecklistPath $Checklist.Path -HostName $cklHostName) }
			}

			$vulnCount++
		}

		# Get File Details
		$cklFile = Get-Item -Path $Checklist.Path
		$cklFileHash = Get-FileHash -Path $Checklist.Path

		$cklFileDetails = [Ordered]@{
			CreationTime   = $cklFile.CreationTime
			LastAccessTime = $cklFile.LastAccessTime
			LastWriteTime  = $cklFile.LastWriteTime
			FileHash       = $cklFileHash.Hash
			HashAlgorithm  = $cklFileHash.Algorithm
		}

		# Compile Data
		$params = [Ordered]@{
			HostName      = $cklHostName
			STIGID        = $(Select-Xml -Xml $Checklist.XML -XPath "//SI_DATA[SID_NAME='stigid']").Node.SID_Data
			FileName      = $(Split-Path -Path $Checklist.Path -Leaf)
			VulnCount     = $vulnCount
			Open          = $openFinding.Count
			NotAFinding   = $notAFinding.Count
			NotReviewed   = $notReviewed.Count
			NotApplicable = $notApplicable.Count
			CATI          = $catIFinding
			CATII         = $catIIFinding
			CATIII        = $catIIIFinding
			VulnDetails   = @{
				Open          = $openFinding
				NotAFinding   = $notAFinding
				NotReviewed   = $notReviewed
				NotApplicable = $notApplicable
			}
			FileInfo      = $cklFileDetails
		}

		Write-Output $(New-Object -TypeName psobject -Property $params)

	}

}
