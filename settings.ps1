# start tailscale at login before user login screen (requires the service to be installed on the system.)
# This DID NOT WORK on office-win
# Set-Service -Name Tailscale -StartupType Automatic -Description "Runs in unattended mode"

# git config --global applies configuration on the user level
pyenv install 3.10 --skip-existing  # Skip if the version appears to be installed already
pyenv global 3.10

poetry config virtualenvs.in-project true

# using direnv so not neccessary to create the virtual environments
# nautilus build fails with a direnv environment, maybe because python interpreter is aliased?
poetry config virtualenvs.create true

# make poetry use pyenv python version
poetry config virtualenvs.prefer-active-python true
poetry config virtualenvs.options.always-copy true

rustup default stable

git config --global --add safe.directory ~/BU/projects/nautilus_trader
git config --global --add safe.directory ~/BU/projects/pytower

if ($env:USERNAME -eq "g1") {
    git config --global user.email "georgehill010@gmail.com"
    git config --global user.name "George Hill"
}
elseif ($env:USERNAME -eq "t1") {
    git config --global user.email "tomhill000@gmail.com"
    git config --global user.name "squire-of-milverton"
}
elseif ($env:USERNAME -eq "f1") {
    git config --global user.email "freddiehill000@gmail.com"
    git config --global user.name "Frederick Hill"
}


