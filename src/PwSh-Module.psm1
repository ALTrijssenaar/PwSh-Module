#Requires -Version 5.1

# Get the path to the module
$ModulePath = Split-Path $MyInvocation.MyCommand.Path -Parent

# Import all classes first
$ClassFiles = Get-ChildItem -Path "$ModulePath\Classes\*.ps1" -ErrorAction SilentlyContinue
foreach ($ClassFile in $ClassFiles) {
    Write-Verbose "Importing class file: $($ClassFile.Name)"
    . $ClassFile.FullName
}

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