BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath
	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module $mdlPath -Force

	$mockCKLPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG.ckl")
}

Describe "Get-ChecklistItem" {

	It "Should Return a list of Vulns with no Errors" {
		Get-ChecklistItem -Path $mockCKLPath | Should -Not -BeNullOrEmpty
	}

	It "Should Return a Single Vuln with no Errors" {
		$findings = Get-ChecklistItem -Path $mockCKLPath -VulnID V-220759
		$findings.Count | Should -be 1
	}

}
