# Installs choco and cChoco DSM module so can use package definition file. (choco.ps1)

Set-ExecutionPolicy Bypass -Scope Process -Force; `
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Disable Hyper-V  and Ethernet adapter to fix this
# avoid winrm quick config error
#  WinRM firewall exception will not work since one of the network connection types on this machine is set to Public. Change the network connection type to either Domain or Private and try again.
Enable-PSRemoting -SkipNetworkProfileCheck -Force


# install DSC cChoco Mod
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force;
Install-Module cChoco;


# TODO: MAKE SURE TO ADD C:\choco\bin to path