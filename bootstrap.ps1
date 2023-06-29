# https://github.com/soda3x/windows-bootstrap/blob/main/elevated-bootstrap.ps1

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# Enable SMB
Write-Output "Enabling SMB..."
Enable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart
Set-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)" -Profile Private -Enabled True
Set-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)" -Profile Public -Enabled True  # CAUTION!

# Enable automatic lock
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value 60 * 10  # in seconds

# Disable automatic logout
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogoffCountdown" -Name "AutoLogoffCountdown" -Value 0

# Turn off UAC
Write-Output "Turning off UAC..."
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
Write-Output "Done."

# Enable SSH server
Write-Output "Installing OpenSSH.Server..."
$capability = Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Server*"
Write-Information $capability
if($capability.State -ne "Installed") {
    Write-Information "Installing OpenSSH server"
    Add-WindowsCapability -Online -Name $capability.Name
    # sc config sshd start=auto # start server automatically
} else {
    Write-Information "OpenSSH server installed"
}
Get-Service sshd | Set-Service -StartupType Automatic
Get-Service sshd | Start-Service

# Set the default shell to powershell for SSH
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# This command enables PowerShell remoting and allows the current session to have the necessary privileges for running commands with different user credentials.
enable-psremoting -force

# Adds the user g1 to Remote Desktop Connections
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0  # modifies a registry value to enable Remote Desktop connections.
Set-NetFirewallRule -DisplayGroup "Remote Desktop" -Enabled True  # allow Remote Desktop through the Windows Firewall:
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $env:USERNAME  # add the current user to the local Remote Desktop Users group:

# execute the script within the current PowerShell session
& "$PARENT/bootstrap_shared.ps1"

# Install pyenv - using package manager
# Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
# refreshenv

# CAUSED SSH in VSCODE TO CRASH. KEEP AS POWERSHELL
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\Git\bin\bash.exe" -PropertyType String -Force

# Write default config NOT NEEDED! password authentication enabled by default.
# $file = "C:\ProgramData\ssh\sshd_config"
# if (-not (Test-Path -Path $file)) {
#     $text = "PasswordAuthentication yes"
#     $text | Out-File -FilePath $file -Encoding UTF8
# }

# Install Powershell 5: not needed, Windows 11 ships with version 5.1
# Install PowerShell
# Install-Module -Name PowerShellGet -Force -AllowClobber -SkipPublisherCheck
# Install-Package -Name PowerShell -ProviderName PowerShellGet -Force -AllowClobber
# Set-Alias -Name powershell -Value pwsh
# refreshenv
# $PSVersionTable.PSVersion # To verify that you are using the latest version of PowerShell, you can run the following command:


# Make sure the cChoco DSM module is installed. Use installChoco to install it

# Set-ExecutionPolicy Bypass -Scope Process -Force
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force;


# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# NOT sure why running all of these worked from a fresh install?
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
# # Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# # Enable Hyper-V:
# Write-Output "Turning on Hyper-V..."
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
# Write-Output "Done."

# # Enable WSL:
# Write-Output "Turning on WSL..."
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
# Write-Output "Done."

# $sshd = Get-Service sshd
# if($sshd.Status -eq "Stopped") {$sshd | Start-Service}
# if($sshd.StartType -eq "Disabled") {$sshd | Set-Service -StartupType Automatic }

# $sshAgent = Get-Service ssh-agent
# if($sshAgent.Status -eq "Stopped") {$sshAgent | Start-Service}
# if($sshAgent.StartType -eq "Disabled") {$sshAgent | Set-Service -StartupType Automatic }

# Get the PowerShell version: Get-Host | Select-Object Version

# Install-Module -Name chocolatey-vscode # install vscode extensions with chocolatey
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force;
# Install-Module cChoco;  # using install script for uninstallation support


