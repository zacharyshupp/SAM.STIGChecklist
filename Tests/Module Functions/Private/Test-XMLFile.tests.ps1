BeforeAll {

	$projectRoot = $env:SAMProjectPath
	$moduleName = $env:SAMProjectName
	$fctName = "Test-XMLFile"

	$fctPath = [IO.Path]::Combine("$projectRoot", $moduleName, 'Private', "$fctName`.ps1")

	. $fctPath

}

Describe "Test-XMLFile (Private Function)" {

	BeforeAll {
		$mockCKLPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG.ckl")
		$schemaPath = [IO.Path]::Combine("$projectRoot", "$($env:SAMProjectName)", 'Data', "U_Checklist_Schema_V2.xsd")
		$mockCKL1IssuePath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG-BadSchema-1issue.ckl")
		$mockCKL2IssuePath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG-BadSchema-2issue.ckl")
	}

	It "Should throw an error when an invlaid XMLPath is provided" {
		$testCklPath = Join-Path -Path $TestDrive -ChildPath "Windows10.ckl"
		{Test-XMLFile -XmlPath $testCklPath -SchemaPath $schemaPath} | Should -Throw
	}

	It "Should throw an error when an invlaid SchemaPath is provided" {
		{Test-XMLFile -XmlPath $mockCKLPath -SchemaPath ""} | Should -Throw
	}

    It "Should return the XML is valid" {
		(Test-XMLFile -XmlPath $mockCKLPath -SchemaPath $schemaPath).Valid | Should -be $true
    }

    It "Should Return the XML is invlaid with a Single Issue" {
		$test = Test-XMLFile -XmlPath $mockCKL1IssuePath -SchemaPath $schemaPath
		$test.Valid | Should -be $false
		$test.Exceptions.Count | Should -be 1
    }

	It "Should Return the XML is invlaid with multiple issue" {
		$test = Test-XMLFile -XmlPath $mockCKL2IssuePath -SchemaPath $schemaPath
		$test.Valid | Should -be $false
		$test.Exceptions.Count | Should -be 2
    }

}
