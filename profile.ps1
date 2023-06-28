$PARENT = (Get-Item -Force -Path $MyInvocation.MyCommand.Path).Target | ForEach-Object { if ($_ -eq $null) { Split-Path $MyInvocation.MyCommand.Path } else { Split-Path $_ } }
$GPARENT = Split-Path $PARENT

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
    $Env:Path.Split(";")
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

$env:PYTHON_KEYRING_BACKEND = "keyring.backends.null.Keyring"


PrependToUserPath (Join-Path $env:USERPROFILE "BU/projects/nautilus_trader")
PrependToUserPath (Join-Path $env:USERPROFILE "BU/projects/pytower")
PrependToUserPath (Join-Path $PARENT "bin")


# nautilus_persistence_g.lib(std-391022a4250a8b9a.std.feb3b897-cgu.0.rcgu.o) : error LNK2001: unresolved external symbol __imp_RtlNtStatusToDosError
# nautilus_persistence_g.lib(std-391022a4250a8b9a.std.feb3b897-cgu.0.rcgu.o) : error LNK2001: unresolved external symbol __imp_NtReadFile
# nautilus_persistence_g.lib(std-391022a4250a8b9a.std.feb3b897-cgu.0.rcgu.o) : error LNK2001: unresolved external symbol __imp_NtWriteFile
PrependToUserPath "Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um/"
PrependToUserPath "Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\arm64"

# $Prompt = "$PWD $env:USERNAME> "


# $Env:Path.Split(';');