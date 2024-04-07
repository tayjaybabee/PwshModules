# MenuModule.psm1
Write-Host "Loading MenuModule"

function Show-Menu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Options,

        [Parameter(Mandatory=$true)]
        [scriptblock[]]$Actions
    )

    if ($Options.Length -ne $Actions.Length) {
        Write-Error "The number of options must match the number of actions."
        return
    }

    $selected = 0

    while ($true) {
        Clear-Host

        Write-Host "Menu`n"

        for ($i = 0; $i -lt $Options.Length; $i++) {
            if ($i -eq $selected) {
                Write-Host ("-->" + $Options[$i])
            } else {
                Write-Host ("   " + $Options[$i])
            }
        }

        $keyInfo = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($keyInfo.VirtualKeyCode) {
            38 { if ($selected -gt 0) { $selected-- } }  # Up arrow
            40 { if ($selected -lt $Options.Length - 1) { $selected++ } }  # Down arrow
            13 {  # Enter key
                & $Actions[$selected].Invoke()
                Read-Host "Press Enter to continue..."
            }
        }
    }
}


Write-Host 'MenuModule loaded...'
Write-Host 'Exporting MenuMod...'

Export-ModuleMember -Function 'Show-Menu'

Write-Host 'Exported MenuMod'
