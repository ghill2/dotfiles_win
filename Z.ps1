
    
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



# nautilus_persistence_g.lib(std-391022a4250a8b9a.std.feb3b897-cgu.0.rcgu.o) : error LNK2001: unresolved external symbol __imp_RtlNtStatusToDosError
# nautilus_persistence_g.lib(std-391022a4250a8b9a.std.feb3b897-cgu.0.rcgu.o) : error LNK2001: unresolved external symbol __imp_NtReadFile
# nautilus_persistence_g.lib(std-391022a4250a8b9a.std.feb3b897-cgu.0.rcgu.o) : error LNK2001: unresolved external symbol __imp_NtWriteFile

# $commands = ReadLines -Path (Join-Path $PARENT "settings")
# echo $commands
# Specify the path to the text file containing commands
# $filePath = "$PARENT\settings"