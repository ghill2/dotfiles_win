if ($env:USERNAME -like "g*") {
    & (Join-Path (Split-Path $PSScriptRoot) "bootstrap.ps1")
} elseif ($env:USERNAME -like "t*") {
    & (Join-Path (Split-Path $PSScriptRoot) "bootstrap_shared.ps1")
}

& (Join-Path (Split-Path $PSScriptRoot) "links.ps1")
& (Join-Path (Split-Path $PSScriptRoot) "packages.ps1")
# & (Join-Path (Split-Path $PSScriptRoot) "extensions.ps1")
& (Join-Path (Split-Path $PSScriptRoot) "settings.ps1")