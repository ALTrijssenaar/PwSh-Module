#Requires -Version 5.1

# Define the ExampleClass as a PowerShell class
# Classes need to be defined before any functions that use them
class ExampleClass {
    # Properties
    [string]$Name
    [datetime]$Created
    [string]$Status
    [hashtable]$Properties

    # Default constructor
    ExampleClass() {
        $this.Name = "Default"
        $this.Created = Get-Date
        $this.Status = "New"
        $this.Properties = @{}
    }

    # Constructor with name parameter
    ExampleClass([string]$name) {
        $this.Name = $name
        $this.Created = Get-Date
        $this.Status = "New"
        $this.Properties = @{}
    }

    # Constructor with all parameters
    ExampleClass([string]$name, [string]$status) {
        $this.Name = $name
        $this.Created = Get-Date
        $this.Status = $status
        $this.Properties = @{}
    }

    # Method to add a property
    [void] AddProperty([string]$key, [object]$value) {
        if ([string]::IsNullOrWhiteSpace($key)) {
            throw "Property key cannot be null or empty."
        }
        $this.Properties[$key] = $value
    }

    # Method to get a property
    [object] GetProperty([string]$key) {
        if ([string]::IsNullOrWhiteSpace($key)) {
            throw "Property key cannot be null or empty."
        }
        return $this.Properties[$key]
    }

    # Method to remove a property
    [bool] RemoveProperty([string]$key) {
        if ([string]::IsNullOrWhiteSpace($key)) {
            return $false
        }
        return $this.Properties.Remove($key)
    }

    # Method to update status
    [void] UpdateStatus([string]$newStatus) {
        if ([string]::IsNullOrWhiteSpace($newStatus)) {
            throw "Status cannot be null or empty."
        }
        $this.Status = $newStatus
    }

    # Method to get age in days
    [int] GetAgeInDays() {
        return (Get-Date).Subtract($this.Created).Days
    }

    # Method to validate the object
    [bool] IsValid() {
        return (-not [string]::IsNullOrWhiteSpace($this.Name)) -and 
               ($this.Created -le (Get-Date)) -and 
               (-not [string]::IsNullOrWhiteSpace($this.Status))
    }

    # Method to export to hashtable
    [hashtable] ToHashtable() {
        return @{
            Name = $this.Name
            Created = $this.Created
            Status = $this.Status
            Properties = $this.Properties.Clone()
            AgeInDays = $this.GetAgeInDays()
            IsValid = $this.IsValid()
        }
    }

    # Override ToString method
    [string] ToString() {
        return "ExampleClass: $($this.Name) (Status: $($this.Status), Created: $($this.Created.ToString('yyyy-MM-dd')))"
    }

    # Static method to create from hashtable
    static [ExampleClass] FromHashtable([hashtable]$data) {
        if ($null -eq $data) {
            throw "Data hashtable cannot be null."
        }

        $instance = [ExampleClass]::new()
        
        if ($data.ContainsKey('Name') -and -not [string]::IsNullOrWhiteSpace($data.Name)) {
            $instance.Name = $data.Name
        }
        
        if ($data.ContainsKey('Status') -and -not [string]::IsNullOrWhiteSpace($data.Status)) {
            $instance.Status = $data.Status
        }
        
        if ($data.ContainsKey('Created') -and $data.Created -is [datetime]) {
            $instance.Created = $data.Created
        }
        
        if ($data.ContainsKey('Properties') -and $data.Properties -is [hashtable]) {
            $instance.Properties = $data.Properties.Clone()
        }

        return $instance
    }

    # Static method to validate input data
    static [bool] ValidateInputData([hashtable]$data) {
        if ($null -eq $data) {
            return $false
        }

        # Check for required fields
        if (-not $data.ContainsKey('Name') -or [string]::IsNullOrWhiteSpace($data.Name)) {
            return $false
        }

        # Validate datetime if provided
        if ($data.ContainsKey('Created') -and $data.Created -isnot [datetime]) {
            return $false
        }

        return $true
    }
}

# Get the path to the module
$ModulePath = Split-Path $MyInvocation.MyCommand.Path -Parent

# Import private functions
$PrivateFunctions = Get-ChildItem -Path "$ModulePath\Private\*.ps1" -ErrorAction SilentlyContinue
foreach ($PrivateFunction in $PrivateFunctions) {
    Write-Verbose "Importing private function: $($PrivateFunction.Name)"
    . $PrivateFunction.FullName
}

# Import public functions and create aliases
$PublicFunctions = Get-ChildItem -Path "$ModulePath\Public\*.ps1" -ErrorAction SilentlyContinue
foreach ($PublicFunction in $PublicFunctions) {
    Write-Verbose "Importing public function: $($PublicFunction.Name)"
    . $PublicFunction.FullName
}

# Export only the public functions
Export-ModuleMember -Function (Get-ChildItem -Path "$ModulePath\Public\*.ps1" | ForEach-Object { $_.BaseName })