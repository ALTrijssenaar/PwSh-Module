#Requires -Module Pester

BeforeAll {
    # Import the module for testing
    $ModulePath = Join-Path $PSScriptRoot "..\src\PwSh-Module.psd1"
    Import-Module $ModulePath -Force
}

Describe "PwSh-Module" {
    Context "Module Import" {
        It "Should import the module successfully" {
            Get-Module PwSh-Module | Should -Not -BeNullOrEmpty
        }

        It "Should export the correct functions" {
            $ExportedFunctions = (Get-Module PwSh-Module).ExportedFunctions.Keys
            $ExportedFunctions | Should -Contain "Get-ExampleData"
            $ExportedFunctions | Should -Contain "Set-ExampleConfig"
        }

        It "Should have correct module metadata" {
            $Module = Get-Module PwSh-Module
            $Module.Version | Should -Be "1.0.0"
            $Module.Author | Should -Be "ALTrijssenaar"
            $Module.Description | Should -Match "PowerShell Module Best Practices Example"
        }
    }

    Context "Module Functions" {
        It "Should have Get-ExampleData function available" {
            Get-Command Get-ExampleData -Module PwSh-Module | Should -Not -BeNullOrEmpty
        }

        It "Should have Set-ExampleConfig function available" {
            Get-Command Set-ExampleConfig -Module PwSh-Module | Should -Not -BeNullOrEmpty
        }
    }

    Context "Module Classes" {
        It "Should have module loaded successfully" {
            Get-Module PwSh-Module | Should -Not -BeNullOrEmpty
        }
    }

    Context "Module Configuration" {
        It "Should initialize global configuration when Set-ExampleConfig is called" {
            Set-ExampleConfig -Timeout 60 | Should -Not -BeNullOrEmpty
            $Global:PwShModuleConfig | Should -Not -BeNullOrEmpty
            $Global:PwShModuleConfig.Timeout | Should -Be 60
        }
    }
}

AfterAll {
    # Clean up
    Remove-Module PwSh-Module -Force -ErrorAction SilentlyContinue
    Remove-Variable -Name PwShModuleConfig -Scope Global -ErrorAction SilentlyContinue
}