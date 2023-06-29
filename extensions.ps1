
. (Join-Path (Split-Path $PSScriptRoot) "_shared.ps1") # import ReadLines method

$definedExtensions = ReadLines -Path (Join-Path (Split-Path $PSScriptRoot) "extensions.txt")

Write-Output $definedExtensions


foreach ($definedExtension in $definedExtensions) {
    if ($definedExtension -in $installedExtensions) {
        Write-Host ([String]::Format("Extension {0} is already installed. Installing...", $definedExtension))
        continue
    }
    Write-Host ([String]::Format("Extension {0} is not installed", $definedExtension))
    code --install-extension $definedExtension --force
}


$installedExtensions = code --list-extensions | Select-Object -Skip 1
foreach ($installedExtension in $installedExtensions) {
    if ($installedExtension -in $definedExtensions) {
        Write-Host ([String]::Format("Extension {0} is defined", $installedExtension))
        continue
    }
    Write-Host ([String]::Format("Extension {0} is not defined", $installedExtension))
    code --uninstall-extension $installedExtension --force
}