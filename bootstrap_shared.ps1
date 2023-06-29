# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# Show Hidden Files, Protected OS Files and File Extensions in Explorer
Write-Output "Configuring explorer (show hidden files / folders, protected OS files and file extensions)..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key ShowSuperHidden 1
# Stop-Process -processname explorer
Write-Output "Done."

# Enable SSH client
Write-Output "Installing OpenSSH.Client..."
$capability = Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Client*"
Write-Information $capability

if ($capability.State -ne "Installed") {
    Write-Information "Installing OpenSSH client"
    Add-WindowsCapability -Online -Name $capability.name  # if SSH client is not installed, install it.
    
    # Generate ssh key for github: do not specify a directory, because if default location is used (~/.ssh/id_rsa) ssh-keygen will make the directory.
    # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=windows
    Write-Information "Generating SSH Keygen - Hit Enter if nothing is displayed..."
    Get-Service ssh-agent | Start-Service
    ssh-keygen -t ed25519 # could support email address here
    Write-Output "Created ssh key in ~/.ssh/ - Displaying PUBLIC key to copy into your github account. https://github.com/settings/ssh"
    Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
    # to troubleshoot: ssh-add -l -> after this command, the key should be listed in the output
    ssh-add ~/.ssh/id_ed25519  # add ssh key to the ssh-agent

} else {
    Write-Information "OpenSSH client installed allready..."
}
# make sure SSH client is running and set to StartupType Automatic
Get-Service ssh-agent | Set-Service -StartupType Automatic
Get-Service ssh-agent | Start-Service



# Install chocolatey (just exits if installed)
winrm quickconfig  # WinRM firewall exception will not work since one of the network connection types on this machine is set to Public. Change the network connection type to either Domain or Private and try again. Disable Hyper-V and Ethernet adapter to fix this.
Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 16384
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Set the hostname Note: Renaming the computer requires administrative privileges, so make sure you are running PowerShell as an administrator.
$hostname = Read-Host -Prompt 'Enter the new hostname or Ctrl-C to cancel'
Rename-Computer -NewName $hostname -Force



