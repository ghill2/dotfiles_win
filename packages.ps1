$PARENT = Split-Path $MyInvocation.MyCommand.Path
$GPARENT = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
. "$PARENT/_shared.ps1"  # import ReadLines method

# enable windows features with chocolatey

# Read the contents of the packages.txt file
# excludes lines starting with # and trims comment from end and excludes lines that are only new line characters
$definedPackages = ReadLines -Path (Join-Path $PARENT "packages.txt")

# Install each package
$installedPackages = (choco list --local-only --id-only --limit-output)
foreach ($definedPackage in $definedPackages) {
    if ($definedPackage -notin $installedPackages) {
        Write-Host ([String]::Format("Package {0} is not installed", $definedPackage))
        choco install $definedPackage -y
    } else {
        Write-Host ([String]::Format("Package {0} is installed", $definedPackage))
    }
}
# Uninstall packages not in specification
# foreach ($installedPackage in $installedPackages) {

#     $isDefined = $installedPackage -in $definedPackages `
#                  -or $installedPackage.Replace(".install", "") -in $definedPackages
#     if ($isDefined) {
#         continue
#     }
#     Write-Host ("Uninstalling package: " + $installedPackage)
    
#     try {
#         choco uninstall $installedPackage --yes --forcedependencies >$null
#     } catch {
#         Write-Host $Error[0].Exception.Message
#     }

# }

