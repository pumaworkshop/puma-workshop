#!/bin/bash

# Exit on error
set -e

# Download and setup Appium Inspector
echo "Setting up Appium Inspector..."
APPIUM_INSPECTOR_DIR="$HOME/.appium-inspector"
mkdir -p $APPIUM_INSPECTOR_DIR

# Download Appium Inspector for Linux
APPIUM_INSPECTOR_URL="https://github.com/appium/appium-inspector/releases/download/v2024.12.1/Appium-Inspector-2024.12.1-linux-x86_64.AppImage"
APPIUM_INSPECTOR_FILE="$APPIUM_INSPECTOR_DIR/appium-inspector.AppImage"

echo "Downloading Appium Inspector for Linux..."
curl -L $APPIUM_INSPECTOR_URL -o $APPIUM_INSPECTOR_FILE
chmod +x $APPIUM_INSPECTOR_FILE

# Create launcher script
USER_BIN_DIR="$HOME/bin"
mkdir -p $USER_BIN_DIR
APPIUM_INSPECTOR_SCRIPT="$USER_BIN_DIR/appium_inspector"

cat > $APPIUM_INSPECTOR_SCRIPT << EOF
#!/bin/bash
$APPIUM_INSPECTOR_FILE "\$@"
EOF
chmod +x $APPIUM_INSPECTOR_SCRIPT

# Add to PATH if not already there
if ! echo $PATH | grep -q "$USER_BIN_DIR"; then
    echo "export PATH=\$PATH:$USER_BIN_DIR" >> $SHELL_PROFILE #TODO this is out of scope? Use get_shell from macos
    export PATH=$PATH:$USER_BIN_DIR
fi
