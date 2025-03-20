# Installation script instructions
The installation scripts aim to make Puma setup easier. Simply run the script of your OS, and everything should be
installed.
Please install **Android Studio first**, as this takes the longest.

## Offline functionality
Where possible, the scripts support using installation files. Which files depend on the OS.
When the required file with the correct name is placed next to the script, nothing will be downloaded.

### Windows
* ADB platform tools: platform-tools.zip
* Python installer: python-installer.exe
* Git installer: git-installer.exe
* NodeJS installer: node-installer.msi

### MacOS
* Appium inspector: Appium-Inspector.dmg

# Workshop-specific steps
In this fork, the installation scripts contain some specific steps that are only relevant to the workshop:
* Setup of Jupyter notebook settings
* Installation of GIT
* Checkout of the workshop branch

The script is supposed to be used by users that haven't done any setup, not even checking out the git repository. The
script will do this for them.

## Required files
Apart from the scripts, the workshop setup should be done with some extra files:

* PyCharm installer (or other IDE)
* Android Studio installer

* All installation mentioned above files to maximize offline functionality
