# Can't run a method in an alias like this
# New-Alias -Name HelloWorld -Value { Write-Host "Hello, World!" }

function ReloadProfile { . $PROFILE }

function RemoveEnvironment {
    Remote-Item -Path '.\.venv' -Force
 }

New-Alias -Name re -Value ReloadProfile -Force
New-Alias -Name rmenv -Value RemoveEnvironment -Force