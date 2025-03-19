#!/bin/bash

# Exit on error
set -e

echo "Starting setup of Android SDK Platform Tools, Node.js, and Appium for Linux..."

sh ./linux/install_adb.sh
sh ./linux/install_node_appium.sh
sh ./linux/install_appium_inspector.sh

echo "Installation complete!"
echo "To verify the installation, please open a new terminal and run:"
echo "- adb version (to check Android SDK Platform Tools)"
echo "- node -v (to check Node.js version - should be v19.x.x)"
echo "- appium -v (to check Appium version)"
echo "- appium_inspector (to launch Appium Inspector)"
echo ""
echo "Note: You may need to install additional dependencies for AppImage to run properly."
echo "If you encounter errors running appium_inspector, try installing:"
echo "sudo apt-get install libfuse2"