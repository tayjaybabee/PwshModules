function Get-SshKnownHosts {
    <#
    .SYNOPSIS
        Lists entries from the SSH known hosts file in a table format.

    .DESCRIPTION
        The Get-SshKnownHosts function reads entries from the SSH known hosts file,
        presenting them in a table format for better readability.
        By default, it reads from the user's .ssh directory, but a custom path can be specified.

    .PARAMETER Path
        The path to the SSH known hosts file. If not specified, the function uses the default path.

    .PARAMETER SearchHost
        An optional parameter to search for a specific host in the known hosts file.

    .PARAMETER h
        Displays the help information for this function.

    .PARAMETER help
        Displays the help information for this function.

    .EXAMPLE
        Get-SshKnownHosts
        Lists all entries from the known hosts file in a table format.

    .EXAMPLE
        Get-SshKnownHosts -Path "C:\CustomPath\known_hosts"
        Lists entries from the specified known hosts file in a table format.

    .EXAMPLE
        Get-SshKnownHosts -SearchHost "github.com"
        Searches and lists entries for "github.com" in the known hosts file in a table format.

    .EXAMPLE
        Get-SshKnownHosts -h
        Displays the help information for the function.
    #>
    [CmdletBinding()]
    param (
        [string]$Path = (Join-Path $env:USERPROFILE ".ssh\known_hosts"),
        [string]$SearchHost,
        [switch]$h,
        [switch]$help
    )

    if ($h -or $help) {
        # Display help information
        Get-Help -Name $MyInvocation.MyCommand.Name -Full | Out-String | Write-Host
    }
    else {
        if (Test-Path -Path $Path) {
            # Process each line in the known_hosts file
            Get-Content -Path $Path | Where-Object { $_ -match $SearchHost } | ForEach-Object {
                # Split line into components
                $components = $_ -split ' '
                # Create a custom object with Host, KeyType, and a truncated Key
                [PSCustomObject]@{
                    Host    = $components[0]
                    KeyType = $components[1]
                    Key     = $components[2].Substring(0, [Math]::Min(40, $components[2].Length)) + "..."
                }
            } | Format-Table -AutoSize
        }
        else {
            Write-Warning "SSH known hosts file not found at path: $Path"
        }
    }
}

function Remove-SshKnownHost {
    <#
    .SYNOPSIS
        Removes a specified entry from the SSH known hosts file.

    .DESCRIPTION
        The Remove-SshKnownHost function removes an entry for a specified host from the SSH known hosts file.
        By default, it modifies the user's .ssh known_hosts file, but a custom path can be specified.

    .PARAMETER Path
        The path to the SSH known hosts file. If not specified, the function uses the default path.

    .PARAMETER HostName
        The name of the host to remove from the known hosts file.

    .PARAMETER h
        Displays the help information for this function.

    .PARAMETER help
        Displays the help information for this function.

    .EXAMPLE
        Remove-SshKnownHost -HostName "github.com"
        Removes the entry for "github.com" from the default known hosts file.

    .EXAMPLE
        Remove-SshKnownHost -HostName "github.com" -Path "C:\CustomPath\known_hosts"
        Removes the entry for "github.com" from the specified known hosts file.
    #>
    [CmdletBinding()]
    param (
        [string]$Path = (Join-Path $env:USERPROFILE ".ssh\known_hosts"),
        [string]$HostName,
        [switch]$h,
        [switch]$help
    )

    if ($h -or $help) {
        # Display help information
        Get-Help -Name $MyInvocation.MyCommand.Name -Full | Out-String | Write-Host
    }
    else {
        # Check if the known_hosts file exists
        if (Test-Path -Path $Path) {
            # Read the contents of the known_hosts file and exclude the specified host
            $updatedContent = Get-Content -Path $Path | Where-Object { $_ -notmatch $HostName }

            # Write the updated content back to the known_hosts file
            $updatedContent | Set-Content -Path $Path
            Write-Host "Host '$HostName' removed from known hosts."
        }
        else {
            Write-Warning "SSH known hosts file not found at path: $Path"
        }
    }
}


Write-Host 'Importing SSH Configuration tools...'

Export-ModuleMember -Function 'Get-SshKnownHosts', 'Remove-SshKnownHost'
