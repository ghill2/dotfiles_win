Configuration myChocoConfig
{
   Import-DscResource -Module cChoco
   Node "localhost"
   {
      cChocoInstaller installChoco
      {
        InstallDir = "c:\choco"
      }
      cChocoPackageInstallerSet installSomeStuff
      {
         Ensure = 'Present'
         Name = @(
			"git"
			"microsoft-windows-terminal"
         # "rust" # using rustup instead, dont' have both.
         "linkshellextension"
         "lockhunter"
         "resilio-sync-home"
         "7zip"
         "autohotkey"
         "directoryopus" # view file sizes
         "googlechrome"
         "notepadplusplus" # open large csv files
         "docker-desktop" # use with act. failed one first install, re-run this script again
         "wsl2" # needed for docker desktop to use wsl
         "act-cli"
         "rsync"
         "slack"
         "everything"
         "es" # everything CLI
         "rustup.install" # needed to install rust targets: rust not needed if rustup is installed. rustup target add x86_64-pc-windows-msvc
         # "pyenv-win"
         "pycharm"
         # "nodejs-lts"
         "cmake"
         "llvm" # nautilus needs clang to build
         "firefox"
		)
         DependsOn = "[cChocoInstaller]installChoco"
      }
      cChocoPackageInstaller visualstudio2019buildtools
      {
         Name     = "visualstudio2019buildtools"
         Version  = "16.11.15.0"
         Source   = "http://internal/odata/repo"
      }
      cChocoPackageInstaller visualstudio2019-workload-vctools
      {
         Name     = "visualstudio2019-workload-vctools"
         Version  = "1.0.1"
         Source   = "http://internal/odata/repo"
      }
      cChocoPackageInstaller nodejs
      {
         Name     = "nodejs"
         Version  = "16.14.2" # avoid ERR_OSSL_EVP_UNSUPPORTED error
         # Source   = "http://internal/odata/repo"
      }
      cChocoPackageInstaller installPythonSpecificVersion
      {
         Name = "python"
         Version              = "3.10.8"
      }
      # cChocoPackageInstaller github-desktop
      # {
      #    Name     = "github-desktop"
      #    Version  = "3.0.0"
      #    # Source   = "http://internal/odata/repo"
      # }
      # cChocoPackageInstaller memurai-developer.install
      # {
      #    Name     = "memurai-developer.install"
      #    Version  = "2.0.5"
      #    # Source   = "http://internal/odata/repo"
      # }
   }
}

# TODO how to set this programatically?

Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 16384

myChocoConfig

# needed after error encountered
winrm quickconfig

# might be needed to avoid install error


# Install choco DSC
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force;
# Install-Module cChoco;
# Make sure the cChoco DSM module is installed. Use installChoco to install it

# Set-ExecutionPolicy Bypass -Scope Process -Force
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force;


# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# NOT sure why running all of these worked from a fresh install?
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

Start-DscConfiguration .\myChocoConfig -wait -Verbose -force

refreshenv
