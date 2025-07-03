#Requires -Module Pester

BeforeAll {
    # Import the module for testing (this also imports private functions)
    $ModulePath = Join-Path $PSScriptRoot "..\..\src\PwSh-Module.psd1"
    Import-Module $ModulePath -Force
    
    # Import the private function directly for testing
    . (Join-Path $PSScriptRoot "..\..\src\Private\Invoke-InternalHelper.ps1")
}

Describe "Invoke-InternalHelper" {
    Context "Transform Operation" {
        It "Should transform string input to uppercase" {
            $result = Invoke-InternalHelper -InputData "hello world" -Operation "Transform"
            $result | Should -Be "HELLO WORLD"
        }

        It "Should transform array input to uppercase" {
            $input = @("hello", "world")
            $result = Invoke-InternalHelper -InputData $input -Operation "Transform"
            $result[0] | Should -Be "HELLO"
            $result[1] | Should -Be "WORLD"
        }

        It "Should transform object input to uppercase string" {
            $input = @{ Name = "test" }
            $result = Invoke-InternalHelper -InputData $input -Operation "Transform"
            $result | Should -Be "SYSTEM.COLLECTIONS.HASHTABLE"
        }
    }

    Context "Validate Operation" {
        It "Should validate non-empty string as valid" {
            $result = Invoke-InternalHelper -InputData "test string" -Operation "Validate"
            $result.IsValid | Should -Be $true
            $result.ValidationResults.Count | Should -Be 0
            $result.InputType | Should -Be "String"
        }

        It "Should validate empty string as invalid" {
            $result = Invoke-InternalHelper -InputData "" -Operation "Validate"
            $result.IsValid | Should -Be $false
            $result.ValidationResults | Should -Contain "String input is null or whitespace"
        }

        It "Should validate empty array as invalid" {
            $result = Invoke-InternalHelper -InputData @() -Operation "Validate"
            $result.IsValid | Should -Be $false
            $result.ValidationResults | Should -Contain "Array input is empty"
        }

        It "Should validate non-empty array as valid" {
            $result = Invoke-InternalHelper -InputData @("item1", "item2") -Operation "Validate"
            $result.IsValid | Should -Be $true
            $result.ValidationResults.Count | Should -Be 0
        }
    }

    Context "Process Operation" {
        It "Should process single item" {
            $result = Invoke-InternalHelper -InputData "single item" -Operation "Process"
            $result.OriginalValue | Should -Be "single item"
            $result.ProcessedValue | Should -Be "Processed_single item"
            $result.ProcessedAt | Should -BeOfType [datetime]
        }

        It "Should process array items" {
            $input = @("item1", "item2", "item3")
            $result = Invoke-InternalHelper -InputData $input -Operation "Process"
            $result.TotalItems | Should -Be 3
            $result.Results.Count | Should -Be 3
            $result.Results[0].OriginalValue | Should -Be "item1"
            $result.Results[0].ProcessedValue | Should -Be "Processed_item1"
            $result.Results[0].Index | Should -Be 0
        }
    }

    Context "Format Operation" {
        It "Should format datetime object" {
            $date = Get-Date "2024-01-15 14:30:45"
            $result = Invoke-InternalHelper -InputData $date -Operation "Format"
            $result | Should -Be "2024-01-15 14:30:45"
        }

        It "Should format hashtable object" {
            $hashtable = @{ Key1 = "Value1"; Key2 = "Value2" }
            $result = Invoke-InternalHelper -InputData $hashtable -Operation "Format"
            $result | Should -Match "Key1 = Value1"
            $result | Should -Match "Key2 = Value2"
        }

        It "Should format other objects as string" {
            $result = Invoke-InternalHelper -InputData 123 -Operation "Format"
            $result | Should -Be "123"
        }
    }

    Context "Validation Parameter" {
        It "Should perform validation when UseValidation is specified" {
            # Test with empty string since null can't be passed to mandatory parameter
            { Invoke-InternalHelper -InputData "" -Operation "Transform" -UseValidation } | Should -Not -Throw
        }

        It "Should skip validation when UseValidation is not specified" {
            { Invoke-InternalHelper -InputData "" -Operation "Transform" } | Should -Not -Throw
        }

        It "Should pass validation with valid input" {
            { Invoke-InternalHelper -InputData "valid input" -Operation "Transform" -UseValidation } | Should -Not -Throw
        }
    }

    Context "Error Handling" {
        It "Should throw error for unknown operation" {
            { Invoke-InternalHelper -InputData "test" -Operation "UnknownOperation" } | Should -Throw "*does not belong to the set*"
        }

        It "Should validate operation parameter values" {
            { Invoke-InternalHelper -InputData "test" -Operation "InvalidOperation" } | Should -Throw
        }
    }

    Context "Parameter Validation" {
        It "Should have mandatory InputData parameter" {
            $function = Get-Command Invoke-InternalHelper
            $inputParam = $function.Parameters['InputData']
            $inputParam.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] } | 
                ForEach-Object { $_.Mandatory } | Should -Be $true
        }

        It "Should have mandatory Operation parameter" {
            $function = Get-Command Invoke-InternalHelper
            $operationParam = $function.Parameters['Operation']
            $operationParam.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] } | 
                ForEach-Object { $_.Mandatory } | Should -Be $true
        }

        It "Should accept valid operation values" {
            @('Transform', 'Validate', 'Process', 'Format') | ForEach-Object {
                { Invoke-InternalHelper -InputData "test" -Operation $_ } | Should -Not -Throw
            }
        }
    }

    Context "Verbose Output" {
        It "Should write verbose messages when verbose preference is set" {
            $VerboseMessages = @()
            $result = Invoke-InternalHelper -InputData "test" -Operation "Transform" -Verbose 4>&1
            $VerboseMessages = $result | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }
            $VerboseMessages.Count | Should -BeGreaterThan 0
        }
    }
}

AfterAll {
    # Clean up
    Remove-Module PwSh-Module -Force -ErrorAction SilentlyContinue
}