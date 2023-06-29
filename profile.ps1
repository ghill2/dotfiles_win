# Get parent of script, follow symlink if needed
if (((Get-Item -Force -Path $PSCommandPath).LinkType) -eq "SymbolicLink") {
    $PARENT = Split-Path (Get-Item -Force -Path $PSCommandPath).Target
} else {
    $PARENT = Split-Path $PSCommandPath
}

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

function act() {
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
    pyenv update
    pyenv uninstall -f 3.10.11
    pyenv install 3.10.11
    pyenv global 3.10.11
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



# To enable PowerShell to find files or scripts within a directory added to the Path, you can update the PSModulePath environment variable to include the path to your directory.
PrependToUserPath $PARENT

# to fix a build error when ssh'ed on all window comps
#PrependToUserPath "Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um/"
#PrependToUserPath "Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\arm64"