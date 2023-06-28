$PARENT = (Get-Item -Force -Path $MyInvocation.MyCommand.Path).Target | ForEach-Object { if ($_ -eq $null) { Split-Path $MyInvocation.MyCommand.Path } else { Split-Path $_ } }
$GPARENT = Split-Path $PARENT

& "$PARENT/bootstrap.ps1"
& "$PARENT/links.ps1"

# & "$PARENT/packages.ps1"

# & "$PARENT/extensions.ps1"

# & "$PARENT/settings.ps1"

# Invoke-Expression $([System.IO.File]::ReadAllText("$PARENT/settings_shared"))
