function Get-XCCDFFromArchive {
	[CmdletBinding()]
	param (

		# Specifies the STIG Zip file to use.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateScript( {
			if (-Not ($_ | Test-Path) ) {
				throw "Archive does not exist"
			}
			if ($_ -notmatch "\.zip") {
				throw "The file specified in the Path argument must be '.zip'"
			}
			return $true
		})]
        [Alias('FullName', 'PSPath')]
        [System.IO.FileInfo[]]
		$Path,

		# Specifies the regex string used to pull the xccdf file from the STIG Archive. By default the search pulls all files that are like '_Manual-xccdf.xml', then the search is used to pull from just those files.
		[Parameter()]
		[String]
		$Search = '_Manual-xccdf.xml'

	)

	begin {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
	}

	process {

		$Path | ForEach-Object {

			$archivePath = $_

			$zip = [System.IO.Compression.ZipFile]::OpenRead($archivePath.FullName)

			$zip.Entries | Where-Object { $_.Name -like "*_Manual-xccdf.xml" -and $_.Name -Match $Search } | ForEach-Object {

				try {
					$stream = $_.Open()
					$reader = New-Object IO.StreamReader($stream)
					$xccdf = $reader.ReadToEnd()
				}
				catch {
					$_
				}
				finally {
					$reader.Close()
					$stream.Close()
				}

				$fileData = [Ordered]@{
					Name = $_.Name
					Path = $archivePath.FullName
					XML  = $xccdf
				}

				Write-Output (New-Object -TypeName PSObject -Property $fileData)
			}

			$zip.Dispose()

		}

	}

}
