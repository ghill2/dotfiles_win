function re {
    . $PROFILE
    Write-Output "Reloaded Powershell Profile..."
}

function rmenv {
    Remove-Item -Path '.\.venv' -Force
}

function bash {
    & "C:\Program Files\Git\bin\bash.exe"
}

function cy {
    & "C:\tools\cygwin\bash.exe"
}

function pl {
    # $Env:Path.Split(";")
    [Environment]::GetEnvironmentVariable("PATH", "User").Split(";")
}

function restart {
    Restart-Computer -Force
}

function PrependToUserPath($directory) {
    if (-not (Test-Path -Path $directory -PathType Container)) {
        Write-Host "Directory does not exist: $directory"
        return
    }
    
    $existingPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if (-not ($existingPath -split ';' -contains $directory)) {
        $newPath = "$directory;$existingPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "Directory prepended to PATH: $directory"
    }
    else {
        Write-Host "Directory already exists in PATH: $directory"
    }
}

function c() {
    # If $? is $true, indicating the previous command executed successfully, the subsequent command is executed.
    git add .
    if ($?) {
        git commit -m $(Get-Date -Format "MM/dd/yyyy HH:mm:ss")
        if ($?) {
            git push origin $(git rev-parse --abbrev-ref HEAD)
        }
    }
}

# NOT WORKING?
function rmpath {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    $existingPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $updatedPath = $existingPath -replace [regex]::Escape($Path), ''
    [Environment]::SetEnvironmentVariable('Path', $updatedPath, 'Machine')
}

# Avoid ssh error using poetry install
# [WinError 1312] A specified logon session does not exist. It may already have been terminated
$env:PYTHON_KEYRING_BACKEND = "keyring.backends.null.Keyring"

if ($env:USERNAME -like "t*") {
    PrependToUserPath ("C:\data\nautilus_trader")
    PrependToUserPath ("C:\data\pytower")
}
elseif ($env:USERNAME -like "g*")  {
    PrependToUserPath (Join-Path $env:USERPROFILE "BU/projects/nautilus_trader")
    PrependToUserPath (Join-Path $env:USERPROFILE "BU/projects/pytower")
}

# Get parent of script, follow symlink if needed
if (((Get-Item -Force -Path $PSCommandPath).LinkType) -eq "SymbolicLink") {
    $PARENT = Split-Path (Get-Item -Force -Path $PSCommandPath).Target
} else {
    $PARENT = Split-Path $PSCommandPath
}
PrependToUserPath $PARENT
# Write-Host $PARENT

# to fix a build error when ssh'ed on all window comps
#PrependToUserPath "Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um/"
#PrependToUserPath "Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\arm64"