
function ConvertTo-SafeXml {

    <#
        .SYNOPSIS
            Escapes invalid characters in the input to create safe XML output.

		.DESCRIPTION
			Escapes invalid characters in the input to create safe XML output.

		.EXAMPLE
			$escaped = $(ConvertTo-SafeXML -String $Database)

			This example shows how to call the function.

    #>

    [CmdletBinding()]
	[OutputType([string])]
    param(

        # Specify the text string to escape invlaid characters.
        [Parameter(Mandatory)]
        [String]
        [AllowEmptyString()]
        $String

    )

    Write-Output $([System.Security.SecurityElement]::Escape($String))

}
