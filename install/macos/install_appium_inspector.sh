#!/bin/bash
#TODO NOT TESTED YET
# Exit on error
set -e

# Download and setup Appium Inspector
echo "Setting up Appium Inspector..."
APPIUM_INSPECTOR_DIR="$HOME/.appium-inspector"
mkdir -p $APPIUM_INSPECTOR_DIR

# Download Appium Inspector for macOS
APPIUM_INSPECTOR_URL="https://github.com/appium/appium-inspector/releases/download/v2024.12.1/Appium-Inspector-2024.12.1-mac-arm64.dmg"
APPIUM_INSPECTOR_FILE="$APPIUM_INSPECTOR_DIR/Appium-Inspector.dmg"

echo "Downloading Appium Inspector for macOS..."
curl -L $APPIUM_INSPECTOR_URL -o $APPIUM_INSPECTOR_FILE

# Mount the DMG file
MOUNT_POINT=$(hdiutil attach $APPIUM_INSPECTOR_FILE | grep Volumes | awk '{print $3}')
APP_PATH="$MOUNT_POINT/Appium Inspector.app"

# Copy the app to the Applications directory
cp -R "$APP_PATH" /Applications/

# Unmount the DMG file
hdiutil detach $MOUNT_POINT

# Create launcher script
USER_BIN_DIR="$HOME/bin"
mkdir -p $USER_BIN_DIR
APPIUM_INSPECTOR_SCRIPT="$USER_BIN_DIR/appium_inspector"

cat > $APPIUM_INSPECTOR_SCRIPT << EOF
#!/bin/bash
open -a "Appium Inspector" "\$@"
EOF
chmod +x $APPIUM_INSPECTOR_SCRIPT

#TODO replace this with get_env
# Add to PATH if not already there
SHELL_PROFILE=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_PROFILE="$HOME/.bashrc"
fi

if [ -n "$SHELL_PROFILE" ]; then
    if ! echo $PATH | grep -q "$USER_BIN_DIR"; then
        echo "export PATH=\$PATH:$USER_BIN_DIR" >> $SHELL_PROFILE
        export PATH=$PATH:$USER_BIN_DIR
        echo "Added $USER_BIN_DIR to PATH in $SHELL_PROFILE"
    else
        echo "$USER_BIN_DIR is already in PATH"
    fi
else
    echo "Warning: Could not find shell profile. You may need to manually add $USER_BIN_DIR to your PATH."
fi

echo "Appium Inspector setup complete."

