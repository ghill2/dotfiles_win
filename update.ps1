if ($env:USERNAME -eq "g2") {
    & "$PSScriptRoot/bootstrap.ps1"
}

& "$PSScriptRoot/bootstrap_shared.ps1"
& "$PSScriptRoot/links.ps1"

& "$PSScriptRoot/packages.ps1"

& "$PSScriptRoot/extensions.ps1"

& "$PSScriptRoot/settings.ps1"