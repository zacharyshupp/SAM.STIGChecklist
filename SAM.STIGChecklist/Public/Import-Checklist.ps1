Function Import-Checklist {

    <#
        .SYNOPSIS
            Import STIG Checklist (CKL)

        .DESCRIPTION
            Load a CKL file as an [XML] element. This can then be passed to other functions in this module.

        .EXAMPLE
            PS:> $ckl = Import-Checklist -Checklist C:\Temp\U_Windows10.ckl

            This example shows how to import a checklist.

            OUTPUT
            ------
            Name      : Path
            STIGID    : IIS_10-0_Site_STIG
            Checklist : #document
            Path      : E:\_Temp\Checklists\U_MS_IIS_10-0_Site_STIG_V2R2.ckl
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    Param(

        # Specify the path to the STIG Checklist. When function is ran, it will validate the file passed exists and is a .ckl file.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateScript( {
                if (-Not ($_ | Test-Path) ) {
                    throw "Checklist does not exist"
                }
                if ($_ -notmatch "\.ckl") {
                    throw "The file specified in the Checklist argument must be '.ckl'"
                }
                return $true
            })]
        [Alias('FullName', 'PSPath')]
        [String]
        $Path

    )

    process {

        $results = Test-XMLFile -XmlPath $Path -SchemaPath $cklSchemaPath

        If ($results.Valid -eq $false) {
            throw $results.Exceptions
        }
        else {

            $xml = [XML](Get-Content -Encoding UTF8 -Path $Path)

            $params = [Ordered]@{
                Name   = (Split-Path $Path -Leaf).Split(".")[0]
                STIGID = (Select-Xml -Xml $xml.Checklist -XPath "//SI_DATA[SID_NAME='stigid']").Node.SID_Data
                XML    = $xml
                Path   = $Path
            }

            #Convert to PSObject
            $import = New-Object -TypeName PSObject -Property $params

            # Set Custom Format for object
            $import.PSObject.TypeNames.Insert(0, 'Checklist.Import')

            Write-Output $import

        }

    }

}
