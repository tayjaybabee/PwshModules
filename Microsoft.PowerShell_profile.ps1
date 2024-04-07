Write-Host "Profile loading..."

# $global:ProfileDebugMode = $false

Import-Module C:\Users\tayja\Documents\WindowsPowerShell\Modules\ShellProfileManagement\ShellProfileManagement.psd1
Import-Module C:\Users\tayja\Documents\WindowsPowerShell\Modules\DirectoryManagement\DirectoryManagement.psd1
Import-Module C:\Users\tayja\Documents\WindowsPowerShell\Modules\SystemConfiguration\SystemConfiguration.psd1
Import-Module C:\Users\tayja\Documents\WindowsPowerShell\Modules\HelpAndDocumentation\HelpAndDocumentation.psd1
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $Env:_AUTODOC2_COMPLETE = "complete_powershell"
    $Env:_TYPER_COMPLETE_ARGS = $commandAst.ToString()
    $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = $wordToComplete
    autodoc2 | ForEach-Object {
        $commandArray = $_ -Split ":::"
        $command = $commandArray[0]
        $helpString = $commandArray[1]
        [System.Management.Automation.CompletionResult]::new(
            $command, $command, 'ParameterValue', $helpString)
    }
    $Env:_AUTODOC2_COMPLETE = ""
    $Env:_TYPER_COMPLETE_ARGS = ""
    $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = ""
}
Register-ArgumentCompleter -Native -CommandName autodoc2 -ScriptBlock $scriptblock
