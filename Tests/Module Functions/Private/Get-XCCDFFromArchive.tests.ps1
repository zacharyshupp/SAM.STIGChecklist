BeforeAll {

	$projectRoot = $env:SAMProjectPath
	$moduleName = $env:SAMProjectName
	$fctName = "Get-XCCDFFromArchive"

	$fctPath = [IO.Path]::Combine("$projectRoot", $moduleName, 'Private', "$fctName`.ps1")

	. $fctPath

	$mockPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_Adobe_Acrobat_Reader_DC_Continuous_V1R6_STIG.zip")
}

Describe "Get-XCCDFFromArchive (Private Function)" {

	It "Should Return the XCCDF XML Object" {
		$xccdf = Get-XCCDFFromArchive -Path $mockPath
		$xccdf | Should -BeOfType PSObject
		$xccdf.XML | Should -Not -BeNullOrEmpty
	}

}
