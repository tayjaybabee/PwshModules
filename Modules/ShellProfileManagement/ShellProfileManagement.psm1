

function Update-Modules {
    <#
    .SYNOPSIS
        Reloads PowerShell modules from a specified path.

    .DESCRIPTION
        The Reload-Modules function reloads modules from a custom path. It is used to ensure that the most recent version of each module in the specified path is loaded into the current PowerShell session.

    .PARAMETER customModulePath
        The path from which to reload the modules. This should be the directory where the custom modules are stored.

    .EXAMPLE
        Reload-Modules -customModulePath "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
        This command reloads all modules from the specified custom module path.

    .NOTES
        This function is intended to be used as part of the Update-ShellProfile process to ensure that modules are kept up to date in the PowerShell session.
    #>

    [CmdletBinding()]
    param (

        [string]$customModulePath

    )

    $loadedModules = Get-Module -All | Where-Object { $_.Path -like "$customModulePath*" }

    foreach ($module in $loadedModules) {
        $modulePaths = Get-Module -Name $module -ListAvailable | Select-Object -ExpandProperty Path

        foreach ($modulePath in $modulePaths) {

            if ($modulePath -like "$customModulePath*") {
            
                Write-Verbose "Importing module from  path: $modulePath"
                Import-Module $modulePath -Force
                Write-Verbose "Module reloaded: $module"
            
            }

        }
    }
    Write-Host "Custom modules reloaded!" -ForegroundColor Green
}


function Compare-Modules{

    <#
    .SYNOPSIS
        Compares pre-reload and post-reload module lists to identify new and removed modules.

    .DESCRIPTION
        The Compare-Modules function takes two lists of module names, one from before and one from after a reload operation, and identifies which modules have been added or removed. This helps in understanding the changes made to the module environment of the PowerShell session.

    .PARAMETER oldModules
        An array of module names that were loaded before the reload operation.

    .PARAMETER newModules
        An array of module names that are loaded after the reload operation.

    .EXAMPLE
        $oldModules = Get-Module -All | Select-Object -ExpandProperty Name
        $newModules = Get-Module -All | Select-Object -ExpandProperty Name
        Compare-Modules -oldModules $oldModules -newModules $newModules
        This command compares the modules loaded before and after a reload to identify any changes.

    .NOTES
        This function is intended to be used in conjunction with the Update-ShellProfile function to provide insight into the changes in the module environment.
    #>
    [CmdletBinding()]
    param (
        [string[]]$oldModules,
        [string[]]$newModules
    )

    $addedModules = $newModules | Where-Object { $_ -notin $oldModules }
    $removedModules = $oldModules | Where-Object { $_ -notin $newModules }

    if ($addedModules) {
        Write-Host "New modules added to the shell:" -ForegroundColor Green
        $addedModules | ForEach-Object { Write-Host "  - $_" }
    } else {
        Write-Host "No new modules added." -ForegroundColor Yellow
    }

    if ($removedModules) {
        Write-Host "Modules removed from the shell:" -ForegroundColor Red
        $removedModules | ForEach-Object { Write-Host "  - $_" }
    } else {
        Write-Host "No modules removed." -ForegroundColor Yellow
    }
}


function Compare-Functions {
    <#
    .SYNOPSIS
        Compares the functions before and after the profile update to identify new and removed functions.

    .DESCRIPTION
        This function takes two arrays of function names, representing the state of the PowerShell session's functions before and after a profile reload or module update. It then identifies which functions have been added or removed.

    .PARAMETER OldFunctions
        An array of function names present before the profile or modules were reloaded.

    .PARAMETER NewFunctions
        An array of function names present after the profile or modules were reloaded.

    .EXAMPLE
        $oldFunctions = Get-Command -CommandType Function | Select-Object -ExpandProperty Name
        . $global:PROFILE
        $newFunctions = Get-Command -CommandType Function | Select-Object -ExpandProperty Name
        Compare-Functions -OldFunctions $oldFunctions -NewFunctions $newFunctions

        This example reloads the current PowerShell profile and then compares the list of functions before and after to see what has changed.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$OldFunctions,

        [string[]]$NewFunctions
    )
    if (-not $NewFunctions) {
        $NewFunctions = Get-Command -CommandType Function  | Select-Object -ExpandProperty Name
    }

    $addedFunctions = Compare-Object -ReferenceObject $OldFunctions -DifferenceObject $NewFunctions | Where-Object { $_.SideIndicator -eq "=>" } | Select-Object -ExpandProperty InputObject
    $removedFunctions = Compare-Object -ReferenceObject $OldFunctions -DifferenceObject $NewFunctions | Where-Object { $_.SideIndicator -eq "<=" } | Select-Object -ExpandProperty InputObject


    if ($addedFunctions) {
        Write-Host "New functions added to the shell:" -ForegroundColor Green
        $addedFunctions | ForEach-Object { Write-Host "  - $_" }
    } else {
        Write-Host "No new functions added." -ForegroundColor Yellow
    }

    if ($removedFunctions) {
        Write-Host "Functions removed from the shell:" -ForegroundColor Red
        $removedFunctions | ForEach-Object { Write-Host "  - $_" }
    } else {
        Write-Host "No functions removed." -ForegroundColor Yellow
    }
}



function Update-ShellProfile {
    <#
    .SYNOPSIS
        Updates and reloads the PowerShell profile and modules.

    .DESCRIPTION
        The Update-ShellProfile function reloads the PowerShell profile and all custom modules.
        It provides verbose output for the actions being taken, including the reloading of
        individual modules and the identification of new or removed modules.

    .PARAMETER h
        Displays help information for the function.

    .PARAMETER help
        Displays help information for the function.

    .EXAMPLE
        Update-ShellProfile
        Reloads the PowerShell profile and custom modules, displaying information about any changes.

    .EXAMPLE
        Update-ShellProfile -Verbose
        Reloads the PowerShell profile and custom modules with verbose output, providing detailed information about the process.

    .NOTES
        Ensure that the custom module paths are correctly set and accessible. This function is
        particularly useful for refreshing the PowerShell environment after adding or updating modules.
    #>

    [CmdletBinding()]
    param (
        [switch]$h,
        [switch]$help
    )

    if ($h -or $help) {
        Get-Help -Name $MyInvocation.MyCommand.Name -Detailed
    } else {
        Write-Host "Reloading profile..."
        $oldModules = Get-Module -All | Select-Object -ExpandProperty Name
        $oldFunctions = Get-Command -CommandType Function | Select-Object -ExpandProperty Name


        . $global:PROFILE
        Write-Verbose "PowerShell profile reloaded."

        $customModulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
        Update-Modules -customModulePath $customModulePath

        $newModules = Get-Module -All | Select-Object -ExpandProperty Name
        Compare-Modules -oldModules $oldModules -newModules $newModules

        $newFunctions = Get-Command -CommandType Function | Select-Object -ExpandProperty Name
        Compare-Functions -OldFunctions $oldFunctions -NewFunctions $newFunctions


        Write-Host "Shell profile updated!" -ForegroundColor Green
    }
}


function Edit-Profile {
    <#
    .SYNOPSIS
        Opens the user's PowerShell profile in Visual Studio Code.

    .DESCRIPTION
        This function opens the user's PowerShell profile script in Visual Studio Code,
        allowing for easy editing of custom settings, functions, or variables.

    .EXAMPLE
        Edit-Profile
        # Opens the PowerShell profile in Visual Studio Code.
    #>

    [CmdletBinding()]
    param (
        [switch]$h,
        [switch]$help
    )

    if ($h -or $help) {
        Show-HelpOfCaller -CallerFunction $MyInvocation.MyCommand.Name


    }
    else {

        # Open the profile in Visual Studio Code
        code $PROFILE
    }
}


function Set-EnvironmentVariable {
    [CmdletBinding()]
    param (

        [switch]$h,
        [switch]$help,

        [Parameter(Mandatory = $true)]
        [string]$name,

        [Parameter(Mandatory = $true)]
        [string]$value,

        [Parameter(Mandatory = $false)]
        [ValidateSet("User", "Machine")]
        [string]$scope = "User"
    )
    
    <#
    .SYNOPSIS
        Sets an environment variable.

    .DESCRIPTION
        This function sets an environment variable either for the current user or system-wide.

    .PARAMETER name
        The name of the environment variable to set.

    .PARAMETER value
        The value to assign to the environment variable.

    .PARAMETER scope
        The scope of the environment variable: 'User' for the current user, or 'Machine' for system-wide.

    .EXAMPLE
        Set-EnvironmentVariable -name "MY_VAR" -value "my value"
        Sets the environment variable 'MY_VAR' to 'my value' for the current user.

    .EXAMPLE
        Set-EnvironmentVariable -name "MY_VAR" -value "my value" -scope "Machine"
        Sets the environment variable 'MY_VAR' to 'my value' system-wide.
    #>

    # Produce help if asked
    if ($h -or $help) {
        Show-HelpOfCaller -CallerFunction $MyInvocation.MyCommand.Name

    }

    if ($scope -eq "User") {
        Set-Item "env:$name" $value
    }

    [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::$scope)

    Write-Host "Environment variable `'$name`' set to `'$value`' for `'$scope`' scope."
}



