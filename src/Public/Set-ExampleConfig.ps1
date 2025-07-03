function Set-ExampleConfig {
    <#
    .SYNOPSIS
        Configures module settings and parameters.

    .DESCRIPTION
        This function demonstrates configuration management best practices in PowerShell modules.
        It allows setting various configuration parameters like API endpoints, timeouts, and other settings.

    .PARAMETER ApiEndpoint
        Specifies the API endpoint URL to use for external calls.

    .PARAMETER Timeout
        Specifies the timeout value in seconds for API calls. Must be between 1 and 300 seconds.
        Default is 30 seconds.

    .PARAMETER RetryCount
        Specifies the number of retry attempts for failed operations. Must be between 0 and 10.
        Default is 3.

    .PARAMETER EnableLogging
        Specifies whether to enable detailed logging for the module operations.

    .PARAMETER LogLevel
        Specifies the logging level. Valid values are 'Error', 'Warning', 'Information', 'Verbose', or 'Debug'.
        Default is 'Information'.

    .EXAMPLE
        PS> Set-ExampleConfig -ApiEndpoint "https://api.example.com" -Timeout 60
        Sets the API endpoint and timeout configuration.

    .EXAMPLE
        PS> Set-ExampleConfig -EnableLogging -LogLevel "Debug" -Verbose
        Enables logging with debug level and verbose output.

    .EXAMPLE
        PS> Set-ExampleConfig -RetryCount 5 -Timeout 120
        Sets retry count and timeout values.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Returns the current configuration settings.

    .NOTES
        Configuration settings are stored in the module scope and persist for the current session.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param(
        [Parameter()]
        [ValidateScript({
            if ($_ -match '^https?://') {
                $true
            } else {
                throw "ApiEndpoint must be a valid HTTP or HTTPS URL."
            }
        })]
        [string]$ApiEndpoint,

        [Parameter()]
        [ValidateRange(1, 300)]
        [int]$Timeout = 30,

        [Parameter()]
        [ValidateRange(0, 10)]
        [int]$RetryCount = 3,

        [Parameter()]
        [switch]$EnableLogging,

        [Parameter()]
        [ValidateSet('Error', 'Warning', 'Information', 'Verbose', 'Debug')]
        [string]$LogLevel = 'Information'
    )

    begin {
        Write-Verbose "Starting Set-ExampleConfig"
        
        # Initialize module configuration if it doesn't exist
        if (-not $Global:PwShModuleConfig) {
            $Global:PwShModuleConfig = @{
                ApiEndpoint = $null
                Timeout = 30
                RetryCount = 3
                EnableLogging = $false
                LogLevel = 'Information'
                LastUpdated = $null
            }
        }
    }

    process {
        try {
            $ConfigChanged = $false
            $Changes = @()

            # Update ApiEndpoint if provided
            if ($PSBoundParameters.ContainsKey('ApiEndpoint')) {
                if ($PSCmdlet.ShouldProcess("Module Configuration", "Set ApiEndpoint to $ApiEndpoint")) {
                    $Global:PwShModuleConfig.ApiEndpoint = $ApiEndpoint
                    $Changes += "ApiEndpoint: $ApiEndpoint"
                    $ConfigChanged = $true
                    Write-Verbose "ApiEndpoint set to: $ApiEndpoint"
                }
            }

            # Update Timeout
            if ($PSBoundParameters.ContainsKey('Timeout')) {
                if ($PSCmdlet.ShouldProcess("Module Configuration", "Set Timeout to $Timeout seconds")) {
                    $Global:PwShModuleConfig.Timeout = $Timeout
                    $Changes += "Timeout: $Timeout seconds"
                    $ConfigChanged = $true
                    Write-Verbose "Timeout set to: $Timeout seconds"
                }
            }

            # Update RetryCount
            if ($PSBoundParameters.ContainsKey('RetryCount')) {
                if ($PSCmdlet.ShouldProcess("Module Configuration", "Set RetryCount to $RetryCount")) {
                    $Global:PwShModuleConfig.RetryCount = $RetryCount
                    $Changes += "RetryCount: $RetryCount"
                    $ConfigChanged = $true
                    Write-Verbose "RetryCount set to: $RetryCount"
                }
            }

            # Update EnableLogging
            if ($PSBoundParameters.ContainsKey('EnableLogging')) {
                if ($PSCmdlet.ShouldProcess("Module Configuration", "Set EnableLogging to $EnableLogging")) {
                    $Global:PwShModuleConfig.EnableLogging = $EnableLogging.IsPresent
                    $Changes += "EnableLogging: $($EnableLogging.IsPresent)"
                    $ConfigChanged = $true
                    Write-Verbose "EnableLogging set to: $($EnableLogging.IsPresent)"
                }
            }

            # Update LogLevel
            if ($PSBoundParameters.ContainsKey('LogLevel')) {
                if ($PSCmdlet.ShouldProcess("Module Configuration", "Set LogLevel to $LogLevel")) {
                    $Global:PwShModuleConfig.LogLevel = $LogLevel
                    $Changes += "LogLevel: $LogLevel"
                    $ConfigChanged = $true
                    Write-Verbose "LogLevel set to: $LogLevel"
                }
            }

            # Update LastUpdated timestamp if any changes were made
            if ($ConfigChanged) {
                $Global:PwShModuleConfig.LastUpdated = Get-Date
                Write-Information "Configuration updated: $($Changes -join ', ')" -InformationAction Continue
            }

            # Return current configuration
            return [PSCustomObject]@{
                ApiEndpoint = $Global:PwShModuleConfig.ApiEndpoint
                Timeout = $Global:PwShModuleConfig.Timeout
                RetryCount = $Global:PwShModuleConfig.RetryCount
                EnableLogging = $Global:PwShModuleConfig.EnableLogging
                LogLevel = $Global:PwShModuleConfig.LogLevel
                LastUpdated = $Global:PwShModuleConfig.LastUpdated
            }
        }
        catch {
            $ErrorMessage = "Failed to set configuration: $($_.Exception.Message)"
            Write-Error $ErrorMessage
            throw
        }
    }
}