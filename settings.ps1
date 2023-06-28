$PARENT = (Get-Item -Force -Path $MyInvocation.MyCommand.Path).Target | ForEach-Object { if ($_ -eq $null) { Split-Path $MyInvocation.MyCommand.Path } else { Split-Path $_ } }

# start tailscale at login before user login screen (requires the service to be installed on the system.)
# This DID NOT WORK on office-win
# Set-Service -Name Tailscale -StartupType Automatic -Description "Runs in unattended mode"


# git config --global applies configuration on the user level
if ($env:USERNAME -eq "g1") {
    git config --global user.email "georgehill010@gmail.com"
    git config --global user.name "ghill2"
}
elseif ($env:USERNAME -eq "t1") {
    git config --global user.email "tomhill000@gmail.com"
    git config --global user.name "squire-of-milverton"
}
elseif ($env:USERNAME -eq "f1") {
    git config --global user.email "freddiehill000@gmail.com"
    git config --global user.name "Frederick Hill"
}


