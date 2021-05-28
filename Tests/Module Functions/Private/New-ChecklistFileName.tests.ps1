BeforeAll {

	$projectRoot = $env:SAMProjectPath
	$moduleName = $env:SAMProjectName
	$fctName = "New-ChecklistFileName"

	$fctPath = [IO.Path]::Combine("$projectRoot", $moduleName, 'Private', "$fctName`.ps1")

	. $fctPath

}

Describe "New-ChecklistFileName (Private Function)" {

	It "Should Create a file name with just the HostName" {
		$cklName = New-ChecklistFileName -ChecklistName "U_MS_DotNet_Framework_4-0_V2R1_STIG" -HostName "Computer1"
		$cklName | Should -Be "Computer1-U_MS_DotNet_Framework_4-0_V2R1_STIG.ckl"
	}

	It "Should Create a file name with just the HostName and a Website" {
		$cklName = New-ChecklistFileName -ChecklistName "U_MS_IIS_10-0_Site_STIG_V2R2" -HostName "Computer1" -WebSite "Default"
		$cklName | Should -Be "Computer1-Default-U_MS_IIS_10-0_Site_STIG_V2R2.ckl"
	}

	It "Should Create a file name with just the HostName and a Database" {
		$cklName = New-ChecklistFileName -ChecklistName "U_MS_SQL_Server_2016_Database_STIG_V2R1" -HostName "Computer1" -Database "DB01"
		$cklName | Should -Be "Computer1-DB01-U_MS_SQL_Server_2016_Database_STIG_V2R1.ckl"
	}

	It "Should Create a file name with just the HostName and a Database Instance" {
		$cklName = New-ChecklistFileName -ChecklistName "U_MS_SQL_Server_2016_Instance_STIG_V2R3" -HostName "Computer1" -DatabaseInstance 'MSSQLSERVER'
		$cklName | Should -Be "Computer1-MSSQLSERVER-U_MS_SQL_Server_2016_Instance_STIG_V2R3.ckl"
	}

	It "Should throw and error when a DatabaseInstance and Database are provided" {
		{ New-ChecklistFileName -ChecklistName "U_MS_SQL_Server_2016_Instance_STIG_V2R3" -HostName "Computer1" -DatabaseInstance 'MSSQLSERVER' -Database "DB01" } | Should -Throw
	}

}
