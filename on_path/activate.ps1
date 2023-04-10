#  PIPENV_VENV_IN_PROJECT=1
#
#  [Environment]::SetEnvironmentVariable("PIPENV_VENV_IN_PROJECT", 1, "Machine")
# $env:PIPENV_VENV_IN_PROJECT=1;
# $env:PIPENV_VENV_IN_PROJECT=1
$env:PATH=$(Get-Location);$Env:Path
#$env:PIPENV_VENV_IN_PROJECT=1
# venv\Scripts\activate;
# activate;
# pipenv shell;
# if ($env:PIPENV_ACTIVE -eq 0) {
#     pipenv shell;
# } else {
#     echo "pipenv already active"
# }
# if ($env:PIPENV_ACTIVE -eq 1) {
#      # @TODO: works only on Windows
#     $venv = (($env:VIRTUAL_ENV -split "\\")[-1] -split "-")[0]
#      "[pipenv:$venv] $(Get-Location)> ";
#    } else {
#      "$(Get-Location)$('>' * ($nestedPromptLevel + 1))";
#    }