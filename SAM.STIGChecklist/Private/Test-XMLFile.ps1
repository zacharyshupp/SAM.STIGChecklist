function Test-XMLFile {

	[CmdletBinding()]
	param (

		# Specifies the path to the xml file to be tested.
		[Parameter(Mandatory, ValueFromPipeline)]
		[System.IO.FileInfo[]]
		$XmlPath,

		# Specifies the path to the xml schema file to use to validate the xml files.
		[Parameter(Mandatory)]
		[System.IO.FileInfo]
		$SchemaPath

	)

	begin {

		[Scriptblock] $ValidationEventHandler = {

			If ($_.Exception.LineNumber) {
				$Message = "$($_.Exception.Message) Line $($_.Exception.LineNumber), Position $($_.Exception.LinePosition)."
			}
			Else {
				$Message = ($_.Exception.Message)
			}

			$schemaErrors.Add([PSCustomObject]@{Message = $Message })
		}

	}

	process {

		$XmlPath | ForEach-Object {

			$xmlFile = $_

			$schemaErrors = New-Object System.Collections.Generic.List[System.Object]

			$ReaderSettings = New-Object -TypeName System.Xml.XmlReaderSettings
			$ReaderSettings.ValidationType = [System.Xml.ValidationType]::Schema
			$ReaderSettings.ValidationFlags = [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessIdentityConstraints -bor [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessSchemaLocation -bor [System.Xml.Schema.XmlSchemaValidationFlags]::ReportValidationWarnings
			$ReaderSettings.Schemas.Add($null, $SchemaPath.FullName) | Out-Null
			$readerSettings.add_ValidationEventHandler($ValidationEventHandler)

			Try {

				$Reader = [System.Xml.XmlReader]::Create($xmlFile.FullName, $ReaderSettings)
				While ($Reader.Read()) {}
			}
			Catch {
				$schemaErrors.Add([PSCustomObject]@{ Message = ($_.Exception.Message) })
			}
			Finally {
				$Reader.Close()
			}

			$xmlOutput = [ordered]@{
				XMLFile = $xmlFile.Name
				Valid   = $true
			}

			If ($schemaErrors) {
				$xmlOutput.Valid = $false
				$xmlOutput.Add("Exceptions", $schemaErrors.Message)
			}

			Write-Output $(New-Object -TypeName PSObject -Property $xmlOutput)

		}

	}

}
