# Get-ExampleData

## Synopsis
Retrieves example data with optional filtering.

## Description
This function demonstrates best practices for PowerShell function documentation, parameter validation, and pipeline support. It returns example data objects that can be filtered and limited based on the provided parameters.

## Parameters

### Filter
Specifies the filter to apply to the data. Valid values are 'Active', 'Inactive', or 'All'. Default is 'All'.

- **Type**: String
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: All
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

### Limit
Specifies the maximum number of records to return. Must be between 1 and 1000. Default is 100.

- **Type**: Int32
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: 100
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

### InputObject
Specifies input objects to process. Supports pipeline input.

- **Type**: String[]
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: None
- **Accept Pipeline Input**: True (ByValue)
- **Accept Wildcard Characters**: False

### ProcessAsync
Specifies whether to process items asynchronously when used with pipeline input.

- **Type**: SwitchParameter
- **Parameter Sets**: (All)
- **Aliases**: None
- **Required**: False
- **Position**: Named
- **Default Value**: False
- **Accept Pipeline Input**: False
- **Accept Wildcard Characters**: False

## Examples

### Example 1: Get all example data
```powershell
PS> Get-ExampleData
```
Retrieves all example data with default parameters.

### Example 2: Get filtered data with limit
```powershell
PS> Get-ExampleData -Filter "Active" -Limit 10
```
Retrieves the first 10 active example data items.

### Example 3: Process pipeline input
```powershell
PS> @("Item1", "Item2", "Item3") | Get-ExampleData -ProcessAsync
```
Processes the input items through the pipeline with async processing.

### Example 4: Get inactive data
```powershell
PS> Get-ExampleData -Filter "Inactive"
```
Retrieves all inactive example data items.

## Outputs

### System.Management.Automation.PSCustomObject
Returns custom objects with Name, Status, and Created properties.

## Notes
- This function supports the PowerShell pipeline and demonstrates proper parameter validation.
- The function includes verbose output for debugging purposes.
- Error handling is implemented with try-catch blocks and proper error messages.

## Related Links
- [Set-ExampleConfig](Set-ExampleConfig.md)
- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines)