function Invoke-InternalHelper {
    <#
    .SYNOPSIS
        Internal helper function for common module operations.

    .DESCRIPTION
        This is a private function that demonstrates how to create internal helper functions
        that are not exported from the module but can be used by public functions.

    .PARAMETER InputData
        The input data to process.

    .PARAMETER Operation
        The operation to perform on the input data.

    .PARAMETER UseValidation
        Whether to perform additional validation on the input.

    .NOTES
        This function is for internal use only and is not exported from the module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$InputData,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Transform', 'Validate', 'Process', 'Format')]
        [string]$Operation,

        [Parameter()]
        [switch]$UseValidation
    )

    Write-Verbose "Invoke-InternalHelper called with Operation: $Operation"

    try {
        # Perform input validation if requested
        if ($UseValidation) {
            if ($null -eq $InputData) {
                throw "InputData cannot be null when validation is enabled."
            }
            Write-Verbose "Input validation passed"
        }

        # Perform the requested operation
        switch ($Operation) {
            'Transform' {
                Write-Verbose "Performing Transform operation"
                if ($InputData -is [string]) {
                    return $InputData.ToUpper()
                } elseif ($InputData -is [array]) {
                    return $InputData | ForEach-Object { $_.ToString().ToUpper() }
                } else {
                    return $InputData.ToString().ToUpper()
                }
            }

            'Validate' {
                Write-Verbose "Performing Validate operation"
                $IsValid = $true
                $ValidationResults = @()

                if ($InputData -is [string] -and [string]::IsNullOrWhiteSpace($InputData)) {
                    $IsValid = $false
                    $ValidationResults += "String input is null or whitespace"
                }

                if ($InputData -is [array] -and $InputData.Count -eq 0) {
                    $IsValid = $false
                    $ValidationResults += "Array input is empty"
                }

                return [PSCustomObject]@{
                    IsValid = $IsValid
                    ValidationResults = $ValidationResults
                    InputType = $InputData.GetType().Name
                }
            }

            'Process' {
                Write-Verbose "Performing Process operation"
                if ($InputData -is [array]) {
                    $ProcessedCount = 0
                    $Results = @()
                    
                    foreach ($Item in $InputData) {
                        $Results += [PSCustomObject]@{
                            OriginalValue = $Item
                            ProcessedValue = "Processed_$Item"
                            Index = $ProcessedCount
                        }
                        $ProcessedCount++
                    }
                    
                    return [PSCustomObject]@{
                        TotalItems = $ProcessedCount
                        Results = $Results
                    }
                } else {
                    return [PSCustomObject]@{
                        OriginalValue = $InputData
                        ProcessedValue = "Processed_$InputData"
                        ProcessedAt = Get-Date
                    }
                }
            }

            'Format' {
                Write-Verbose "Performing Format operation"
                if ($InputData -is [datetime]) {
                    return $InputData.ToString("yyyy-MM-dd HH:mm:ss")
                } elseif ($InputData -is [hashtable]) {
                    $FormattedEntries = @()
                    foreach ($Key in $InputData.Keys) {
                        $FormattedEntries += "$Key = $($InputData[$Key])"
                    }
                    return $FormattedEntries -join "; "
                } else {
                    return $InputData.ToString()
                }
            }

            default {
                throw "Unknown operation: $Operation"
            }
        }
    }
    catch {
        Write-Error "Error in Invoke-InternalHelper: $($_.Exception.Message)"
        throw
    }
}