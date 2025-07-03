# PwSh-Module Basic Usage Examples

# This script demonstrates basic usage of the PwSh-Module functions
# Run this script to see the module in action

# Import the module (if not already imported)
Import-Module PwSh-Module -Force

Write-Host "=== PwSh-Module Basic Usage Examples ===" -ForegroundColor Green

# Example 1: Basic data retrieval
Write-Host "`n1. Getting example data with default parameters:" -ForegroundColor Yellow
$data = Get-ExampleData
$data | Format-Table -AutoSize

# Example 2: Filtered data retrieval
Write-Host "`n2. Getting active data with limit:" -ForegroundColor Yellow
$activeData = Get-ExampleData -Filter "Active" -Limit 2
$activeData | Format-Table -AutoSize

# Example 3: Pipeline processing
Write-Host "`n3. Processing items through pipeline:" -ForegroundColor Yellow
$items = @("Product1", "Product2", "Product3")
$processedItems = $items | Get-ExampleData
$processedItems | Format-Table -AutoSize

# Example 4: Async pipeline processing
Write-Host "`n4. Async processing through pipeline:" -ForegroundColor Yellow
$asyncItems = @("AsyncItem1", "AsyncItem2") | Get-ExampleData -ProcessAsync
$asyncItems | Format-Table -AutoSize

# Example 5: Configuration management
Write-Host "`n5. Setting module configuration:" -ForegroundColor Yellow
$config = Set-ExampleConfig -ApiEndpoint "https://api.example.com" -Timeout 60 -EnableLogging
Write-Host "Configuration set successfully!"
$config | Format-List

# Example 6: Updating configuration
Write-Host "`n6. Updating configuration with multiple parameters:" -ForegroundColor Yellow
$updatedConfig = Set-ExampleConfig -RetryCount 5 -LogLevel "Debug"
Write-Host "Configuration updated!"
$updatedConfig | Format-List

# Example 7: Viewing current configuration
Write-Host "`n7. Current configuration:" -ForegroundColor Yellow
$currentConfig = Set-ExampleConfig
$currentConfig | Format-List

# Example 8: Error handling demonstration
Write-Host "`n8. Error handling example:" -ForegroundColor Yellow
try {
    # This will trigger parameter validation error
    Get-ExampleData -Limit 0
} catch {
    Write-Host "Caught expected error: $($_.Exception.Message)" -ForegroundColor Red
}

# Example 9: Verbose output
Write-Host "`n9. Using verbose output:" -ForegroundColor Yellow
Get-ExampleData -Filter "Active" -Limit 1 -Verbose

# Example 10: Configuration with validation
Write-Host "`n10. Configuration with URL validation:" -ForegroundColor Yellow
try {
    Set-ExampleConfig -ApiEndpoint "invalid-url"
} catch {
    Write-Host "Caught expected validation error: $($_.Exception.Message)" -ForegroundColor Red
}

# Example 11: Successful URL configuration
Write-Host "`n11. Setting valid API endpoint:" -ForegroundColor Yellow
$validConfig = Set-ExampleConfig -ApiEndpoint "https://valid.api.com"
Write-Host "Valid endpoint set: $($validConfig.ApiEndpoint)" -ForegroundColor Green

Write-Host "`n=== Examples Complete ===" -ForegroundColor Green
Write-Host "These examples demonstrate the key features of PwSh-Module:" -ForegroundColor Cyan
Write-Host "- Parameter validation and pipeline support" -ForegroundColor Cyan
Write-Host "- Configuration management with validation" -ForegroundColor Cyan
Write-Host "- Error handling and verbose output" -ForegroundColor Cyan
Write-Host "- Best practices for PowerShell module development" -ForegroundColor Cyan