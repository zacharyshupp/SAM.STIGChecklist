BeforeAll {

	$projectRoot = $env:SAMProjectPath
	$moduleName = $env:SAMProjectName
	$fctName = "ConvertTo-SafeXml"

	$fctPath = [IO.Path]::Combine("$projectRoot", $moduleName, 'Private', "$fctName`.ps1")

	. $fctPath

}

Describe "ConvertTo-SafeXml (Private Function)" {

	It "Should escape '<'" { ConvertTo-SafeXml -String "Test<" | Should -Be "Test&lt;" }

	It "Should escape '>'" { ConvertTo-SafeXml -String "Test>" | Should -Be "Test&gt;" }

	It "Should escape '`"'" { ConvertTo-SafeXml -String "Test`"" | Should -Be "Test&quot;" }

	It "Should escape '`''" { ConvertTo-SafeXml -String "Test`'" | Should -Be "Test&apos;" }

	It "Should escape '&'" { ConvertTo-SafeXml -String "Test&" | Should -Be "Test&amp;" }

}
