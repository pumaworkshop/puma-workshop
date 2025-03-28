# Workshop installation script instructions

Execute the following steps to set up your machine for the Puma workshop. Install Android Studio first as this takes the
longest:
1. Install Android Studio, download it here: https://developer.android.com/studio
2. Setup an Android emulator:
   * when opening Android Studio, in the `Welcome to Android studio` window, click on `More actions`
   * click on virtual device manager
   * click the `+``symbol to add a new device
   * follow the steps to add a new device. Pick any phone model you like. When picking a system image, choose one with Google APIs.
3. Install a Python IDE. We recommend [Pycharm](https://www.jetbrains.com/pycharm/download), but if you have a preference, use the one you like.
4. Run the Puma install script for your OS (`install_windows.bat`, `install_linux.sh` or `install_macos.sh`), which will
install all required dependencies and configure your machine to run Puma.

To install all required dependencies and configure your machine to run Puma, simply run the installation script for your
operating system (`install_windows.bat`, `install_linux.sh` or `install_macos.sh`).

# What does the installation script do?

These scripts will:
1. Install ADB and setup the required environmental values
2. Install NodeJS and Appium
3. Install Python 3.12
4. Install Appium Inspector
5. install git
6. checkout the Puma-workshop project from github and install all requirements in your python virtual environment 

When software is installed (ADB, Node, Appium, Python, Appium Inspector, git), the scripts will only install the missing 
components. Python 3.12 will not be installed if you already have python 3.10, 3.11 or 3.12 installed.  

## ADB and environmental values
Puma needs ADB to be installed and either be available on your path, or on `ANDROID_SDK_ROOT/platform-tools/adb`.
Appium **requires** the environmental values `ANDROID_SDK_ROOT` or `ANDROID_HOME` to be set.

The script will set these values if they aren't already set, and download the latest Android SDK platform tools and
extract them to your home folder (`~/Android/Sdk/platform-tools/adb`) .

## NodeJS and Appium
Puma needs Appium, which is a Node.JS application.
The script will install Node.JS (through NVM on Linux and MacOS) and then use NPM to install Appium globally.

## Python
Puma is tested on Python 3.10, 3.11 and 3.12. The script will install 3.12 if none of these versions are installed.

## Appium inspector
Appium Inspector is a tool that can help you develop new Puma code, either for new apps, or to expand functionality in
existing apps.

On Windows and MacOS, it will be installed as a regular application (through an installer), on Linux a portable binary
will be placed in `~/.appium-inspector/appium-inspector.AppImage` and an alias will be made so you can run it from
the terminal using `appium_inspector`.

## Installing requirements in the python virtual environment
The script will create and activate [a python venv](https://docs.python.org/3/library/venv.html) in the root of this
repository, and then run `pip install -r requirements.txt`.

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
* 
### Linux
* Appium inspector: Appium-Inspector.AppImage