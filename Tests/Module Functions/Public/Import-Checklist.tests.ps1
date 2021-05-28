BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath
	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module $mdlPath -Force

}

Describe "Import-Checklist" {

	It "Should throw an error when an invlaid path is provided" {
		$testCklPath = Join-Path -Path $TestDrive -ChildPath "Windows10.ckl"
		{Import-Checklist -Path $testCklPath} | Should -Throw
	}

	It "Should Import Checklist with no issues" {
		$cklPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG.ckl")
		$ckl = Import-Checklist -Path $cklPath
		$ckl.XML | Should -Not -BeNullOrEmpty
	}

	It "Should Fail to Import Bad Checklist" {
		$cklPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG-BadSchema.ckl")
		{ Import-Checklist -Path $cklPath } | Should -Throw
	}

}
