@{
    ModuleVersion     = '1.0.0'
    GUID              = '0353f222363ffc8aee7a9c2bad731545'
    Author            = 'Taylor-Jayde Blackstone'
    CompanyName       = 'Inspyre Softworks'
    Copyright         = 'Copyright (c) Inspyre Softworks ShellProfileManagement'
    Description       = 'Tools for managing your shell profile.'
    PowerShellVersion = '5.0'
    RootModule        = 'ShellProfileManagement.psm1'
    FunctionsToExport = @(

        'Edit-Profile',
        'Set-EnvironmentVariable',
        'Update-ShellProfile'

    
    )
    VariablesToExport = '*'
    AliasesToExport   = '*'
    CmdletsToExport   = '*'
    NestedModules     = @(
        '.\PathManagement\PathManagement.psm1'
    )
    PrivateData       = @{
        PSData = @{
            Tags = @('Tag1', 'Tag2')
        }
    }
}
