BeforeDiscovery {

	$moduleName = $env:SAMProjectName
	$projectRoot = $env:SAMProjectPath

	$prjBuildOutputPath = Join-Path -Path $projectRoot -ChildPath "BuildOutput"

	$mdlPath = Join-Path -Path $prjBuildOutputPath -ChildPath $moduleName

	Import-Module -Name $mdlPath -Verbose:$false -ErrorAction Stop

	$params = @{
        Module      = (Get-Module $env:SAMProjectName)
        CommandType = [System.Management.Automation.CommandTypes[]]'Cmdlet, Function' # Not alias
    }

    if ($PSVersionTable.PSVersion.Major -lt 6) {$params.CommandType[0] += 'Workflow'}

    $commands = Get-Command @params

}

Describe "Test help for <_.Name>" -ForEach $commands {

	BeforeDiscovery {
		function FilterOutCommonParams {
			param ($Params)
			$commonParams = @(
				'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
				'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction',
				'WarningVariable', 'Confirm', 'Whatif'
			)
			$params | Where-Object { $_.Name -notin $commonParams } | Sort-Object -Property Name -Unique
		}

        # Get command help, parameters, and links
        $command               = $_
        $commandHelp           = Get-Help $command.Name -ErrorAction SilentlyContinue
        $commandParameters     = FilterOutCommonParams -Params $command.ParameterSets.Parameters
        $commandParameterNames = $commandParameters.Name
        $helpLinks             = $commandHelp.relatedLinks.navigationLink.uri
    }

    BeforeAll {

		function FilterOutCommonParams {
			param ($Params)
			$commonParams = @(
				'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
				'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction',
				'WarningVariable', 'Confirm', 'Whatif'
			)
			$params | Where-Object { $_.Name -notin $commonParams } | Sort-Object -Property Name -Unique
		}

        # These vars are needed in both discovery and test phases so we need to duplicate them here
        $command                = $_
        $commandName            = $_.Name
        $commandHelp            = Get-Help $command.Name -ErrorAction SilentlyContinue
        $commandParameters      = FilterOutCommonParams -Params $command.ParameterSets.Parameters
        $commandParameterNames  = $commandParameters.Name
        $helpParameters         = FilterOutCommonParams -Params $commandHelp.Parameters.Parameter
        $helpParameterNames     = $helpParameters.Name
    }

	    # If help is not found, synopsis in auto-generated help is the syntax diagram
		It 'Help is not auto-generated' {
			$commandHelp.Synopsis | Should -Not -BeLike '*`[`<CommonParameters`>`]*'
		}

		# Should be a description for every function
		It "Has description" {
			$commandHelp.Description | Should -Not -BeNullOrEmpty
		}

		# Should be at least one example
		It "Has example code" {
			($commandHelp.Examples.Example | Select-Object -First 1).Code | Should -Not -BeNullOrEmpty
		}

		# Should be at least one example description
		It "Has example help" {
			($commandHelp.Examples.Example.Remarks | Select-Object -First 1).Text | Should -Not -BeNullOrEmpty
		}

		It "Help link <_> is valid" -ForEach $helpLinks {
			(Invoke-WebRequest -Uri $_ -UseBasicParsing).StatusCode | Should -Be '200'
		}

		Context "Parameter <_.Name>" -Foreach $commandParameters {

			BeforeAll {
				$parameter         = $_
				$parameterName     = $parameter.Name
				$parameterHelp     = $commandHelp.parameters.parameter | Where-Object Name -eq $parameterName
				$parameterHelpType = if ($parameterHelp.ParameterValue) { $parameterHelp.ParameterValue.Trim() }
			}

			# Should be a description for every parameter
			It "Has description" {
				$parameterHelp.Description.Text | Should -Not -BeNullOrEmpty
			}

			# Required value in Help should match IsMandatory property of parameter
			It "Has correct [mandatory] value" {
				$codeMandatory = $_.IsMandatory.toString()
				$parameterHelp.Required | Should -Be $codeMandatory
			}

			# Parameter type in help should match code
			It "Has correct parameter type" {
				$parameterHelpType | Should -Be $parameter.ParameterType.Name
			}
		}

		Context "Test <_> help parameter help for <commandName>" -Foreach $helpParameterNames {

			# Shouldn't find extra parameters in help.
			It "finds help parameter in code: <_>" {
				$_ -in $parameterNames | Should -Be $true
			}
		}


}
