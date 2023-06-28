$PARENT = (Get-Item -Force -Path $MyInvocation.MyCommand.Path).Target | ForEach-Object { if ($_ -eq $null) { Split-Path $MyInvocation.MyCommand.Path } else { Split-Path $_ } }
$GPARENT = Split-Path $PARENT

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

function Create-SymbolicLink {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination
    )

    if (!(Test-Path -Path $Source -PathType Leaf)) {
        throw "Source file does not exist."
    }

    # $linkName = Join-Path -Path $Destination -ChildPath (Split-Path -Path $Source -Leaf)

    # Use the -Force parameter to attempt to recreate folders
    # Use the -Force parameter to overwrite existing files
    # New-Item -Path $linkName -ItemType SymbolicLink -Value $Source -Force
    Write-Output ("{0} > {1}" -f $Source, $Destination)
    New-Item -ItemType SymbolicLink -Target $Source -Path $Destination  -Force
}


Create-SymbolicLink `
    -Source (Join-Path $GPARENT "profile.ps1") `
    -Destination $PROFILE.CurrentUserCurrentHost
    # -Destination (Join-Path -Path $Home -ChildPath 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1')
    
Create-SymbolicLink `
    -Source (Join-Path $GPARENT ".bashrc") `
    -Destination (Join-Path $Home ".bashrc")
    
# TODO pull settings.json, terminal_settings.json from mac dotfiles

# Create-SymbolicLink -Source '.\terminal_settings.json' -Destination 'C:\Users\g1\AppData\Local\Microsoft\Windows Terminal\settings.json'
# Create-SymbolicLink -Source '.\vscode_settings.json' -Destination 'C:\AA\dev\config\apps\VSCode\data\user-data\User\settings.json'
# Create-SymbolicLink -Source '.\vscode_keybindings.json' -Destination 'C:\AA\dev\config\apps\VSCode\data\user-data\User\keybindings.json'
    
# TODO
# $FolderName = 'C:\AA\dev\config\apps\VSCode\data\user-data\User'
# if (Test-Path $FolderName) {
# }
# else
# {
#     #PowerShell Create directory if not exists
#     New-Item $FolderName -ItemType Directory
#     Write-Host "Folder Created successfully"
# }

# # Overwrite symbolic links
# if (Test-Path -Path $linkName -PathType Leaf) {
#     Remove-Item -Path $linkName -Force
#     # throw "Symbolic link already exists at the destination."
# }

# if (!(Test-Path -Path $Destination -PathType Container)) {
#     throw "Destination directory does not exist."
# }