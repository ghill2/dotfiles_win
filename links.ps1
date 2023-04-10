"""
Microsoft Terminal and VSCode are windows apps, the config files live on windows side.

How to Install:
1) Open powershell as administrator
2) cd to \\wsl$\alpina\data\config\install
3) .\links.ps1

NOTE: 
It finds the setting files for vscode and terminal in the parent directory.
If you change the location o this script, make sure to change parent/gparent.
"""

$scriptpath = $MyInvocation.MyCommand.Path
$parent = Split-Path $scriptpath
$gparent = Split-Path $parent
cd $gparent

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

$dest = 'C:\Users\g1\AppData\Local\Microsoft\Windows Terminal\settings.json'
Remove-Item $dest
New-Item -ItemType SymbolicLink -Target '.\terminal_settings.json' -Path $dest


$FolderName = 'C:\AA\dev\config\apps\VSCode\data\user-data\User'
if (Test-Path $FolderName) {
}
else
{
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}


$dest = 'C:\AA\dev\config\apps\VSCode\data\user-data\User\settings.json'

# If file exists
if (Get-Item -Path $dest -ErrorAction Ignore) {
    Remove-Item $dest
}

New-Item -ItemType SymbolicLink -Target '.\vscode_settings.json' -Path $dest

$dest = 'C:\AA\dev\config\apps\VSCode\data\user-data\User\keybindings.json'

# If file exists
if (Get-Item -Path $dest -ErrorAction Ignore) {
    Remove-Item $dest
}

New-Item -ItemType SymbolicLink -Target '.\vscode_keybindings.json' -Path $dest 

cd $parent