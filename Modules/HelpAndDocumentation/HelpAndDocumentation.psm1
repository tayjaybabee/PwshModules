
Export-ModuleMember -Function 'Show-HelpOfCaller'
function Show-HelpOfCaller {
    param (
        [string]$CallerFunction
    )

    <#
    .SYNOPSIS
    Shows the help information of the calling function.

    .DESCRIPTION
    This function accepts the name of the calling function and then fetches and displays its help information.

    .PARAMETER CallerFunction
    The name of the function for which to display help.

    .EXAMPLE
    function Test-Function {
        Show-HelpOfCaller -CallerFunction $MyInvocation.MyCommand.Name
    }

    Test-Function
    #>
    param (
        [string]$CallerFunction
    )

    $helpInfo = Get-Help -Name $CallerFunction | Out-String



    Write-Host $helpInfo
}
