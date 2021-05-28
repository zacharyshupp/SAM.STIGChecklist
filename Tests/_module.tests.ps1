
BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath

	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$prjSourcePath = Join-Path -Path $projectRoot -ChildPath $moduleName
	$prjSrcPublicPath = Join-Path -Path $prjSourcePath -ChildPath Public

	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName
	$mdlPublicFunctions = Get-ChildItem -Path $prjSrcPublicPath -Recurse

	# Remove all versions of the module from the session. Pester can't handle multiple versions.
    Get-Module $moduleName | Remove-Module -Force -ErrorAction Ignore
}

Describe "General Module Control" {

    It "Should Import without Errors" {
        { Import-Module -Name $mdlPath -Force -ErrorAction Stop } | Should -Not -Throw
        Get-Module $moduleName | Should -Not -BeNullOrEmpty
    }

    It "Should Remove without Errors" {
        { Remove-Module -Name $moduleName -ErrorAction Stop } | Should -Not -Throw
        Get-Module $moduleName | Should -BeNullOrEmpty
    }

}

Describe "Module Details" {

    BeforeAll {

        $moduleDetials = Import-Module -Name $mdlPath -Force -ErrorAction Stop -PassThru

    }

    It "Should contain RootModule" { $moduleDetials.RootModule | Should -Not -BeNullOrEmpty }

    It "Should contain a Author" { $moduleDetials.Author | Should -Not -BeNullOrEmpty }

    It "Should contain a Copyright" { $moduleDetials.Copyright | Should -Not -BeNullOrEmpty }

    It "Should contain a Project URL" { $moduleDetials.ProjectUri | Should -Not -BeNullOrEmpty }

    It "Should contain a License URL" { $moduleDetials.LicenseUri | Should -Not -BeNullOrEmpty }

    It "Should contain a Description" { $moduleDetials.Description | Should -Not -BeNullOrEmpty }

	It "Should contain Release Notes" { $moduleDetials.ReleaseNotes | Should -Not -BeNullOrEmpty }

	It "Should contain same number of ExportedFunctions as Source" {
		$moduleDetials.ExportedFunctions.Count | Should -be $mdlPublicFunctions.Count
	}

	# Added Additional Checks based on Module requirements
}
