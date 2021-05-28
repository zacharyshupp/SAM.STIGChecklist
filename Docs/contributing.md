# Contributing

Contributions are welcome via pull requests and issues. Before submitting a pull request, please make sure all tests pass.

## Environment Configuration

``` PowerShell
# First time execution
# Install requirements and Run the build task
./build.ps1 -InstallDependencies -Task Build

# Create New Public Function with a Pester Test.
.\build.ps1 -Task NewFunction -Function "<FunctionName>"

# Running the build task
./build.ps1 -task build

# Running the Test task
./build.ps1 -task Test

# Running the script analyzer task
./build.ps1 -task analyze
```

## Guidelines

This project follows The PowerShell Best Practices and Style Guide by [PoshCode][0]. The below list are some of the items to watch out for.

- All Functions must support PowerShell 5.1 and PowerShell 7.X
- Do not use Write-Host
- Use Verb-Noun format, Check Get-Verb for approved verb
- Always use explicit parameter names, don't assume position
- Don't use Aliases
- Should support Credential input if the command can run under different credentials
- If you want to show informational information use Write-Verbose
- You need to have Error Handling
- Implement appropriate WhatIf/Confirm support if you function is changing something

## Versioning

This project uses [Semantic Versioning][2]. To keep up with the versioning, [GitVersion][3] is used to read commit messages and provide updated versions. This makes it so the versioning is standard weather the project is manually built or built using a pipeline.

## Conventional Commit Messages

The Conventional Commits specification is a lightweight convention on top of commit messages. It provides an easy set of rules for creating an explicit commit history; which makes it easier to write automated tools on top of. This convention dovetails with SemVer, by describing the features, fixes, and breaking changes made in commit messages.

[![conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-green.svg)](https://www.conventionalcommits.org/en/v1.0.0/)

The below table covers the types to use with this project. These types are also used with GitVersion to trigger when the version should be updated.

|   Type   | Description                                                                                            | Version Bump |
| :------: | ------------------------------------------------------------------------------------------------------ | :----------: |
|  build   | Changes that affect the build system or external dependencies                                          |    Patch     |
|    ci    | Changes to our CI configuration files and scripts                                                      |    Patch     |
|   docs   | Documentation only changes                                                                             |    Patch     |
|   feat   | A new feature                                                                                          |    Minor     |
|   fix    | A bug fix                                                                                              |    Patch     |
|   perf   | A code change that improves performance                                                                |    Patch     |
| refactor | A code change that neither fixes a bug nor adds a feature                                              |    Patch     |
|  style   | Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc) |    Patch     |
|   test   | Adding missing tests or correcting existing tests                                                      |    Patch     |
|          |                                                                                                        |              |

Any Commit messages that contain 'BREAKING CHANGE:' will trigger a major version update.

[0]: https://github.com/PoshCode/PowerShellPracticeAndStyle
[1]: https://nvie.com/posts/a-successful-git-branching-model
[2]: https://semver.org/
[3]: https://gitversion.net/
