# start tailscale at login before user login screen (requires the service to be installed on the system.)
# This DID NOT WORK on office-win
# Set-Service -Name Tailscale -StartupType Automatic -Description "Runs in unattended mode"

# git config --global applies configuration on the user level

# use pyenv install --list to list the available pyenv versions

# Install poetry - using package manager
# Poetry need python to install, must be after pyenv
# You can uninstall at any time by executing this script with the --uninstall option, and these changes will be reverted.
# to uninstall use: (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing ).Content | python - --uninstall

# # To get started you need Poetry's bin directory (C:\Users\g1\AppData\Roaming\Python\Scripts) in your `PATH`
# # environment variable.
# (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
# refreshenv


# Installs the default toolchain to compile rust libraries (msvc for windows)
rustup default stable

if ($env:USERNAME -like "g*") {
    git config --global --add safe.directory ~/BU/projects/nautilus_trader
    git config --global --add safe.directory ~/BU/projects/pytower
    git config --global user.email "georgehill010@gmail.com"
    git config --global user.name "George Hill"
}
elseif ($env:USERNAME -like "t*") {
    git config --global --add safe.directory /data/pytower
    git config --global --add safe.directory /data/pytower
    git config --global user.email "tomhill000@gmail.com"
    git config --global user.name "squire-of-milverton"
}
elseif ($env:USERNAME -like "f*") {
    git config --global --add safe.directory ~/BU/projects/nautilus_trader
    git config --global --add safe.directory ~/BU/projects/pytower
    git config --global user.email "freddiehill000@gmail.com"
    git config --global user.name "Frederick Hill"
}

# Install pyenv and poetry
# Self-elevate the script if required, needed to add poetry to PATH
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}
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

poetry config virtualenvs.in-project true
poetry config virtualenvs.create true
poetry config virtualenvs.prefer-active-python true  # make poetry use pyenv python version
poetry config virtualenvs.options.always-copy true