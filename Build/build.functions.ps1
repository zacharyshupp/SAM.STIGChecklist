
function Get-CommitsSinceLastTag {

	[CmdletBinding()]
	param (

		# Specify the path to the Git Repository
		[Parameter()]
		[String]
		$Path

	)

	$commitTypes = @(
		@{
			Name  = 'Breaking Changes'
			Regex = 'BREAKING CHANGE:'
		}
		@{
			Name  = 'New Features'
			Regex = '^feat:'
		}
		@{
			Name  = 'Minor Updates and Bug Fixes'
			Regex = '^(fix|refactor|perf|security|style|deps):'
		}
		@{
			Name  = 'Documentation Updates'
			Regex = 'docs:'
		}
	)

	try {

		Push-Location -StackName GetMessagesSinceLastTag -Path $Path

		$currentCommitTag = try { git describe --exact-match --tags 2>$null } catch {}
		$lastVersionTag = git tag --list 'v*' --sort="version:refname" --merged | Where-Object { $PSItem -ne $currentCommitTag } | Select-Object -Last 1

		if (-not $lastVersionTag) { $lastVersionTag = '--all' }

		$lastVersionCommit = & git rev-list -n 1 $lastVersionTag

		$gitLogResult = (git log --pretty=format:"|||%h||%s" "$lastVersionCommit..") -join "`n"

		$gitLogResult.Split('|||').where{ $PSItem }.foreach{

			$logItem = $PSItem.Split('||')

			foreach ($commitTypeItem in $commitTypes) {


				if ($($logItem[1]) -match $commitTypeItem.Regex) {
					$commitType = $commitTypeItem.Name
					break
				}
				#Last Resort
				$commitType = 'Other'
			}

			[PSCustomObject]@{
				CommitId   = $logItem[0]
				Message    = $(if($logItem[1].length -gt 1){$logItem[1].trim()})
				CommitType = $commitType
			}

		}

	}
 catch {

		throw

	}
 finally {

		Pop-Location -StackName GetMessagesSinceLastTag

	}

}
function New-ReleaseNotes {

	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[System.Object]
		$InputObject,

		[Parameter()]
		$Version,

		[Parameter()]
		[Switch]
		$Release
	)

	begin {

		$sortOrder = 'Breaking Changes', 'New Features', 'Minor Updates and Bug Fixes', 'Documentation Updates'
		$markdown = [Text.StringBuilder]::new()
		$currentDate = Get-Date -Format 'yyyy-MM-dd'

		if ($Release) {
			$baseHeader = "[$Version] - $currentDate"
		}
		else {

			#Top header
			$baseHeader = if ($Version) {
				"## [Unreleased] ($Version) - $currentDate"
			}
			else {
				'## [Unreleased]'
			}

		}

		[void]$markdown.AppendLine($baseHeader)

	}

	end {

		# Sort by our custom sort order. Anything that doesn't match moves to the end
		$messageGroups = $input | Group-Object CommitType | Sort-Object {
			$index = $sortOrder.IndexOf($PSItem.Name)
			if ($index -eq -1) { $index = [int]::MaxValue }
			$index
		}

		foreach ($messageGroupItem in $messageGroups) {

			# Header First
			[void]$markdown.AppendLine("### $($messageGroupItem.Name)")

			# Then the issue lines
			$messageGroupItem.Group.Message.foreach{
				# Multiline List format, removing extra newlines
				[String]$ListBody = ($PSItem -split "`n").where{ $PSItem } -join "  `n    "
				[String]$ChangeItem = '- ' + $ListBody
				[void]$markdown.AppendLine($ChangeItem)
			}

			[Void]$markdown.AppendLine()

		}

		return ([String]$markdown).trim()

	}

}
