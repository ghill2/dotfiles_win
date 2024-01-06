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

. (Join-Path $PSScriptRoot "_shared.ps1")
. (Join-Path $PSScriptRoot "profile.ps1")

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
# TODO, run reset_python from profile.ps1
reset_python


# Docker
# net start com.docker.service


# Docker Desktop needs to be manually opened for it to run


# Installing Jenkins:
# choco install openjdk
# refreshenv
# choco install jenkins
