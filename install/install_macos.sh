#!/bin/bash
CURRENT_DIR=$(dirname "$(realpath "$0")")

# Exit on error
set -e

echo "Starting setup of Android SDK Platform Tools, Node.js, Appium, and Git for macOS..."

# Set environment variables

#TODO clone puma
"$CURRENT_DIR"/macos/install_adb.sh
"$CURRENT_DIR"/macos/install_node_appium.sh
"$CURRENT_DIR"/macos/install_appium_inspector.sh
"$CURRENT_DIR"/macos/setup_workshop_env.sh

#TODO actually check instead of print
echo "Installation complete!"
echo "To verify the installation, please open a new terminal and run:"
echo "- adb version (to check Android SDK Platform Tools)"
echo "- node -v (to check Node.js version - should be v19.x.x)"
echo "- appium -v (to check Appium version)"
echo "- open -a 'Appium Inspector' (to launch Appium Inspector)"
echo "- git --version (to check Git version)"
