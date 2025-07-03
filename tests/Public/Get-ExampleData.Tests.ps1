#Requires -Module Pester

BeforeAll {
    # Import the module for testing
    $ModulePath = Join-Path $PSScriptRoot "..\..\src\PwSh-Module.psd1"
    Import-Module $ModulePath -Force
}

Describe "Get-ExampleData" {
    Context "Basic Functionality" {
        It "Should return data without parameters" {
            $result = Get-ExampleData
            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -BeGreaterThan 0
        }

        It "Should return objects with correct properties" {
            $result = Get-ExampleData -Limit 1
            $result[0] | Should -Not -BeNullOrEmpty
            $result[0].Name | Should -Not -BeNullOrEmpty
            $result[0].Status | Should -Not -BeNullOrEmpty
            $result[0].Created | Should -BeOfType [datetime]
        }

        It "Should respect the Limit parameter" {
            $result = Get-ExampleData -Limit 2
            $result.Count | Should -Be 2
        }
    }

    Context "Filter Parameter" {
        It "Should filter by Active status" {
            $result = Get-ExampleData -Filter "Active"
            $result | Where-Object { $_.Status -ne "Active" } | Should -BeNullOrEmpty
        }

        It "Should filter by Inactive status" {
            $result = Get-ExampleData -Filter "Inactive"
            $result | Where-Object { $_.Status -ne "Inactive" } | Should -BeNullOrEmpty
        }

        It "Should return all data with All filter" {
            $allResult = Get-ExampleData -Filter "All"
            $noFilterResult = Get-ExampleData
            $allResult.Count | Should -Be $noFilterResult.Count
        }
    }

    Context "Pipeline Support" {
        It "Should accept pipeline input" {
            $input = @("Test1", "Test2")
            $result = $input | Get-ExampleData
            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
            $result[0].Name | Should -Be "Test1"
            $result[1].Name | Should -Be "Test2"
        }

        It "Should process pipeline input with ProcessAsync switch" {
            $input = @("AsyncTest1", "AsyncTest2")
            $result = $input | Get-ExampleData -ProcessAsync
            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
            $result | ForEach-Object { $_.Status | Should -Be "Processed" }
        }
    }

    Context "Parameter Validation" {
        It "Should validate Filter parameter values" {
            { Get-ExampleData -Filter "InvalidFilter" } | Should -Throw
        }

        It "Should validate Limit parameter range" {
            { Get-ExampleData -Limit 0 } | Should -Throw
            { Get-ExampleData -Limit 1001 } | Should -Throw
        }

        It "Should accept valid Limit values" {
            { Get-ExampleData -Limit 1 } | Should -Not -Throw
            { Get-ExampleData -Limit 1000 } | Should -Not -Throw
        }
    }

    Context "Error Handling" {
        It "Should handle null input gracefully in pipeline" {
            { $null | Get-ExampleData } | Should -Throw
        }

        It "Should handle empty string input gracefully in pipeline" {
            { "" | Get-ExampleData } | Should -Throw
        }
    }
}

AfterAll {
    # Clean up
    Remove-Module PwSh-Module -Force -ErrorAction SilentlyContinue
}