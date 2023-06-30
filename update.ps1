if ($env:USERNAME -like "g*") {
    & (Join-Path $PSScriptRoot "bootstrap.ps1")
} elseif ($env:USERNAME -like "t*") {
    & (Join-Path $PSScriptRoot "bootstrap_shared.ps1")
}

& (Join-Path $PSScriptRoot "links.ps1")
& (Join-Path $PSScriptRoot "packages.ps1")
# & (Join-Path (Split-Path $PSScriptRoot) "extensions.ps1")
& (Join-Path $PSScriptRoot "settings.ps1")