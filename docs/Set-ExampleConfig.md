# Set-ExampleConfig

## Synopsis
Configures module settings and parameters.

## Description
This function demonstrates configuration management best practices in PowerShell modules. It allows setting various configuration parameters like API endpoints, timeouts, and other settings. Configuration settings are stored in the module scope and persist for the current session.

## Parameters

### ApiEndpoint
Specifies the API endpoint URL to use for external calls. Must be a valid HTTP or HTTPS URL.

- **Type**: String
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: None
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

### Timeout
Specifies the timeout value in seconds for API calls. Must be between 1 and 300 seconds. Default is 30 seconds.

- **Type**: Int32
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: 30
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

### RetryCount
Specifies the number of retry attempts for failed operations. Must be between 0 and 10. Default is 3.

- **Type**: Int32
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: 3
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

### EnableLogging
Specifies whether to enable detailed logging for the module operations.

- **Type**: SwitchParameter
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: False
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

### LogLevel
Specifies the logging level. Valid values are 'Error', 'Warning', 'Information', 'Verbose', or 'Debug'. Default is 'Information'.

- **Type**: String
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: Information
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

## Examples

### Example 1: Set API endpoint and timeout
```powershell
PS> Set-ExampleConfig -ApiEndpoint "https://api.example.com" -Timeout 60
```
Sets the API endpoint and timeout configuration.

### Example 2: Enable logging with debug level
```powershell
PS> Set-ExampleConfig -EnableLogging -LogLevel "Debug" -Verbose
```
Enables logging with debug level and verbose output.

### Example 3: Set retry count and timeout
```powershell
PS> Set-ExampleConfig -RetryCount 5 -Timeout 120
```
Sets retry count and timeout values.

### Example 4: View current configuration
```powershell
PS> Set-ExampleConfig
```
Returns the current configuration settings without making any changes.

### Example 5: Multiple parameters
```powershell
PS> Set-ExampleConfig -ApiEndpoint "https://api.production.com" -Timeout 90 -RetryCount 5 -EnableLogging -LogLevel "Warning"
```
Sets multiple configuration parameters in a single call.

## Outputs

### System.Management.Automation.PSCustomObject
Returns the current configuration settings after applying any changes.

## Notes
- Configuration settings are stored in the module scope and persist for the current session.
- The function supports ShouldProcess for testing scenarios with -WhatIf parameter.
- Parameter validation ensures that only valid values are accepted.
- Changes are logged with verbose and information output streams.

## Related Links
- [Get-ExampleData](Get-ExampleData.md)
- [PowerShell Configuration Management](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables)