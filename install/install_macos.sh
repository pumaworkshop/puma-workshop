#!/bin/bash
current_dir=$(dirname "$(realpath "$0")")

# Exit on error
set -e

echo "Starting setup of Android SDK Platform Tools, Node.js, Appium, and Git for macOS..."

# Set environment variables
#"$current_dir"/macos/set_environment_variables.sh TODO move to adb.sh
# Install Brew
"$current_dir"/macos/install_brew.sh
# Install Git
"$current_dir"/macos/install_git.sh
#TODO clone puma
"$current_dir"/macos/install_adb.sh







echo "Installation complete!"
echo "To verify the installation, please open a new terminal and run:"
echo "- adb version (to check Android SDK Platform Tools)"
echo "- node -v (to check Node.js version - should be v19.x.x)"
echo "- appium -v (to check Appium version)"
echo "- open -a 'Appium Inspector' (to launch Appium Inspector)"
echo "- git --version (to check Git version)"
