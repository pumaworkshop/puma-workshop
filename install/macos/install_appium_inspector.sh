#!/bin/bash
# Exit on error
set -e
CURRENT_DIR=$(dirname "$(realpath "$0")")
# Download and setup Appium Inspector
echo "Setting up Appium Inspector..."
APPIUM_INSPECTOR_DIR="$HOME/.appium-inspector"
mkdir -p $APPIUM_INSPECTOR_DIR

# Create launcher script
USER_BIN_DIR="$HOME/bin"
mkdir -p "$USER_BIN_DIR"
APPIUM_INSPECTOR_SCRIPT="$USER_BIN_DIR/appium_inspector"

if [ -f "$APPIUM_INSPECTOR_SCRIPT" ]; then
        echo "Appium Inspector is already installed."
        exit 0
fi
# Download Appium Inspector for macOS
APPIUM_INSPECTOR_URL="https://github.com/appium/appium-inspector/releases/download/v2024.12.1/Appium-Inspector-2024.12.1-mac-arm64.dmg"
APPIUM_INSPECTOR_FILE="$APPIUM_INSPECTOR_DIR/Appium-Inspector.dmg"

echo "Downloading Appium Inspector for macOS..."
curl -L $APPIUM_INSPECTOR_URL -o "$APPIUM_INSPECTOR_FILE"

# Mount the DMG file
MOUNT_POINT=$(hdiutil attach "$APPIUM_INSPECTOR_FILE" | grep Volumes |  awk -F '\t' '{print $3}')
echo "Mounted DMG at: $MOUNT_POINT"

# Verify the contents of the mounted DMG
ls "$MOUNT_POINT"

# Check if the Appium Inspector app exists in the expected path
if [ -d "$MOUNT_POINT/Appium Inspector.app" ]; then
    APP_PATH="$MOUNT_POINT/Appium Inspector.app"
else
    echo "Appium Inspector.app not found in the expected path. Please check the contents of the mounted DMG."
    exit 1
fi

# Copy the app to the Applications directory
echo "Copying Appium Inspector to Applications directory..."
cp -R "$APP_PATH" /Applications/

# Unmount the DMG
hdiutil detach "$MOUNT_POINT"

echo "Appium Inspector setup complete."

cat > "$APPIUM_INSPECTOR_SCRIPT" << EOF
#!/bin/bash
open -a "Appium Inspector" "\$@"
EOF
chmod +x "$APPIUM_INSPECTOR_SCRIPT"

# Add to PATH if not already there
source "$CURRENT_DIR"/get_shell.sh
shell=$(default_shell)
SHELL_PROFILE=$(shell_profile "$shell")

if [ -n "$SHELL_PROFILE" ]; then
    if ! echo "$PATH" | grep -q "$USER_BIN_DIR"; then
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

