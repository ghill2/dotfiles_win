# Can't run a method in an alias like this
# New-Alias -Name HelloWorld -Value { Write-Host "Hello, World!" }

function ReloadProfile { . $PROFILE }

New-Alias -Name ree -Value ReloadProfile -Force