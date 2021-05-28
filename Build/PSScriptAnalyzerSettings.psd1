@{
    Severity            = @('Error', 'Warning')
    CustomRulePath      = @()
    Rules               = @{
        PSUseCompatibleCommands = @{
            Enable         = $true
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework'
            )
        }
        PSUseCompatibleSyntax   = @{
            Enable         = $true
            TargetVersions = @(
                '3.0',
                '4.0',
                '5.1'
            )
        }
    }
}
