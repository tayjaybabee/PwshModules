@{
    RootModule = 'NavigationPlus.psm1'
    ModuleVersion = '1.0.0'
    GUID = 'b66a1b81-6d0b-4c1e-a1c9-f8699824ed72'
    Author = 'Taylor-Jayde Blackstone'
    CompanyName = 'Inspyre-Softworks'
    Copyright = '© Inspyre-Softwoks. All rights reserved.'
    Description = 'This module enhances directory navigation in PowerShell, adding functionality to navigate to parent directories of files and easily toggle between the last and current directory.'
    PowerShellVersion = '5.0'
    FunctionsToExport = 'Set-EnhancedCD'
    AliasesToExport = 'cd'
    VariablesToExport = '*'
    CmdletsToExport = '*'
    NestedModules = @()
    PrivateData = @{
        PSData = @{
            Tags = @('Navigation', 'Filesystem', 'EnhancedCD')
            ProjectUri = 'URL to your project (if applicable)'
            LicenseUri = 'URL to your license (if applicable)'
            ReleaseNotes = 'Initial release'
        }
    }
}
