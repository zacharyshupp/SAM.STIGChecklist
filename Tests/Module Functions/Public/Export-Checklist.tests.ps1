BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath
	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module $mdlPath -Force

	$mockCKLPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG.ckl")


}

Describe "Export-Checklist" {

	BeforeAll {

		$cklTestPath = Copy-Item -Path $mockCKLPath -Destination $TestDrive -PassThru
		$ckl = Import-Checklist -Path $cklTestPath.FullName

	}

	BeforeEach {
		Remove-Item -Path $cklTestPath.FullName
	}

	It "Should Export Checklist with no issues via Pipeline" {

		$ckl | Export-Checklist
		Test-Path -Path $cklTestPath.FullName | Should -be $true

	}

	It "Should Export Checklist and Create a Different Checklist" {
		$newCKLPath = Join-Path -Path $TestDrive -ChildPath "Windows10.ckl"
		$ckl | Export-Checklist -Destination $newCKLPath
		Test-Path -Path $newCKLPath | Should -be $true
	}

}
