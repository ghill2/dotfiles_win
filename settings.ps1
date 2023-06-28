$PARENT = (Get-Item -Force -Path $MyInvocation.MyCommand.Path).Target | ForEach-Object { if ($_ -eq $null) { Split-Path $MyInvocation.MyCommand.Path } else { Split-Path $_ } }
$GPARENT = Split-Path $PARENT

# start tailscale at login before user login screen (requires the service to be installed on the system.)
Set-Service -Name Tailscale -StartupType Automatic -Description "Runs in unattended mode"

if ($env:USERNAME -eq "g1") {
    git config --global user.email "georgehill010@gmail.com"
    git config --global user.name "ghill2"
}
elseif ($env:USERNAME -eq "t1") {
    git config --global user.email "tomhill000@gmail.com"
    git config --global user.name "squire-of-milverton"
}

# $commands = ReadLines -Path (Join-Path $PARENT "settings")
# echo $commands
# Specify the path to the text file containing commands
# $filePath = "$PARENT\settings"

