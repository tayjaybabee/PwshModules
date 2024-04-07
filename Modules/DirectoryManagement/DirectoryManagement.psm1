function Set-Location {
    <#
    .SYNOPSIS
        Overrides the built-in Set-Location (cd) command in PowerShell.

    .DESCRIPTION
        Enhances the Set-Location command to handle file paths and navigate to their parent directories,
        and allows using 'cd -' to return to the previous directory.

    .EXAMPLE
        Set-Location C:\Path\ToFile.txt
        # Navigates to C:\Path.

    .EXAMPLE
        Set-Location -
        # Navigates to the last directory.

    .EXAMPLE
        Set-Location C:\SomeFolder
        # Navigates to C:\SomeFolder.
    #>
    param (
        [string]$path
    )

    # Navigate back to the previous directory
    if ($path -eq '-') {
        $prevDir = $dirStack.PopDirectory()
        if ($null -ne $prevDir) {
            $dirstack.PushDirectory((Get-Location).Path)
            Microsoft.PowerShell.Management\Set-Location -Path $prevDir
        }
        return
    }

    # Default to user's home directory if no path is provided
    if (-Not $path) {
        $path = [System.Environment]::GetFolderPath('UserProfile')
    }

    # Check if the path is a file and get its directory if so
    if (Test-Path -Path $path -PathType Leaf) {
        $path = Split-Path -Path $path
    }

    # Push the current directory onto the stack before changing directories
    $dirStack.PushDirectory((Get-Location).Path)

    # Perform the actual directory change
    Microsoft.PowerShell.Management\Set-Location -Path $path
}


function touch {
    <#
    .SYNOPSIS
        Creates a new file in the specified location.

    .DESCRIPTION
        Creates a new file in the specified location. If the file already exists, it updates the last modified timestamp.

    .EXAMPLE
        touch C:\Path\To\File.txt
        # Creates a new file named File.txt in the specified directory.

    .EXAMPLE
        touch C:\Path\To\ExistingFile.txt
        # Updates the last modified timestamp of the existing file.
    #>
    param (
        [string]$Path
    )

    if (-Not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType File
    }
    else {
        (Get-Item -Path $Path).LastWriteTime = Get-Date
    }

}


function cd {
    param (
        [string]$path
    )

    # Change to the new directory
    Set-Location $path
}

# Define a class to manage the directory stack
class DirectoryStack {
    # Initialize the stack
    [System.Collections.Stack]$stack = @()

    # Method to push a directory onto the stack
    [void] PushDirectory([string]$dir) {
        $this.stack.Push($dir)
    }

    # Method to pop a directory from the stack and navigate to it
    [string] PopDirectory() {
        if ($this.stack.Count -eq 0) {
            Write-Host "No previous directory to navigate to."
            return $null
        }
        return $this.stack.Pop()
    }
}

# Instantiate the DirectoryStack object
$dirStack = [DirectoryStack]::new()


function ls {
    <#
    .SYNOPSIS
        Mimics the 'ls' command from Unix/Linux in PowerShell.

    .DESCRIPTION
        Lists directory contents and displays detailed file and directory information, similar to the 'ls' command in Unix/Linux.

    .EXAMPLE
        ls
        # Lists the contents of the current directory.

    .EXAMPLE
        ls C:\Path\To\Directory
        # Lists the contents of the specified directory.

    .EXAMPLE
        ls -la
        # Lists all files and directories, including hidden ones, with detailed information.
    #>
    param (
        [string]$Path = ".",
        [switch]$LongFormat,
        [switch]$All
    )

    $parameters = @{
        Path  = $Path
        Force = $All.IsPresent
    }

    $items = Get-ChildItem @parameters

    if ($LongFormat) {
        $items | Format-Table -Property Mode, LastWriteTime, Length, Name -AutoSize
    }
    else {
        $items | ForEach-Object { $_.Name }
    }
}

Export-ModuleMember -Function 'Set-Location', 'cd', 'DirectoryStack', 'touch'
