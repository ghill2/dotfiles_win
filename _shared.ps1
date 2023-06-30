# Read the contents of the packages.txt file
# excludes lines starting with #
# trims comment from end
# excludes lines that are only new line characters
function ReadLines {
    param (
        [string]$Path
    )
    Get-Content -Path $Path `
        | ForEach-Object { $_.Trim() } `
        | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' } `
        | ForEach-Object {
            $lastIndex = $_.LastIndexOf("#")
            if ($lastIndex -ge 0) {
                $_.Substring(0, $lastIndex)
            } else {
                $_
            }
        } `
        | ForEach-Object { $_.Trim() }
}

function elevate {
    # Self-elevate the script if required
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
            Exit
        }
    }
}
