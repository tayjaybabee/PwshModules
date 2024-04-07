function Set-EnhancedCD {
    param([string]$Path)

    # Store the current directory to go back if `-` is entered
    $Global:LastDirectory = Get-Location

    # Handle 'cd -' to go to the last directory
    if ($Path -eq '-') {
        Set-Location $Global:LastDirectory
    }
    else {
        # Check if the path is a file or directory before navigating
        if (Test-Path $Path) {
            # If it's a file, navigate to its directory
            if (Test-Path $Path -PathType Leaf) {
                Set-Location (Get-Item $Path).DirectoryName
            }
            else {
                # If it's a directory, navigate to it
                Set-Location $Path
            }
        }
        else {
            Write-Error "Path '$Path' does not exist."
        }
    }
}


# Alias the 'cd' command to the new function
Set-Alias cd Set-EnhancedCD
