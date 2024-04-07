function Add-Path {
    <#
    .SYNOPSIS
        Adds a new path to the system's PATH environment variable.

    .DESCRIPTION
        The Add-Path function appends a specified path to the system's PATH environment variable.
        If the path already exists in the PATH variable, it will not be added again to prevent duplicates.

    .PARAMETER Path
        The file system path to be added to the PATH environment variable.
        This path should be a valid directory path on the system.

    .EXAMPLE
        Add-Path -Path "C:\NewFolder\bin"
        This example adds "C:\NewFolder\bin" to the system's PATH environment variable.

    .EXAMPLE
        Add-Path "C:\AnotherFolder\scripts"
        Adds "C:\AnotherFolder\scripts" to the system's PATH environment variable using positional parameter binding.

    .NOTES
        Be cautious when modifying the PATH environment variable as it is a critical system setting.
        Running this function requires administrative privileges to modify the system PATH.

        It is recommended to backup your PATH environment variable before making changes.

    .COMPONENT
        PathManagement

    .LINK
        https://docs.microsoft.com/powershell/scripting/developer/cmdlet/about_functions_cmdletbindingattribute?view=powershell-7.1

    #>
    [CmdletBinding()]
    param (
        [string]$Path,
        [switch]$h,
        [switch]$help
    )

    if ($h -or $help) {
        # Display helo text
        Get-Help -Name $MyInvocation.MyCommand.Name -Full | Out-String | Write-Host
    }
    else {

        # Take note of the current value of the PATH variable.
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)

        # Check to see if the directory path is already present
        # in the PATH variable value.
        if (-not $currentPath.Split(';').Contains($Path)) {

            # ...if not, we add it
            $newPath = $currentPath + ';' + $Path
            [Environment]::SetEnvironmentVariable("PATH", $newPath. [EnvironmentVariableTarget]::Machine)
        }
        # ...otherwise we do nothing and just return.

    }
}


function Get-PathMembers {
    <#
    .SYNOPSIS
        Lists the members of the system's PATH environment variable.

    .DESCRIPTION
        The Get-PathMembers function retrieves and displays each path
        included in the system's PATH environment variable.
        It lists each path on a new line for better readability.

    .EXAMPLE
        Get-PathMembers
        Lists all the members of the system's PATH environment variable.

    .NOTES
        This function does not modify the PATH environment variable.
        It is a read-only operation and does not require administrative privileges.

    .COMPONENT
        PathManagement

    .LINK
        https://docs.microsoft.com/powershell/scripting/developer/cmdlet/about_functions_cmdletbindingattribute?view=powershell-7.1
    #>

    [CmdletBinding()]
    param ()

    # Retrieve the current value of the PATH variable.
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)

    # Split the PATH variable into individual paths and display them.
    $currentPath.Split(';') | ForEach-Object {
        Write-Output $_
    }
}

Write-Host 'Importing PathManagement functions...'

Export-ModuleMember -Function 'Add-Path', 'Get-PathMembers'
