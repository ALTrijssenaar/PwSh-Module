#Requires -Module Pester

BeforeAll {
    # Import the module for testing
    $ModulePath = Join-Path $PSScriptRoot "..\..\src\PwSh-Module.psd1"
    Import-Module $ModulePath -Force
    
    # Clean up any existing configuration
    Remove-Variable -Name PwShModuleConfig -Scope Global -ErrorAction SilentlyContinue
}

Describe "Set-ExampleConfig" {
    Context "Basic Functionality" {
        It "Should create configuration when called" {
            $result = Set-ExampleConfig
            $result | Should -Not -BeNullOrEmpty
            $Global:PwShModuleConfig | Should -Not -BeNullOrEmpty
        }

        It "Should return current configuration object" {
            $result = Set-ExampleConfig
            $result.Timeout | Should -Be 30
            $result.RetryCount | Should -Be 3
            $result.EnableLogging | Should -Be $false
            $result.LogLevel | Should -Be "Information"
        }

        It "Should update LastUpdated when configuration changes" {
            Set-ExampleConfig -Timeout 45
            $Global:PwShModuleConfig.LastUpdated | Should -Not -BeNullOrEmpty
            $Global:PwShModuleConfig.LastUpdated | Should -BeOfType [datetime]
        }
    }

    Context "ApiEndpoint Parameter" {
        It "Should set ApiEndpoint with valid URL" {
            $result = Set-ExampleConfig -ApiEndpoint "https://api.example.com"
            $result.ApiEndpoint | Should -Be "https://api.example.com"
        }

        It "Should accept HTTP URLs" {
            $result = Set-ExampleConfig -ApiEndpoint "http://api.example.com"
            $result.ApiEndpoint | Should -Be "http://api.example.com"
        }

        It "Should reject invalid URLs" {
            { Set-ExampleConfig -ApiEndpoint "invalid-url" } | Should -Throw
        }

        It "Should reject non-HTTP protocols" {
            { Set-ExampleConfig -ApiEndpoint "ftp://example.com" } | Should -Throw
        }
    }

    Context "Timeout Parameter" {
        It "Should set timeout within valid range" {
            $result = Set-ExampleConfig -Timeout 60
            $result.Timeout | Should -Be 60
        }

        It "Should reject timeout values below minimum" {
            { Set-ExampleConfig -Timeout 0 } | Should -Throw
        }

        It "Should reject timeout values above maximum" {
            { Set-ExampleConfig -Timeout 301 } | Should -Throw
        }

        It "Should accept boundary values" {
            { Set-ExampleConfig -Timeout 1 } | Should -Not -Throw
            { Set-ExampleConfig -Timeout 300 } | Should -Not -Throw
        }
    }

    Context "RetryCount Parameter" {
        It "Should set retry count within valid range" {
            $result = Set-ExampleConfig -RetryCount 5
            $result.RetryCount | Should -Be 5
        }

        It "Should accept zero retry count" {
            $result = Set-ExampleConfig -RetryCount 0
            $result.RetryCount | Should -Be 0
        }

        It "Should reject retry count above maximum" {
            { Set-ExampleConfig -RetryCount 11 } | Should -Throw
        }

        It "Should accept boundary values" {
            { Set-ExampleConfig -RetryCount 10 } | Should -Not -Throw
        }
    }

    Context "EnableLogging Parameter" {
        It "Should enable logging when switch is present" {
            $result = Set-ExampleConfig -EnableLogging
            $result.EnableLogging | Should -Be $true
        }

        It "Should maintain logging state when not specified" {
            Set-ExampleConfig -EnableLogging
            $result = Set-ExampleConfig -Timeout 45
            $result.EnableLogging | Should -Be $true
        }
    }

    Context "LogLevel Parameter" {
        It "Should set valid log levels" {
            @('Error', 'Warning', 'Information', 'Verbose', 'Debug') | ForEach-Object {
                $result = Set-ExampleConfig -LogLevel $_
                $result.LogLevel | Should -Be $_
            }
        }

        It "Should reject invalid log levels" {
            { Set-ExampleConfig -LogLevel "InvalidLevel" } | Should -Throw
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf parameter" {
            { Set-ExampleConfig -ApiEndpoint "https://test.com" -WhatIf } | Should -Not -Throw
        }
    }

    Context "Multiple Parameters" {
        It "Should handle multiple parameters in single call" {
            $result = Set-ExampleConfig -ApiEndpoint "https://multi.example.com" -Timeout 120 -RetryCount 7 -EnableLogging -LogLevel "Debug"
            
            $result.ApiEndpoint | Should -Be "https://multi.example.com"
            $result.Timeout | Should -Be 120
            $result.RetryCount | Should -Be 7
            $result.EnableLogging | Should -Be $true
            $result.LogLevel | Should -Be "Debug"
        }
    }

    Context "Configuration Persistence" {
        It "Should persist configuration across function calls" {
            Set-ExampleConfig -ApiEndpoint "https://persist.example.com" -Timeout 90
            
            $result = Set-ExampleConfig -RetryCount 6
            $result.ApiEndpoint | Should -Be "https://persist.example.com"
            $result.Timeout | Should -Be 90
            $result.RetryCount | Should -Be 6
        }
    }
}

AfterAll {
    # Clean up
    Remove-Module PwSh-Module -Force -ErrorAction SilentlyContinue
    Remove-Variable -Name PwShModuleConfig -Scope Global -ErrorAction SilentlyContinue
}