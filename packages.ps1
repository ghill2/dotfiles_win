$PARENT = Split-Path $MyInvocation.MyCommand.Path
$GPARENT = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
. "$PARENT/shared.ps1"  # import ReadLines method

# enable windows features with chocolatey

# Read the contents of the packages.txt file
# excludes lines starting with # and trims comment from end and excludes lines that are only new line characters
$definedPackages = ReadLines -Path (Join-Path $GPARENT "packages.txt")

# Install each package
$installedPackages = (choco list --local-only --id-only --limit-output)
foreach ($definedPackage in $definedPackages) {

    # $isInstalled = ($definedPackage -notin $installedPackages)
    # Write-Host ($definedPackage -notin $installedPackages)
    # Write-Host (($definedPackage -notin $installedPackages) + " " + $definedPackage)
    if ($definedPackage -notin $installedPackages) {
        Write-Host ([String]::Format("Package {0} is not installed", $definedPackage))
        choco install $definedPackage -y
    } else {
        Write-Host ([String]::Format("Package {0} is installed", $definedPackage))
    }
}
# Get packages without --version


# $quotedString = "'" + $trimmedPackages + "'"

# echo $installedPackages

# Uninstall packages not in specification
foreach ($installedPackage in $installedPackages) {

    $isDefined = $installedPackage -in $definedPackages `
                 -or $installedPackage.Replace(".install", "") -in $definedPackages
    if ($isDefined) {
        continue
    }
    Write-Host ($installedPackage + " " + $isDefined)
    
    try {
        choco uninstall $installedPackage --yes --forcedependencies >$null
        #  -ErrorAction SilentlyContinue
    } catch {
        # $errorOutput = $Error[0].Exception
        # .Message
        Write-Host $Error[0].Exception.Message
        #Write-Host $Error[0].Exception.FullyQualifiedErrorId # | gm
    }
    
    # Exit
    # echo (choco uninstall $package --yes --whatif)
    # if package is dependent on another package, ignore it
    # if ($installedPackage == "vcredist140")
    # choco uninstall $package --yes --forcedependencies
    # echo $installedPackage

    # if ($package -notin $packages) {
    #     Write-Host ([String]::Format("Package {0} is not in the list", $package))
    #     # --forcedependencies: uninstall dependencies when uninstalling package(s). The default behavior is not to uninstall dependencies.
    #     choco uninstall $package --yes --forcedependencies
    # }
    # else {
    #     # Write-Host "Item is in the list."
    # }
}

# $trimmedPackages = (
#                     $definedPackages `
#                         | ForEach-Object {
#                             $lastIndex = $_.LastIndexOf(" --version")
#                             if ($lastIndex -ge 0) {
#                                 $_.Substring(0, $lastIndex)
#                             } else {
#                                 $_
#                             }
#                         } `
#                         | ForEach-Object { $_.Trim() } `
#                 ) -join ","

# $package = $package.TrimEnd("#")
# echo $package.TrimEnd("#")
# $trimmedString = ($string -split "#")
# echo $package
# choco uninstall all --yes --uninstallargs="'/qn'" $package
# choco uninstall all --yes --uninstallargs="'/qn'" --except=$quotedString

# echo '\n'
# echo $trimmedPackages
# Run the uninstallation command with the constructed --except argument
# choco uninstall all --yes --uninstallargs="'/qn'" $exceptArgument



                
                
                # | ForEach-Object { $_.Substring(0, $_.IndexOf("#")) }

# $packageList = $packages -join ","
# echo $packageList
# choco install $packageList

# $packages = Get-Content -Path (Join-Path $PARENT "packages.txt") |
#     Where-Object { $_ -notmatch '^\s*#' } |
#     ForEach-Object {
#         $index = $_.IndexOf(",")
#         if ($index -ge 0) {
#             $_ = $_.Substring(0, $index)
#         }
#         $_ -replace '--version$'
#     }

#  | ForEach-Object { if ($_ -notmatch '^\s*$' -and $_ -notmatch '^\s*#') { $_ -replace '\s*#.*$' } }


# $packages = Get-Content -Path (Join-Path $PARENT "packages.txt") | ForEach-Object { $_ -replace '\s*#.*$' }
# Uninstall packages
# foreach ($package in $packages) {
#     $exceptArgument += "$package,"
# }

# Trim the word --version from each package in the $packages variable
# $trimmedPackages = $packages | ForEach-Object { $_.TrimEnd("--version") }


# echo $trimmedPackages
# $installedPackages = choco list --local-only --no-color

# $installedPackages = choco list --local-only --no-color `
#                     | ForEach-Object {
#                         $_.Split(" ")[0]
#                     }