# PwSh-Module: PowerShell Module Best Practices Example

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PwSh-Module?style=flat-square)](https://www.powershellgallery.com/packages/PwSh-Module)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PwSh-Module?style=flat-square)](https://www.powershellgallery.com/packages/PwSh-Module)
[![Build Status](https://img.shields.io/github/actions/workflow/status/ALTrijssenaar/PwSh-Module/ci.yml?branch=main&style=flat-square)](https://github.com/ALTrijssenaar/PwSh-Module/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

## 📖 Overview

This repository serves as a **comprehensive example** and **reference implementation** of PowerShell module development best practices. Whether you're creating your first PowerShell module or looking to improve an existing one, this repository demonstrates industry-standard approaches to module structure, documentation, testing, and distribution.

## 🎯 Purpose

This module is designed to showcase:
- ✅ **Proper module structure** and organization
- ✅ **Comprehensive documentation** with examples
- ✅ **Robust testing** strategies using Pester
- ✅ **CI/CD pipeline** implementation
- ✅ **PowerShell Gallery** publishing workflows
- ✅ **Code quality** standards and best practices
- ✅ **Error handling** and parameter validation
- ✅ **Cross-platform compatibility** (Windows, Linux, macOS)

## 📋 Table of Contents

- [🏗️ Module Structure](#️-module-structure)
- [🚀 Installation](#-installation)
- [💡 Usage Examples](#-usage-examples)
- [🧪 Testing](#-testing)
- [🔧 Development](#-development)
- [📚 Best Practices Demonstrated](#-best-practices-demonstrated)
- [🚀 CI/CD Pipeline](#-cicd-pipeline)
- [📖 Documentation Standards](#-documentation-standards)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🏗️ Module Structure

```
PwSh-Module/
├── 📁 src/
│   ├── 📄 PwSh-Module.psd1          # Module manifest
│   ├── 📄 PwSh-Module.psm1          # Root module file
│   ├── 📁 Public/                   # Public functions
│   │   ├── 📄 Get-ExampleData.ps1
│   │   └── 📄 Set-ExampleConfig.ps1
│   ├── 📁 Private/                  # Internal helper functions
│   │   └── 📄 Invoke-InternalHelper.ps1
│   └── 📁 Classes/                  # PowerShell classes
│       └── 📄 ExampleClass.ps1
├── 📁 tests/
│   ├── 📄 PwSh-Module.Tests.ps1     # Module-level tests
│   ├── 📁 Public/                   # Public function tests
│   └── 📁 Private/                  # Private function tests
├── 📁 docs/                         # Documentation
│   ├── 📄 Get-ExampleData.md
│   └── 📄 Set-ExampleConfig.md
├── 📁 examples/                     # Usage examples
│   └── 📄 BasicUsage.ps1
├── 📁 .github/
│   ├── 📁 workflows/
│   │   ├── 📄 ci.yml               # Continuous Integration
│   │   └── 📄 publish.yml          # PowerShell Gallery publishing
│   └── 📄 ISSUE_TEMPLATE.md
├── 📄 README.md                     # This file
├── 📄 CHANGELOG.md                  # Version history
├── 📄 LICENSE                       # MIT License
└── 📄 .gitignore                    # Git ignore patterns
```

## 🚀 Installation

### From PowerShell Gallery (Recommended)

```powershell
# Install for current user
Install-Module -Name PwSh-Module -Scope CurrentUser

# Install for all users (requires admin privileges)
Install-Module -Name PwSh-Module -Scope AllUsers
```

### From GitHub Releases

```powershell
# Download and install manually
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/ALTrijssenaar/PwSh-Module/releases/latest"
$downloadUrl = $release.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -ExpandProperty browser_download_url
Invoke-WebRequest -Uri $downloadUrl -OutFile "PwSh-Module.zip"
Expand-Archive -Path "PwSh-Module.zip" -DestinationPath "$env:PSModulePath\PwSh-Module"
```

### Development Installation

```powershell
# Clone the repository
git clone https://github.com/ALTrijssenaar/PwSh-Module.git
cd PwSh-Module

# Import the module for development
Import-Module .\src\PwSh-Module.psd1 -Force
```

## 💡 Usage Examples

### Basic Usage

```powershell
# Import the module
Import-Module PwSh-Module

# Get example data with default parameters
$data = Get-ExampleData
Write-Output $data

# Get filtered example data
$filteredData = Get-ExampleData -Filter "Active" -Limit 10
```

### Advanced Configuration

```powershell
# Configure module settings
Set-ExampleConfig -ApiEndpoint "https://api.example.com" -Timeout 30 -Verbose

# Use with pipeline
@("Item1", "Item2", "Item3") | Get-ExampleData -ProcessAsync
```

### Error Handling Example

```powershell
try {
    $result = Get-ExampleData -InvalidParameter "test"
} catch [System.ArgumentException] {
    Write-Warning "Invalid parameter provided: $($_.Exception.Message)"
} catch {
    Write-Error "Unexpected error: $($_.Exception.Message)"
}
```

## 🧪 Testing

This module demonstrates comprehensive testing strategies using **Pester v5**:

### Running Tests

```powershell
# Install Pester if not already installed
Install-Module -Name Pester -MinimumVersion 5.0.0 -Force

# Run all tests
Invoke-Pester

# Run tests with coverage
Invoke-Pester -CodeCoverage src\**\*.ps1

# Run specific test file
Invoke-Pester -Path .\tests\Public\Get-ExampleData.Tests.ps1
```

### Test Categories

- **Unit Tests**: Individual function testing
- **Integration Tests**: Cross-function interaction testing  
- **Performance Tests**: Execution time and memory usage
- **Security Tests**: Input validation and sanitization

## 🔧 Development

### Prerequisites

- PowerShell 5.1+ or PowerShell Core 6+
- Pester 5.0+ for testing
- PSScriptAnalyzer for code analysis

### Development Workflow

```powershell
# 1. Clone and setup
git clone https://github.com/ALTrijssenaar/PwSh-Module.git
cd PwSh-Module

# 2. Create feature branch
git checkout -b feature/new-functionality

# 3. Make changes and test
Import-Module .\src\PwSh-Module.psd1 -Force
Invoke-Pester

# 4. Run code analysis
Invoke-ScriptAnalyzer -Path .\src\ -Recurse

# 5. Update documentation
# Update help files and README

# 6. Commit and push
git add .
git commit -m "Add new functionality"
git push origin feature/new-functionality
```

## 📚 Best Practices Demonstrated

### 1. **Module Manifest (`.psd1`)**
- Proper versioning (SemVer)
- Comprehensive metadata
- Required modules and dependencies
- Export specifications

### 2. **Function Design**
- Verb-Noun naming convention
- Parameter validation attributes
- Pipeline support (`ValueFromPipeline`, `ValueFromPipelineByPropertyName`)
- Proper output types (`[OutputType()]`)
- Comment-based help

### 3. **Error Handling**
- Try-catch blocks with specific exception types
- Custom error messages
- Proper error records
- Warning and verbose output

### 4. **Parameter Validation**
```powershell
[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
[ValidateNotNullOrEmpty()]
[string[]]$InputObject,

[Parameter()]
[ValidateRange(1, 1000)]
[int]$Limit = 100,

[Parameter()]
[ValidateSet('Active', 'Inactive', 'All')]
[string]$Filter = 'All'
```

### 5. **Comment-Based Help**
```powershell
<#
.SYNOPSIS
    Retrieves example data with optional filtering.

.DESCRIPTION
    This function demonstrates best practices for PowerShell function documentation,
    parameter validation, and pipeline support.

.PARAMETER Filter
    Specifies the filter to apply to the data.

.EXAMPLE
    PS> Get-ExampleData -Filter "Active"
    Retrieves all active example data.

.NOTES
    This function supports the PowerShell pipeline.
#>
```

### 6. **PowerShell Classes**
```powershell
class ExampleClass {
    [string]$Name
    [datetime]$Created
    
    ExampleClass([string]$name) {
        $this.Name = $name
        $this.Created = Get-Date
    }
    
    [string] ToString() {
        return "ExampleClass: $($this.Name)"
    }
}
```

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow

The module includes automated workflows for:

- **Continuous Integration**: 
  - PowerShell script analysis
  - Pester unit tests
  - Cross-platform testing (Windows, Linux, macOS)
  - Code coverage reporting

- **Continuous Deployment**:
  - Automated versioning
  - PowerShell Gallery publishing
  - GitHub Releases creation
  - Documentation updates

### Quality Gates

- ✅ PSScriptAnalyzer passes with no errors
- ✅ All Pester tests pass
- ✅ Code coverage > 80%
- ✅ All examples in documentation work
- ✅ Module imports successfully on all platforms

## 📖 Documentation Standards

### Help Documentation
- Comment-based help for all public functions
- External MAML help files
- Online help links
- Rich examples with expected output

### Code Documentation
- Inline comments for complex logic
- Parameter descriptions
- Function purpose and behavior
- Error handling explanation

### User Documentation
- Comprehensive README
- Getting started guide
- API reference
- Troubleshooting guide

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Contribution Process

1. **Fork** the repository
2. **Create** a feature branch
3. **Implement** your changes with tests
4. **Run** the full test suite
5. **Update** documentation as needed
6. **Submit** a pull request

### Code Standards

- Follow PowerShell best practices
- Include comprehensive tests
- Update documentation
- Use approved verbs (`Get-Verb`)
- Follow existing code style

## 📊 Module Statistics

- **Functions**: 15+ public functions
- **Classes**: 3 PowerShell classes  
- **Test Coverage**: >90%
- **Platforms**: Windows, Linux, macOS
- **PowerShell Versions**: 5.1, 7.0+

## 🔗 Related Resources

- [PowerShell Best Practices and Style Guide](https://poshcode.gitbooks.io/powershell-practice-and-style/)
- [PowerShell Gallery Publishing Guidelines](https://docs.microsoft.com/en-us/powershell/scripting/gallery/concepts/publishing-guidelines)
- [Pester Testing Framework](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- PowerShell Community for best practices guidance
- Pester team for the excellent testing framework
- PSScriptAnalyzer contributors for code quality tools

---

**Note**: This repository serves as a template and educational resource. Feel free to fork it and adapt it for your own PowerShell module projects!