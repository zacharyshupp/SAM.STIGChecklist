
function Get-VulnItem {

    <#
        .SYNOPSIS
            Converts xml Object to Checklist.Item

		.EXAMPLE
			$Checklist.XML.CHECKLIST.STIGS.iSTIG.VULN | ForEach-Object {
				Get-VulnItem -Object $_ -ChecklistPath $cklPath -HostName $cklHost
			}

			This example demonstrates how to call the function.

    #>

	param (

        # Specifies the Vuln Object to convert.
        [Parameter(Mandatory)]
		[System.Object]
		$object,

		# Specifies the HostName for the checklist
		[Parameter()]
		[String]
		$HostName = "",

		# Specifies the Checklist Path
		[Parameter(Mandatory)]
		[String]
		$ChecklistPath

	)

	$checklistName = Split-Path -Path $ChecklistPath -Leaf

	$vulnId = $($object.STIG_Data | Where-Object { $_.VULN_ATTRIBUTE -eq "Vuln_Num" }).ATTRIBUTE_DATA

	$vuln = [Ordered]@{
		HostName               = $HostName
		Vuln_Num               = $vulnId
		Status                 = $object.Status
		Finding_Details        = $object.Finding_Details
		Comments               = $object.Comments
		Severity_Overide       = $object.Severity_Override
		Severity_Justification = $object.Severity_Justification
		ChecklistPath          = $ChecklistPath
		Checklist              = $checklistName
	}

	$object.STIG_Data | ForEach-Object {
		if ($_.VULN_ATTRIBUTE -notmatch "Vuln_Num|CCI_REF|LEGACY_ID") {
			$vuln.add($_.VULN_ATTRIBUTE, $_.ATTRIBUTE_DATA)
		}
	}

	# Add CCI and LegacyID
	$cci = $($object.STIG_Data | Where-Object { $_.VULN_ATTRIBUTE -eq "CCI_REF" }).ATTRIBUTE_DATA
	$lID = $($object.STIG_Data | Where-Object { $_.VULN_ATTRIBUTE -eq "LEGACY_ID" }).ATTRIBUTE_DATA

	$vuln.add("CCI_REF", $cci)
	$vuln.add("LEGACY_ID", $lID)

	#Convert to PSObject
	$vulnData = New-Object -TypeName PSObject -Property $vuln

	# Set Custom Format for object
	$vulnData.PSObject.TypeNames.Insert(0,'Checklist.Item')

	Write-Output $vulnData

}
