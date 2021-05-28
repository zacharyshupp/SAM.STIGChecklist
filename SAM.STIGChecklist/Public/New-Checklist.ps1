function New-Checklist {

	<#
		.SYNOPSIS
			Create a New STIG Checklist

		.DESCRIPTION
			This function creates a new STIG Checklist from the DoD Cyber Exchange.

		.EXAMPLE
            PS C:> $ckl = New-Checklist -Path "E:\_Temp\U_MS_Windows_Server_2016_V2R2_STIG.zip" -Destination E:\_Temp -PassThru

            This example shows how to create a new checklist from the zip file downloaded from Cyber.mil. This example also leverages the -PassThru switch that will output the Checklist object to use with other functions.

		.EXAMPLE
			Directory: E:\_Temp\Test

			Mode                 LastWriteTime         Length Name
			----                 -------------         ------ ----
			-a---           5/12/2021  9:56 AM         535864 U_A10_Networks_ADC_ALG_V2R1_STIG.zip
			-a---           5/12/2021  9:56 AM         276032 U_A10_Networks_ADC_NDM_V1R1_STIG.zip
			-a---           5/12/2021  9:56 AM         681814 U_AAA_Services_V1R2_SRG.zip
			-a---           5/12/2021  9:56 AM         640328 U_Active_Directory_Domain_V2R13_STIG.zip
			-a---           5/12/2021  9:56 AM         444331 U_Active_Directory_Forest_V2R8_STIG.zip
			-a---           5/12/2021  9:57 AM         680792 U_Adobe_Acrobat_Pro_DC_Classic_V2R1_STIG.zip

			PS C:>Get-ChildItem -Path E:\_Temp\Test -Filter "*.zip" | New-Checklist -Destination E:\_Temp\Checklists

			This example shows how to pull a directory full of zip files from Cyber.mil and convert them to Checklists. This will use the name of the zip file for the Checklist name

			Directory: E:\_Temp\Checklists

			Mode                 LastWriteTime         Length Name
			----                 -------------         ------ ----
			-a---           5/19/2021  8:20 AM         186660 U_A10_Networks_ADC_ALG_STIG_V2R1.ckl
			-a---           5/19/2021  8:20 AM         214704 U_A10_Networks_ADC_NDM_STIG_V1R1.ckl
			-a---           5/19/2021  8:20 AM         371142 U_AAA_Services_SRG_V1R2.ckl
			-a---           5/19/2021  8:20 AM         207120 U_Active_Directory_Domain_STIG_V2R13.ckl
			-a---           5/19/2021  8:20 AM          33416 U_Active_Directory_Forest_STIG_V2R8.ckl
			-a---           5/19/2021  8:20 AM         141849 U_Adobe_Acrobat_Pro_DC_Classic_V2R1.ckl

	#>

	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param (

		# Specifies the path to the XCCDF Benchmark file. The file must end in '*_Manual-xccdf.xml' or .zip.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "FromFile")]
		[ValidateScript( {
				if (-Not ($_ | Test-Path) ) { throw "XCCDF does not exist" }
				if ($_ -notmatch "\-xccdf.xml|\.zip") {
					throw "The file specified in the Path argument must be '*-xccdf.xml' or '.zip'"
				}
				return $true
			})]
		[Alias('FullName', 'PSPath')]
		[String]
		$Path,

		# Specifies the destination to save new STIG Checklits. If the Destination doesent exist the function will create it.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[String]
		$Destination,

		# Specifies the custom Checklist name to use when creationg the Stig Checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$ChecklistName,

		# Specifies the Classification for the checklist. Default value is 'UNCLASSIFIED'.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet('UNCLASSIFIED', 'CLASSIFIED')]
		[string]
		$Classification = "UNCLASSIFIED",

		# Specifies to overwrite the Checklist if there is one of the same name.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Switch]
		$Force,

		# Specifies if the function should return the checklist information
		[Parameter(ValueFromPipelineByPropertyName)]
		[Switch]
		$PassThru,

		# Specifies the regex string used to pull the xccdf file from the STIG Archive. By default it will pull all files that end in '_Manual-xccdf.xml'. If the zip archive has multiple xccdf files you will want to set the search.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$Search,

		# Specifies the host name for the checklist for either computer or non-computer checklists.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$HostName,

		# Specifies the Host IP Address for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$HostIP,

		# Specifies the Host MAC Address for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$HostMAC,

		# Specifies the Host FQDN for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$HostFQDN,

		# Specifies the Target Comment for the given host.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$Comment,

		# Specifies the Host WebSite for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$WebSite,

		# Specifies the Host Database Instance for the checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$DatabaseInstance,

		# Specifies the Host Database for Checklist.
		[Parameter(ValueFromPipelineByPropertyName)]
		[String]
		$Database,

		# Specifies the Asset Type for the checklist. Default value is Computing.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet('Non-Computing', 'Computing')]
		[String]
		$AssetType = 'Computing',

		# Specifies the Asset Role for the checklist. Default value is 'None'.
		[Parameter(ValueFromPipelineByPropertyName)]
		[ValidateSet('None', 'Workstation', 'Member Server', 'Domain Controller')]
		[String]
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
		[String]
		$TechnologyArea

	)

	begin {

		function Get-DisscussionItem ($Data, $Search) {

			$(Select-String -InputObject $Data -Pattern "<$Search>(.|\n)*?</$Search>" |
					ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }) -replace "<(/|)$Search>"

		}

		# Create XML Settings
		$xmlWriterSettings = [System.Xml.XmlWriterSettings]::new()
		$xmlWriterSettings.Indent = $true
		$xmlWriterSettings.IndentChars = "`t"
		$xmlWriterSettings.NewLineChars = "`n"

	}

	process {

		$xccdf = @()
		$pathExtenstion = $($path.Split(".")[-1]).ToLower()

		# Test Destination Path, Create if Missing
		if (!(Test-Path -Path $Destination)) {
			New-Item -Path $Destination -ItemType Directory | Out-Null
			Write-Verbose "[$($MyInvocation.MyCommand)] Created Missing Destination Directory"
		}

		switch ($pathExtenstion) {
			'zip' {

				$params = @{
					Path = $Path
				}

				if ($Search) { $params.add('Search', $Search) }

				$xccdf += Get-XCCDFFromArchive @params

			}
			'xml' {

				$params = [Ordered]@{
					Name = (Split-Path $Path -Leaf).Split(".")[0]
					Path = $Path
					XML  = [XML](Get-Content -Encoding UTF8 -Path $Path)
				}

				$xccdf += New-Object -TypeName PSObject -Property $params

			}

		}

		$xccdf | ForEach-Object {

			$benchmark = $_

			$defaultName = $benchmark.Name -replace "_Manual-xccdf.xml"

			# Generate Checklist Name if not Provided
			$fileName = if ($PSBoundParameters.ChecklistName) {
				$ChecklistName
			}
			else {

				if ($PSBoundParameters.HostName) {

					$fnParams = @{
						ChecklistName = $defaultName
						HostName      = $HostName
					}

					if ($PSBoundParameters.WebSite) {
						$fnParams.add('Website', $WebSite)
					}
					elseif ($PSBoundParameters.Database) {
						$fnParams.add('Database', $Database)
					}
					elseif ($PSBoundParameters.DatabaseInstance) {
						$fnParams.add('DatabaseInstance', $DatabaseInstance)
					}

					New-ChecklistFileName @fnParams

				}
				else {
					"{0}.ckl" -f $defaultName
				}

			}

			[System.IO.FileInfo]$cklPath = Join-Path -Path $Destination -ChildPath $fileName

			# Check if a file already exists
			if ($(Test-Path $cklPath.FullName) -eq $true -and !$force) {

				$errMessage = @{
					Message     = "Another Checklist with the Same name '$fileName' already exist at the destination. Use -Force to overide it."
					ErrorID     = "SAM0001"
					Category    = "ResourceExists"
					ErrorAction = "Stop"
				}

				Write-Error @errMessage

			}
			elseif ($(Test-Path $cklPath.FullName) -eq $true -and $Force) {

				if ($PSCmdlet.ShouldProcess($cklPath.FullName, "Remove Old checklist")) {

					Remove-Item -Path $cklPath.FullName -Force -ErrorAction Stop -Confirm:$false | Out-Null

				}

			}

			# Generate Checklist
			$xccdfBenchmark = $([xml]$benchmark.XML).Benchmark
			$xccdfFileName = $benchmark.Name
			$stigID = $xccdfBenchmark.id

			[xml]$cklSchema = Get-Content -Path $cklSchemaPath

			if ($PSCmdlet.ShouldProcess($cklPath.FullName, "Create Checklist")) {

				$writer = [System.Xml.XmlWriter]::Create($cklPath.FullName, $xmlWriterSettings)
				$module = $(Get-Command -Name $MyInvocation.MyCommand).ModuleName

				$writer.WriteComment(" Created by '$module' - Version: $((Get-Module -Name $module).Version.ToString()) ")
				$writer.WriteComment(" Following Cyber.Mil STIGViewer Checklist Schema V$($cklSchema.schema.annotation.appinfo.version) - $($cklSchema.schema.annotation.appinfo.date)")

				# [Checklist Element] -----------------------------------------------------
				$writer.WriteStartElement('CHECKLIST')

				# [Asset Element] -----------------------------------------------------
				$writer.WriteStartElement("ASSET")

				$assetData = [ordered] @{
					'ROLE'            = "None"
					'ASSET_TYPE'      = "$AssetType"
					'HOST_NAME'       = ""
					'HOST_IP'         = ""
					'HOST_MAC'        = ""
					'HOST_FQDN'       = ""
					'TARGET_COMMENT'  = ""
					'TECH_AREA'       = ""
					'TARGET_KEY'      = $($xccdfBenchmark.Group[0].Rule.reference.identifier)
					'WEB_OR_DATABASE' = 'false'
					'WEB_DB_SITE'     = ""
					'WEB_DB_INSTANCE' = ""
				}

				if ($PSBoundParameters.Role) { $assetData.ROLE = $Role }
				if ($PSBoundParameters.AssetType) { $assetData.ASSET_TYPE = $AssetType }
				if ($PSBoundParameters.HostName) { $assetData.HOST_NAME = $HostName }

				if ($AssetType -eq 'Computing') {

					if ($PSBoundParameters.HostIP) { $assetData.HOST_IP = $HostIP }
					if ($PSBoundParameters.HostMAC) { $assetData.HOST_MAC = $HostMAC }
					if ($PSBoundParameters.HostFQDN) { $assetData.HOST_FQDN = $HostFQDN }
					if ($PSBoundParameters.Comment) { $assetData.TARGET_COMMENT = $Comment }
					if ($PSBoundParameters.TechnologyArea) { $assetData.TECH_AREA = $TechnologyArea }

					if ($PSBoundParameters.WebSite) {
						$assetData.WEB_OR_DATABASE = 'true'
						$assetData.WEB_DB_SITE = $Website
					}

					if ($PSBoundParameters.DatabaseInstance) {
						$assetData.WEB_OR_DATABASE = 'true'
						$assetData.WEB_DB_INSTANCE = $DatabaseInstance
					}

					if ($PSBoundParameters.Database) {
						$assetData.WEB_OR_DATABASE = 'true'
						$assetData.WEB_DB_SITE = $Database
					}
				}

				# Create Asset Elements
				foreach ($asset in $assetData.GetEnumerator()) {
					$writer.WriteStartElement($asset.name)
					$writer.WriteString($asset.value)
					$writer.WriteEndElement()
				}

				$writer.WriteEndElement(<#ASSET#>)
				$writer.WriteStartElement("STIGS")
				$writer.WriteStartElement("iSTIG")
				$writer.WriteStartElement("STIG_INFO")

				$cklInfo = [ordered] @{
					'version'        = $xccdfBenchmark.version
					'classification' = $Classification
					'customname'     = ""
					'stigid'         = $xccdfBenchmark.id
					'description'    = $xccdfBenchmark.description #$(ConvertTo-SafeXML -String $xccdfBenchmark.description)
					'filename'       = $XCCDFFileName
					'releaseinfo'    = $xccdfBenchmark.'plain-text'.'#text'
					'title'          = $xccdfBenchmark.title
					'uuid'           = (New-Guid).Guid
					'notice'         = $xccdfBenchmark.notice.id
					'source'         = $xccdfBenchmark.reference.source
				}

				foreach ($info in $cklInfo.GetEnumerator()) {

					$writer.WriteStartElement("SI_DATA")

					$writer.WriteStartElement('SID_NAME')
					$writer.WriteString($info.name)
					$writer.WriteEndElement(<#SID_NAME#>)

					if ($info.value -ne "") {
						$writer.WriteStartElement('SID_DATA')
						$writer.WriteString($info.value)
						$writer.WriteEndElement(<#SID_DATA#>)
					}

					$writer.WriteEndElement(<#SI_DATA#>)

				}

				$writer.WriteEndElement(<#STIG_INFO#>)

				$xccdfBenchmark.Group | ForEach-Object {

					$vulnId = $_
					$stigRef = "{0} :: Version {1}, {2}" -f $cklInfo.Title, $cklInfo.Version, $cklInfo.ReleaseInfo
					$writer.WriteStartElement("VULN")

					$cciList = $_.Rule.ident | Where-Object { $_.System -eq 'http://iase.disa.mil/cci' }
					$legList = $_.Rule.ident | Where-Object { $_.system -eq 'http://cyber.mil/legacy' }

					$vulnInfo = [ordered] @{
						Vuln_Num                   = $vulnId.id
						Severity                   = $vulnId.Rule.severity
						Group_Title                = $vulnId.title
						Rule_ID                    = $vulnId.Rule.id
						Rule_Ver                   = $vulnId.Rule.version
						Rule_Title                 = $vulnId.Rule.title
						Vuln_Discuss               = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "VulnDiscussion")
						IA_Controls                = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "IAControls")
						Check_Content              = $vulnId.Rule.check.'check-content'
						Fix_Text                   = $vulnId.Rule.fixtext.InnerText
						False_Positives            = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "FalsePositives")
						False_Negatives            = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "FalseNegatives")
						Documentable               = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "Documentable")
						Mitigations                = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "Mitigations")
						Potential_Impact           = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "PotentialImpacts")
						Third_Party_Tools          = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "ThirdPartyTools")
						Mitigation_Control         = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "MitigationControl")
						Responsibility             = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "Responsibility")
						Security_Override_Guidance = $(Get-DisscussionItem -Data "$($vulnId.Rule.description)" -Search "SeverityOverrideGuidance")
						Check_Content_Ref          = $vulnId.Rule.check.'check-content-ref'.name
						Weight                     = $vulnId.Rule.Weight
						Class                      = 'Unclass'
						STIGRef                    = $stigRef
						TargetKey                  = $_.Rule.reference.identifier
						STIG_UUID                  = (New-Guid).Guid
					}

					foreach ($vuln in $vulnInfo.GetEnumerator()) {

						$writer.WriteStartElement("STIG_DATA")

						$writer.WriteStartElement("VULN_ATTRIBUTE")
						$writer.WriteString($vuln.Name)
						$writer.WriteEndElement(<#VULN_ATTRIBUTE#>)

						$writer.WriteStartElement("ATTRIBUTE_DATA")
						$writer.WriteString($vuln.Value)
						$writer.WriteEndElement(<#ATTRIBUTE_DATA#>)

						$writer.WriteEndElement(<#STIG_DATA#>)

					}

					if ($legList) {

						$legList.'#text' | ForEach-Object {

							$writer.WriteStartElement("STIG_DATA")

							$writer.WriteStartElement("VULN_ATTRIBUTE")
							$writer.WriteString('LEGACY_ID')
							$writer.WriteEndElement(<#VULN_ATTRIBUTE#>)

							$writer.WriteStartElement("ATTRIBUTE_DATA")
							$writer.WriteString($_)
							$writer.WriteEndElement(<#ATTRIBUTE_DATA#>)

							$writer.WriteEndElement(<#STIG_DATA#>)

						}

					}
					else {

						# Mimics STIGViewer and put two empty Legacy_IDs.
						$writer.WriteStartElement("STIG_DATA")

						$writer.WriteStartElement("VULN_ATTRIBUTE")
						$writer.WriteString('LEGACY_ID')
						$writer.WriteEndElement(<#VULN_ATTRIBUTE#>)

						$writer.WriteStartElement("ATTRIBUTE_DATA")
						$writer.WriteString("")
						$writer.WriteEndElement(<#ATTRIBUTE_DATA#>)

						$writer.WriteEndElement(<#STIG_DATA#>)

						$writer.WriteStartElement("STIG_DATA")

						$writer.WriteStartElement("VULN_ATTRIBUTE")
						$writer.WriteString('LEGACY_ID')
						$writer.WriteEndElement(<#VULN_ATTRIBUTE#>)

						$writer.WriteStartElement("ATTRIBUTE_DATA")
						$writer.WriteString("")
						$writer.WriteEndElement(<#ATTRIBUTE_DATA#>)

						$writer.WriteEndElement(<#STIG_DATA#>)
					}

					$cciList.'#text' | ForEach-Object {

						$writer.WriteStartElement("STIG_DATA")

						$writer.WriteStartElement("VULN_ATTRIBUTE")
						$writer.WriteString('CCI_REF')
						$writer.WriteEndElement(<#VULN_ATTRIBUTE#>)

						$writer.WriteStartElement("ATTRIBUTE_DATA")
						$writer.WriteString($_)
						$writer.WriteEndElement(<#ATTRIBUTE_DATA#>)

						$writer.WriteEndElement(<#STIG_DATA#>)

					}

					$writer.WriteStartElement("STATUS")
					$writer.WriteString('Not_Reviewed')
					$writer.WriteEndElement(<#STATUS#>)

					$writer.WriteStartElement("FINDING_DETAILS")
					$writer.WriteString('')
					$writer.WriteEndElement(<#FINDING_DETAILS#>)

					$writer.WriteStartElement("COMMENTS")
					$writer.WriteString('')
					$writer.WriteEndElement(<#COMMENTS#>)

					$writer.WriteStartElement("SEVERITY_OVERRIDE")
					$writer.WriteString('')
					$writer.WriteEndElement(<#SEVERITY_OVERRIDE#>)

					$writer.WriteStartElement("SEVERITY_JUSTIFICATION")
					$writer.WriteString('')
					$writer.WriteEndElement(<#SEVERITY_JUSTIFICATION#>)

					$writer.WriteEndElement(<#VULN#>)
				}

				$writer.WriteEndElement(<#iSTIG#>)

				$writer.WriteEndElement(<#STIGS#>)

				$writer.WriteEndElement(<#CHECKLIST#>)

				# Close XML Writer
				$writer.Flush()
				$writer.Close()

				# Test Checklist
				$results = Test-XMLFile -XmlPath $cklPath.FullName -SchemaPath $cklSchemaPath

				If ($results.Valid -eq $false) {
					throw $results.Exceptions
				}
				else {

					if ($PassThru) {

						$params = [Ordered]@{
							Name   = $cklPath.BaseName
							STIGID = $stigID
							XML    = [XML](Get-Content -Encoding UTF8 -Path $cklPath.FullName)
							Path   = $cklPath.FullName
						}

						#Convert to PSObject
						$import = New-Object -TypeName PSObject -Property $params

						# Set Custom Format for object
						$import.PSObject.TypeNames.Insert(0, 'Checklist.Import')

						Write-Output $import

					}

				}

			}

		}

	}

}
