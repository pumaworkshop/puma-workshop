#!/bin/bash
current_dir=$(dirname "$(realpath "$0")")

#!/bin/bash

# Exit on error
set -e

echo "Starting setup of Android SDK Platform Tools, Node.js, Appium, and Git for macOS..."

# Set environment variables
source "$current_dir"/macos/set_environment_variables.sh
echo $SHELL_PROFILE
#TODO check if shell profile is sourced and can be passed to install git and to install homebrew
# Install Git
"$current_dir"/macos/install_git.sh

#TODO move to homebrew and use $SHELL_PROFILE instead of teh ones below
echo >> /Users/angelina/.zprofile
echo "eval $("/opt/homebrew/bin/brew" shellenv)" >> /Users/angelina/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
## Define installation directories
#HOME_DIR=$HOME
#ANDROID_SDK_DIR=$HOME_DIR/android-sdk
#PLATFORM_TOOLS_DIR=$ANDROID_SDK_DIR/platform-tools
#TEMP_DIR=$(mktemp -d)
#
## Create Android SDK directory
#mkdir -p $ANDROID_SDK_DIR
#
## Download and extract Android SDK Platform Tools
#echo "Downloading Android SDK Platform Tools..."
#PLATFORM_TOOLS_URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
#curl -L $PLATFORM_TOOLS_URL -o $TEMP_DIR/platform-tools.zip
#
#echo "Extracting Platform Tools to $ANDROID_SDK_DIR..."
#unzip -q $TEMP_DIR/platform-tools.zip -d $ANDROID_SDK_DIR
#
#
#
## Install NVM (Node Version Manager)
#echo "Installing NVM..."
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
#
## Source NVM to use it immediately
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#
## Check if nvm is available
#if ! command -v nvm &> /dev/null; then
#    echo "NVM installation may have failed or needs a new terminal session."
#    echo "Please run 'source $SHELL_PROFILE' or open a new terminal before continuing."
#    echo "Then run the script again."
#    exit 1
#fi
#
## Install Node.js v19
#echo "Installing Node.js v19..."
#nvm install 19
#nvm use 19
#nvm alias default 19
#
## Install Appium
#echo "Installing Appium..."
#npm install -g appium
#
## Download and setup Appium Inspector
#echo "Setting up Appium Inspector..."
#APPIUM_INSPECTOR_DIR="$HOME/.appium-inspector"
#mkdir -p $APPIUM_INSPECTOR_DIR
#
## Download Appium Inspector for macOS
#APPIUM_INSPECTOR_URL="https://github.com/appium/appium-inspector/releases/download/v2024.12.1/Appium-Inspector-2024.12.1-mac.dmg"
#APPIUM_INSPECTOR_FILE="$APPIUM_INSPECTOR_DIR/appium-inspector.dmg"
#
#echo "Downloading Appium Inspector for macOS..."
#curl -L $APPIUM_INSPECTOR_URL -o $APPIUM_INSPECTOR_FILE
#
## Mount the DMG file
#hdiutil attach $APPIUM_INSPECTOR_FILE
#
## Copy the Appium Inspector app to the Applications folder
#cp -R /Volumes/Appium-Inspector/Appium\ Inspector.app /Applications/
#
## Unmount the DMG file
#hdiutil detach /Volumes/Appium-Inspector
#
## Clean up temporary files
#echo "Cleaning up temporary files..."
#rm -rf $TEMP_DIR
#
#echo "Installation complete!"
#echo "To verify the installation, please open a new terminal and run:"
#echo "- adb version (to check Android SDK Platform Tools)"
#echo "- node -v (to check Node.js version - should be v19.x.x)"
#echo "- appium -v (to check Appium version)"
#echo "- open -a 'Appium Inspector' (to launch Appium Inspector)"
#echo "- git --version (to check Git version)"
