$PARENT = Split-Path $MyInvocation.MyCommand.Path
$GPARENT = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
. "$PARENT/shared.ps1"  # import ReadLines method

$definedExtensions = ReadLines -Path (Join-Path $GPARENT ".Brewfile") `
                        | Where-Object { $_ -like "vscode*" } `
                        | ForEach-Object { $_.Split(" ")[1].Trim('"') } `




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