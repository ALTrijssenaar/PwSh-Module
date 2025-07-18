@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PwSh-Module.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID = 'a1b2c3d4-e5f6-7890-1234-567890abcdef'

    # Author of this module
    Author = 'ALTrijssenaar'

    # Company or vendor of this module
    CompanyName = 'Example Company'

    # Copyright statement for this module
    Copyright = '(c) 2024 ALTrijssenaar. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'PowerShell Module Best Practices Example - A comprehensive example and reference implementation of PowerShell module development best practices.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Get-ExampleData', 'Set-ExampleConfig')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('PowerShell', 'Module', 'BestPractices', 'Example', 'Reference', 'Template')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/ALTrijssenaar/PwSh-Module/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/ALTrijssenaar/PwSh-Module'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'Initial release with comprehensive PowerShell module best practices example.'

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        } # End of PSData hashtable
    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}