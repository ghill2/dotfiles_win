# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# Install chocolatey
# if chocolatey is not installed, this does not reinstall chocolatey, it exits
winrm quickconfig  # WinRM firewall exception will not work since one of the network connection types on this machine is set to Public. Change the network connection type to either Domain or Private and try again. Disable Hyper-V and Ethernet adapter to fix this.
Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 16384
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Set the hostname Note: Renaming the computer requires administrative privileges, so make sure you are running PowerShell as an administrator.
$hostname = Read-Host -Prompt 'Enter the new hostname or Ctrl-C to cancel'
$computer = Get-WmiObject -Class Win32_ComputerSystem
Rename-Computer $computer.Rename($hostname)

