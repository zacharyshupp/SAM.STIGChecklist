function Export-Checklist {

	<#
		.SYNOPSIS
			Export STIG Checklist to File

		.DESCRIPTION
			Export STIG Checklist to File

		.EXAMPLE
			$CKL Object
				Name   : Windows_Server-2016
				STIGID : Windows_Server_2016_STIG
				XML    : #document
				Path   : E:\_Temp\Windows_Server-2016.ckl

            PS C:\> Export-Checklist -Checklist $CKL

            This example shows how to Export a checklist. $CKL is passed with the xml data and then it is saved to the location listed in $CKL.Path.

		.EXAMPLE
			$CKL Object
				Name   : Windows_Server-2016
				STIGID : Windows_Server_2016_STIG
				XML    : #document
				Path   : E:\_Temp\Windows_Server-2016.ckl

			PS C:\> $ckl | Export-Checklist -Destination "E:\$($ckl.Name)`-v1.ckl"

			This example shows how you can use an imported checklist to export it to another file to create a copy.

		.EXAMPLE
			$CKL Object
				Name   : Windows_Server-2016
				STIGID : Windows_Server_2016_STIG
				XML    : #document
				Path   : E:\_Temp\Windows_Server-2016.ckl

			PS C:\> $ckl | Export-Checklist

			This example shows how you can use an imported checklist and pipe it to Export-Checklist. In this example, Export-Checklist will export the Checklist to whats listed in $CKL.Path
	#>

	[CmdletBinding()]
	[OutputType([System.Void])]
	param (

		# Specifies the XML Object created from Import-Checklist.
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[PSObject]
		$Checklist,

		# Specifies the path to the STIG Checklist.
		[Parameter()]
		[ValidateScript( {
				if ($_ -notmatch "\.ckl") {
					throw "The file specified in the Checklist argument must be '.ckl'"
				}
				return $true
			})]
		[String]
		$Destination
	)

	process {

		if (!$PSBoundParameters.Destination) { $Destination = $Checklist.Path }

		try {

			$XMLSettings = New-Object -TypeName System.XML.XMLWriterSettings
			$XMLSettings.Indent = $true;
			$XMLSettings.IndentChars = "`t"
			$XMLSettings.NewLineChars = "`n"
			$XMLSettings.Encoding = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList @($false)
			$XMLSettings.ConformanceLevel = [System.Xml.ConformanceLevel]::Document

			$XMLWriter = [System.XML.XMLTextWriter]::Create("$Destination", $XMLSettings)

			$Checklist.XML.InnerXml = $Checklist.XML.InnerXml -replace "&#x0;", "[0x00]"

			$Checklist.XML.Save($XMLWriter)

		}
		catch {

			Throw $_

		}
		finally {

			if ($XMLWriter) {
				$XMLWriter.Flush()
				$XMLWriter.Dispose()
			}

		}

	}

}
