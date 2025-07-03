function Get-ExampleData {
    <#
    .SYNOPSIS
        Retrieves example data with optional filtering.

    .DESCRIPTION
        This function demonstrates best practices for PowerShell function documentation,
        parameter validation, and pipeline support. It returns example data objects
        that can be filtered and limited based on the provided parameters.

    .PARAMETER Filter
        Specifies the filter to apply to the data. Valid values are 'Active', 'Inactive', or 'All'.
        Default is 'All'.

    .PARAMETER Limit
        Specifies the maximum number of records to return. Must be between 1 and 1000.
        Default is 100.

    .PARAMETER InputObject
        Specifies input objects to process. Supports pipeline input.

    .PARAMETER ProcessAsync
        Specifies whether to process items asynchronously when used with pipeline input.

    .EXAMPLE
        PS> Get-ExampleData
        Retrieves all example data with default parameters.

    .EXAMPLE
        PS> Get-ExampleData -Filter "Active" -Limit 10
        Retrieves the first 10 active example data items.

    .EXAMPLE
        PS> @("Item1", "Item2", "Item3") | Get-ExampleData -ProcessAsync
        Processes the input items through the pipeline with async processing.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Returns custom objects with Name, Status, and Created properties.

    .NOTES
        This function supports the PowerShell pipeline and demonstrates proper parameter validation.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param(
        [Parameter()]
        [ValidateSet('Active', 'Inactive', 'All')]
        [string]$Filter = 'All',

        [Parameter()]
        [ValidateRange(1, 1000)]
        [int]$Limit = 100,

        [Parameter(ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$InputObject,

        [Parameter()]
        [switch]$ProcessAsync
    )

    begin {
        Write-Verbose "Starting Get-ExampleData with Filter: $Filter, Limit: $Limit"
        
        # Sample data for demonstration
        $SampleData = @(
            [PSCustomObject]@{ Name = "Example1"; Status = "Active"; Created = (Get-Date).AddDays(-1) }
            [PSCustomObject]@{ Name = "Example2"; Status = "Inactive"; Created = (Get-Date).AddDays(-2) }
            [PSCustomObject]@{ Name = "Example3"; Status = "Active"; Created = (Get-Date).AddDays(-3) }
            [PSCustomObject]@{ Name = "Example4"; Status = "Active"; Created = (Get-Date).AddDays(-4) }
            [PSCustomObject]@{ Name = "Example5"; Status = "Inactive"; Created = (Get-Date).AddDays(-5) }
        )
        
        $ProcessedItems = @()
    }

    process {
        if ($InputObject) {
            foreach ($Item in $InputObject) {
                Write-Verbose "Processing input item: $Item"
                
                if ($ProcessAsync) {
                    # Simulate async processing
                    Start-Sleep -Milliseconds 100
                }
                
                $ProcessedItems += [PSCustomObject]@{
                    Name = $Item
                    Status = "Processed"
                    Created = Get-Date
                }
            }
        }
    }

    end {
        try {
            if ($ProcessedItems.Count -gt 0) {
                # Return processed pipeline input
                $ResultData = $ProcessedItems
            } else {
                # Return sample data
                $ResultData = $SampleData
            }

            # Apply filter
            switch ($Filter) {
                'Active' { $ResultData = $ResultData | Where-Object { $_.Status -eq 'Active' } }
                'Inactive' { $ResultData = $ResultData | Where-Object { $_.Status -eq 'Inactive' } }
                'All' { # No filtering needed }
                default { 
                    Write-Warning "Invalid filter value: $Filter. Using 'All'."
                }
            }

            # Apply limit
            $ResultData = $ResultData | Select-Object -First $Limit

            Write-Verbose "Returning $($ResultData.Count) items"
            return $ResultData
        }
        catch {
            $ErrorMessage = "Failed to retrieve example data: $($_.Exception.Message)"
            Write-Error $ErrorMessage
            throw
        }
    }
}