# Installation script instructions

Execute the following steps to set up your machine for the Puma workshop. Isntall Android Studio first as this takes the
longest:
1. Install Android Studio, download it here: https://redirector.gvt1.com/edgedl/android/studio/install/2024.3.1.13/android-studio-2024.3.1.13-windows.exe
2. Setup an Android emulator:
   * when opening Android Studio, in the `Welcome to Android studio` window, click on `More actions`
   * click on virtual device manager
   * click the `+``symbol to add a new device
   * follow the steps to add a new device. Pick any phone model you like. When picking a system image, choose one with Google APIs.
3. Install a Python IDE. We recommend Pycharm, but if you have a preference, use the one you like.
4. Run the Puma install script for your OS (`install_windows.bat`, `install_linux.sh` or `install_macos.sh`)

The script should install all requirements for Puma, and checks out the Puma workshop repository in the scripts
directory on windows, or in your home directory on MacOS and Linux.

## Offline functionality
Where possible, the scripts support using installation files. Which files depend on the OS.
When the required file with the correct name is placed next to the script, nothing will be downloaded.

### Windows
* ADB platform tools: platform-tools.zip
* Git installer: git-installer.exe
* NodeJS installer: node-installer.msi
* Python installer: python-installer.exe
* Appium inspector: Appium-Inspector.exe

### MacOS
* Appium inspector: Appium-Inspector.dmg
