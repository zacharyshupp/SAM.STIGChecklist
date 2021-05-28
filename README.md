# SAM.STIGChecklist

<!---[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/SAM.STIGChecklist?color=Green&logo=PowerShell&style=for-the-badge)](https://www.powershellgallery.com/packages/SAM.STIGChecklist)-->

[![Minimum Supported PowerShell Version](https://img.shields.io/static/v1?label=PSVersion&message=5.1%2B&color=Green&logo=PowerShell&style=for-the-badge)](https://github.com/PowerShell/PowerShell)

SAM.STIGChecklist is a PowerShell module to interact with DISA Security Technical Implementation Guide (STIG) Checklists.

Over the past couple of years, I have worked on several different DoD contracts. Each had custom methods for updating STIG Checklists, they were always custom to the network with no easy way to use at other locations. This module is my attempt at building a standard set of functions to allow users to automate updating STIG Checklists.

| Function                           | Description                         |
| ---------------------------------- | ----------------------------------- |
| [ConvertTo-NewChecklistVersion][0] | Convert Checklist to a new version. |
| [Export-Checklist][1]              | Export STIG Checklist to File       |
| [Get-ChecklistAsset][2]            | Get Checklist Asset Information     |
| [Get-ChecklistItem][3]             | Get Checklist item details          |
| [Get-ChecklistStatus][4]           | Get Status from a STIG Checklist    |
| [Import-Checklist][5]              | Import STIG Checklist               |
| [New-Checklist][6]                 | Create a New STIG Checklist         |
| [Set-ChecklistAsset][7]            | Sets Checklist Asset Information    |
| [Set-ChecklistItem][8]             | Set Checklist item details          |
|                                    |                                     |

## Installation

### Option A: Download from PowerShell Gallery

```PowerShell
Install-Module -Name SAM.STIGChecklist
```

### Option B: Manual Download from GitHub

1. Download the repository
2. Unblock Zip File before extracting
3. Extract the zip file to any directory
4. Run `.\build.ps1 -InstallDependencies -Task Build` (exists in project root)
5. `build.ps1` creates a folder called `~\BuildOutput\SAM.STIGChecklist` in the directory which `SAM.STIGChecklist` was saved to.
6. Run `Import-Module -Path "C:\Path\To\buildoutput\SAM.STIGChecklist"` to import module

## Example

The below is an example usage

```PowerShell

Import-Module ".\SAM.STIGChecklist" -force

$xccdfPath = ".\Tests\Mocks\U_MS_Windows_Server_2016_V2R2_STIG.zip"
$cklDestination = "E:\_Temp"
$cklName = "Windows_Server-2016.ckl"
$cklPath = Join-Path -Path $cklDestination -ChildPath $cklName

# Create Checklist
New-Checklist -Path $xccdfPath -Destination $cklDestination -ChecklistName $cklName -Force

# Import Checklist
$ckl = Import-Checklist -Path $cklPath

# Setting Asset information
Write-Host "Before Setting Asset Information" -ForegroundColor Green
$ckl.Checklist.CHECKLIST.ASSET

$params = @{
	Checklist = $ckl
	HostName = "Computer123"
	HostIP = "10.0.0.4"
	Comment = "This is a test"
	HostMAC = "00-15-5D-E8-33-9D"
	HostFQDN = "Computer123.FQDN.COM"
	Role = "Member Server"
	TechnologyArea = "Internal Network"
}

Set-ChecklistAsset @params

Write-Host "After Setting Asset Information" -ForegroundColor Red
$ckl.Checklist.CHECKLIST.ASSET

# Setting Checklist Items
Write-Host "Before Setting VulnID Information" -ForegroundColor Green

Get-ChecklistItem -Checklist $ckl -VulnID 'V-224820'

Set-ChecklistItem -Checklist $ckl -VulnID 'V-224820' -Details "This is a detail" -Comments "This is a Comment" -Status "NotAFinding"

Write-Host "After Setting VulnID Information" -ForegroundColor Red

Get-ChecklistItem -Checklist $ckl -VulnID 'V-224820'

# Export Checklist
Export-Checklist -Checklist $ckl


```

## Additional Items

[Contributing]("Docs\contributing.md")

## Resources

Below are links to useful resources.

- [Cyber.mil (Public Access)](https://public.cyber.mil)
- [Cyber.mil (CAC Required)](https://cyber.mil)

[0]: Docs\ModuleHelp\ConvertTo-NewChecklistVersion.md
[1]: Docs\ModuleHelp\Export-Checklist.md
[2]: Docs\ModuleHelp\Get-ChecklistAsset.md
[3]: Docs\ModuleHelp\Get-ChecklistItem.md
[4]: Docs\ModuleHelp\Get-ChecklistStatus.md
[5]: Docs\ModuleHelp\Import-Checklist.md
[6]: Docs\ModuleHelp\New-Checklist.md
[7]: Docs\ModuleHelp\Set-ChecklistAsset.md
[8]: Docs\ModuleHelp\Set-ChecklistItem.md
