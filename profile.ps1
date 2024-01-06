# Get parent of script, follow symlink if needed
if (((Get-Item -Force -Path $PSCommandPath).LinkType) -eq "SymbolicLink") {
    $PARENT = Split-Path (Get-Item -Force -Path $PSCommandPath).Target
} else {
    $PARENT = Split-Path $PSCommandPath
}

. (Join-Path $PARENT "_shared.ps1")

function re {
    . $PROFILE
    refreshenv
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
    # pl -Type Machine
    param(
        [string]$Type = "User" # or Machine
    )
    [Environment]::GetEnvironmentVariable("PATH", $Type).Split(";")
}
function plm {
    pl -Type Machine
}
function plu {
    pl -Type User
}

function restart {
    Restart-Computer -Force
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

# DONT use act as alias - overrides act - run github actions locally
function venv_activate() {
    . ./.venv/Scripts/activate
}

function rmpath {
    # rmpath -Path C:\Users\g1\AppData\Local\Microsoft\WindowsApps -Type User
    param(
        [string]$Path,
        [string]$Type = "User" # or Machine
    )
    $existingPath = [Environment]::GetEnvironmentVariable('PATH', $Type)
    
    if (-not ($existingPath -split ';' -contains $Path)) {
        Write-Host ([String]::Format("Directory {0} not found on {1} PATH...", $Path, $Type))
        continue
    }

    $items = [System.Collections.ArrayList]($existingPath -split ';')

    Write-Host ([String]::Format("Removing {0}...", $Path))
    while ($items -contains $Path) {
        $items.Remove($Path)  # only removes first occurence
    }
    
    # $items.RemoveAll("")
    # $items.Remove("\n")
    # $items.RemoveAll(";")

    # Write-Host "Start"
    # $items | ? { Write-Host $_ }

    $updatedPath = ($items -join ";").Trim(";")
    # Write-Host $updatedPath

    [Environment]::SetEnvironmentVariable('PATH', $updatedPath, $Type)
}

# Powershell does not find .ps1 files on path automatically. Use this command to run the file.
function run($filename) {
    & (Join-Path $PARENT ($filename.replace(".ps1", "") + ".ps1"))
}

function which($filename) {
    Get-Command $filename
}

function reset_python() {
    # choco uninstall pyenv-win -y
    # Self-elevate the script if required
    elevate;
    if (-not ((pyenv install --list) -contains "3.10.11")) {
        pyenv update # update available python versions in the list (pyenv install --list)
    }
    pyenv uninstall -f 3.10.11
    pyenv install 3.10.11 --skip-existing  # Skip if the version appears to be installed already
    pyenv global 3.10.11
    pip install --upgrade pip # & (pyenv which python) -m 
    pip install poetry  # install poetry in pyenv python & (pyenv which python) -m 
    refreshenv
    if (Test-Path (Get-Command "poetry" -ErrorAction SilentlyContinue)) {
        Write-Host "Poetry installed successfully..."
    }
    if (Test-Path (Get-Command "pyenv" -ErrorAction SilentlyContinue)) {
        Write-Host "Poetry installed successfully..."
    }
    poetry config virtualenvs.in-project true
    poetry config virtualenvs.create true
    poetry config virtualenvs.prefer-active-python true  # make poetry use pyenv python version
    poetry config virtualenvs.options.always-copy true
    
    # Write-Host (Join-Path $env:USERPROFILE ".pyenv")
    # Remove-Item -Recurse -Force -Path "C:\Users\g1\.pyenv"
    
    # return
    # choco install --force pyenv-win -y
    # refreshenv
    
    # if (-not ((pyenv install --list) -contains "3.10.11")) {
    #     pyenv update # update available python versions in the list (pyenv install --list)
    # }

    # pyenv uninstall -f 3.10.11
    # pyenv install 3.10.11
    # # pyenv rehash  # Rehash pyenv shims (run this after installing executables)
    # pyenv global 3.10.11
    # pip install poetry  # install poetry in pyenv python
    # pip install --upgrade pip
    # refreshenv

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
        refreshenv
        Write-Host "Directory prepended to PATH: $directory"
    }
    else {
        Write-Host "Directory already exists in PATH: $directory"
    }
}

function PrependToPythonUserPath($directory) {
    if (-not (Test-Path -Path $directory -PathType Container)) {
        Write-Host "Directory does not exist: $directory"
        return
    }
    
    $existingPath = [Environment]::GetEnvironmentVariable("PYTHONPATH", "User")
    
    if (-not ($existingPath -split ';' -contains $directory)) {
        $newPath = "$directory;$existingPath"
        [Environment]::SetEnvironmentVariable("PYTHONPATH", $newPath, "User")
        refreshenv
        Write-Host "Directory prepended to PYTHONPATH: $directory"
    }
    else {
        Write-Host "Directory already exists in PYTHONPATH: $directory"
    }
    
}

# Avoid ssh error using poetry install
# [WinError 1312] A specified logon session does not exist. It may already have been terminated
$env:PYTHON_KEYRING_BACKEND = "keyring.backends.null.Keyring"

# PrependToPythonUserPath (Join-Path $env:USERPROFILE "BU/projects/nautilus_trader")
# PrependToUserPath (Join-Path $env:USERPROFILE "BU/projects/nautilus_trader")

# PrependToPythonUserPath (Join-Path $env:USERPROFILE "BU/projects/pytower")
# PrependToUserPath (Join-Path $env:USERPROFILE "BU/projects/pytower")

# if ($env:USERNAME -like "t*") {
#     PrependToPythonUserPath ("C:\data\nautilus_trader")
#     PrependToPythonUserPath ("C:\data\pytower")
# }
# elseif ($env:USERNAME -like "g*")  {
    
# }

# to fix a build error when ssh'ed on all window comps
#PrependToUserPath "Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um/"
#PrependToUserPath "Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\arm64"
