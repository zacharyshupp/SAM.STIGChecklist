BeforeAll {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath
	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"
	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module $mdlPath -Force

	$mockCKLPath = [IO.Path]::Combine("$projectRoot", "Tests", 'Mocks', "U_MS_Windows_10_V2R2_STIG.ckl")

}

Describe "Set-ChecklistAsset" {

	BeforeEach {

		Remove-Item -Path $(Join-Path -Path $TestDrive -ChildPath "U_MS_Windows_10_V2R2_STIG.ckl") -ErrorAction Ignore
		$cklTestPath = Copy-Item -Path $mockCKLPath -Destination $TestDrive -PassThru

	}

	It "Should throw an error if Path is not provided" { { Set-ChecklistAsset -Path "" } | Should -Throw}

	It "Should set the HostName" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -HostName "Computer123"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).Host_Name | Should -be "Computer123"
	}

	It "Should set the Host IP" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -HostIP "10.0.0.4"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).HOST_IP | Should -be "10.0.0.4"
	}

	It "Should set the Host MAC Address" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -HostMAC "00-15-5D-B0-3C-EB"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).Host_MAC | Should -be "00-15-5D-B0-3C-EB"
	}

	It "Should set the Host FQDN" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -HostFQDN "Computer123.domain.com"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).HOST_FQDN | Should -be "Computer123.domain.com"
	}

	It "Should set the Target Comment" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -Comment "This is a Comment"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).TARGET_COMMENT | Should -be "This is a Comment"
	}

	It "Should set the Website" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -WebSite "www.google.com"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).WEB_OR_DATABASE | Should -be "true"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).WEB_DB_SITE | Should -be "www.google.com"
	}

	It "Should set the Database" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -Database "DB01"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).WEB_OR_DATABASE | Should -be "true"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).WEB_DB_SITE | Should -be "DB01"
	}

	It "Should set the Database Instance" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -DatabaseInstance "DB01-Instance"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).WEB_OR_DATABASE | Should -be "true"
		(Get-ChecklistAsset -Path $cklTestPath.FullName).WEB_DB_INSTANCE | Should -be "DB01-Instance"
	}

	It "Should set the Asset Role" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -Role 'Member Server'
		(Get-ChecklistAsset -Path $cklTestPath.FullName).ROLE| Should -be 'Member Server'
	}

	It "Should set the Asset Type" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -AssetType 'Non-Computing'
		(Get-ChecklistAsset -Path $cklTestPath.FullName).ASSET_TYPE | Should -be 'Non-Computing'
	}

	It "Should set the Technology Area" {
		Set-ChecklistAsset -Path $cklTestPath.FullName -TechnologyArea 'Internal Network'
		(Get-ChecklistAsset -Path $cklTestPath.FullName).TECH_AREA | Should -be 'Internal Network'
	}

}
