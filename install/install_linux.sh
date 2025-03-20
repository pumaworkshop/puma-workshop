#!/bin/bash
CURRENT_DIR=$(dirname "$(realpath "$0")")

# Exit on error
set -e

echo "Starting setup of Android SDK Platform Tools, Node.js, and Appium for Linux..."
now=$(date +"%Y%m%d_%H:%M:%S")
mkdir -p "$CURRENT_DIR/logs"
log_path="$CURRENT_DIR/logs/$now.log"
touch "$log_path"

"$CURRENT_DIR"/linux/install_adb.sh | tee -a "$log_path"
"$CURRENT_DIR"/linux/install_node_appium.sh | tee -a "$log_path"
"$CURRENT_DIR"/linux/install_appium_inspector.sh | tee -a "$log_path"
"$CURRENT_DIR"/linux/setup_workshop_env.sh | tee -a "$log_path"

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