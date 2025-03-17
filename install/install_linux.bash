#!/bin/bash

# Exit on error
set -e

echo "Starting setup of Android SDK Platform Tools, Node.js, and Appium for Linux..."

# Define installation directories
HOME_DIR=$HOME
ANDROID_SDK_DIR=$HOME_DIR/android-sdk
PLATFORM_TOOLS_DIR=$ANDROID_SDK_DIR/platform-tools
TEMP_DIR=$(mktemp -d)

# Create Android SDK directory
mkdir -p $ANDROID_SDK_DIR

# Download and extract Android SDK Platform Tools
echo "Downloading Android SDK Platform Tools..."
PLATFORM_TOOLS_URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
curl -L $PLATFORM_TOOLS_URL -o $TEMP_DIR/platform-tools.zip

echo "Extracting Platform Tools to $ANDROID_SDK_DIR..."
unzip -q $TEMP_DIR/platform-tools.zip -d $ANDROID_SDK_DIR

# Set up environment variables
echo "Setting up environment variables..."
ENV_SETUP="
# Android SDK Environment Variables
export ANDROID_HOME=\$HOME/android-sdk
export ANDROID_SDK_ROOT=\$HOME/android-sdk
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
"

# Add environment variables to shell profile
SHELL_PROFILE=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_PROFILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
fi

if [ -n "$SHELL_PROFILE" ]; then
    # Check if variables already exist in the profile
    if ! grep -q "ANDROID_HOME" "$SHELL_PROFILE"; then
        echo "$ENV_SETUP" >> "$SHELL_PROFILE"
        echo "Added environment variables to $SHELL_PROFILE"
    else
        echo "Environment variables already exist in $SHELL_PROFILE"
    fi
else
    echo "Warning: Could not find shell profile. You may need to manually add environment variables."
    echo "Please add the following to your shell profile:"
    echo "$ENV_SETUP"
fi

# Apply environment variables to current session
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Install NVM (Node Version Manager)
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# Source NVM to use it immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Check if nvm is available
if ! command -v nvm &> /dev/null; then
    echo "NVM installation may have failed or needs a new terminal session."
    echo "Please run 'source $SHELL_PROFILE' or open a new terminal before continuing."
    echo "Then run the script again."
    exit 1
fi

# Install Node.js v19
echo "Installing Node.js v19..."
nvm install 19
nvm use 19
nvm alias default 19

# Install Appium
echo "Installing Appium..."
npm install -g appium

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
    echo "export PATH=\$PATH:\$USER_BIN_DIR" >> $SHELL_PROFILE
    export PATH=$PATH:$USER_BIN_DIR
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf $TEMP_DIR

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