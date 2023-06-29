# start tailscale at login before user login screen (requires the service to be installed on the system.)
# This DID NOT WORK on office-win
# Set-Service -Name Tailscale -StartupType Automatic -Description "Runs in unattended mode"

# git config --global applies configuration on the user level

# use pyenv install --list to list the available pyenv versions
pyenv update (pyenv --version) # update available python versions in the list (pyenv install --list)
pyenv install 3.10.11 --skip-existing  # Skip if the version appears to be installed already
pyenv global 3.10.11

poetry config virtualenvs.in-project true
poetry config virtualenvs.create true
poetry config virtualenvs.prefer-active-python true  # make poetry use pyenv python version
poetry config virtualenvs.options.always-copy true

rustup default stable

if ($env:USERNAME -eq "g1") {
    git config --global --add safe.directory ~/BU/projects/nautilus_trader
    git config --global --add safe.directory ~/BU/projects/pytower
    git config --global user.email "georgehill010@gmail.com"
    git config --global user.name "George Hill"
}
elseif ($env:USERNAME -eq "t1") {
    git config --global --add safe.directory /data/pytower
    git config --global --add safe.directory /data/pytower
    git config --global user.email "tomhill000@gmail.com"
    git config --global user.name "squire-of-milverton"
}
elseif ($env:USERNAME -eq "f1") {
    git config --global --add safe.directory ~/BU/projects/nautilus_trader
    git config --global --add safe.directory ~/BU/projects/pytower
    git config --global user.email "freddiehill000@gmail.com"
    git config --global user.name "Frederick Hill"
}


