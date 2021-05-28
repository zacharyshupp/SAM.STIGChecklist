BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath
	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module $mdlPath -Force

	$mockCKLPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG.ckl")
}

Describe "Get-ChecklistAsset" {

	It "Should Return Asset Data using Path Input" {
		Get-ChecklistAsset -Path $mockCKLPath | Select-Object -ExpandProperty HOST_NAME | Should -Be "Computer"
	}

	It "Should Return Asset Data using Checklist Input" {
		$ckl = Import-Checklist -Path $mockCKLPath
		Get-ChecklistAsset -Checklist $ckl | Select-Object -ExpandProperty HOST_NAME | Should -Be "Computer"
	}

	It "Should Return Asset Data using Import-Checklist and Pipe to Get-ChecklistAsset" {
		Import-Checklist -Path $mockCKLPath | Get-ChecklistAsset | Select-Object -ExpandProperty HOST_NAME | Should -Be "Computer"
	}

}
