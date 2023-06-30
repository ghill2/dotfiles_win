#!/usr/bin/env sh


# this is a port of the configuration for pyenv configuration on windows.
# convert this to bash, so there is a single setup that can configure all osx and windows comps.


if ! pyenv install --list | grep -q 3.10.11; then
    pyenv update
fi

pyenv uninstall -f 3.10.11
pyenv install 3.10.11 --skip-existing  # Skip if the version appears to be installed already
pyenv global 3.10.11
pip install --upgrade pip # & (pyenv which python) -m 
pip install poetry  # install poetry in pyenv python & (pyenv which python) -m 

if [ -f "$(command -v poetry)" ]; then
    echo "Poetry installed successfully..."
fi

poetry config virtualenvs.in-project true
poetry config virtualenvs.create true
poetry config virtualenvs.prefer-active-python true  # make poetry use pyenv python version
poetry config virtualenvs.options.always-copy true
