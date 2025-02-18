REM First, install the git commit template properly
git config commit.template helpers/commit.txt
ECHO "Setup commit template successfully"

REM First, download and install choco installer.
ECHO "Downloading Choco Package Manager"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
ECHO "Downloaded Choco Installer"

REM Second, install flutter version management.
choco install fvm

REM Third, initialize fvm and install Flutter stable.
ECHO "Activating Flutter Version Manager"
flutter pub global activate fvm
fvm install stable
fvm use stable

REM Fourth, run the build script for good measure.
ECHO "Running Code First CodeGen"
build.bat
