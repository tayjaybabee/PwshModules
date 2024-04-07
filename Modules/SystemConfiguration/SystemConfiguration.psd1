@{
    ModuleVersion     = '1.0.0'
    GUID              = 'fce8dad6471bb9c17458413d50802c9c'
    Author            = 'Taylor-Jayde Blackstone'
    CompanyName       = 'Inspyre Softworks'
    Copyright         = 'Copyright (c) Inspyre Softworks SystemConfiguration'
    Description       = 'Holds Cmdlets and Aliases for managing system config items.'
    PowerShellVersion = '5.0'
    RootModule        = 'SystemConfiguration.psm1'
    FunctionsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport   = '*'
    CmdletsToExport   = '*'
    NestedModules     = @(
        './SSHConfiguration/SSHConfiguration.psm1'
    )
    PrivateData       = @{
        PSData = @{
            Tags = @('Tag1', 'Tag2')
        }
    }
}
