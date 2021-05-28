BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath
	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module $mdlPath -Force

	$mockZIPPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_Adobe_Acrobat_Reader_DC_Continuous_V1R6_STIG.zip")
	$mockBenchmarkPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_Adobe_Acrobat_Reader_DC_Continuous_STIG_V1R6_Manual-xccdf.xml")

	$mockWin2016Zip = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_Server_2016_V2R2_STIG.zip")
	$mockWin2019Zip = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_Server_2019_V2R2_STIG.zip")
	$mockIISZip = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_IIS_10-0_Y21M04_STIG.zip")

}

Describe "New-Checklist" {

	BeforeEach {
		$testCKLPath = Join-Path -Path $TestDrive -ChildPath "Test.ckl"

		if(Test-Path $testCKLPath){Remove-Item -Path $testCKLPath -Force | Out-Null}
	}

	It "Should Generate a Checklist file using ZIP File" {
		$ckl = New-Checklist -Path $mockZIPPath -Destination $TestDrive -PassThru
		Test-Path $ckl.Path | Should -be True
	}

	It "Should Generate a Checklist file using XML File" {
		$ckl = New-Checklist -Path $mockBenchmarkPath -Destination $TestDrive -PassThru
		Test-Path $ckl.Path | Should -be True
	}

	It "Should Generate a Checklist file using ZIP File with a custom checklist name" {
		$ckl = New-Checklist -Path $mockZIPPath -Destination $TestDrive -ChecklistName "Test.ckl" -PassThru
		Test-Path $ckl.Path | Should -be True
	}

	It "Should Generate a Checklist file using XML File with a custom checklist name" {
		$ckl = New-Checklist -Path $mockBenchmarkPath -Destination $TestDrive -ChecklistName "Test.ckl" -PassThru
		Test-Path $ckl.Path | Should -be True
	}

	It "Should Generate a single Checklist with a search applied" {
		$ckl = New-Checklist -Path $mockIISZip -Destination $TestDrive -ChecklistName "TestIIS10.ckl" -Search "Site" -PassThru
		Test-Path $ckl.Path | Should -be True
	}

	It "Should Generate a single Checklist with a HostName applied" {
		$ckl = New-Checklist -Path $mockWin2016Zip -Destination $TestDrive -HostName "Computer1" -PassThru
		Test-Path $ckl.Path | Should -be True
		$ckl.Name | Should -be "Computer1-U_MS_Windows_Server_2016_STIG_V2R2"
		$ckl.XML.CHECKLIST.ASSET.HOST_NAME | Should -be 'Computer1'
	}

	It "Should Generate a single Checklist with a HostName and Website applied" {
		$ckl = New-Checklist -Path $mockIISZip -Destination $TestDrive -HostName "Computer1" -WebSite 'Default' -Search 'Site' -PassThru
		Test-Path $ckl.Path | Should -be True
		$ckl.Name | Should -be "Computer1-Default-U_MS_IIS_10-0_Site_STIG_V2R2"
		$ckl.XML.CHECKLIST.ASSET.HOST_NAME | Should -be 'Computer1'
	}

}
