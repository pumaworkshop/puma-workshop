#!/bin/bash

# Exit on error
set -e

echo "Starting install of android-sdk and platform-tools"
if command -v adb &> /dev/null; then
  echo "[INFO] ADB is already installed. Skipping installation"
  exit 0
fi

ANDROID_SDK_DIR=$HOME/android-sdk
TEMP_DIR=$(mktemp -d)
CURRENT_DIR=$(dirname "$(realpath "$0")")

# Create Android SDK directory
mkdir -p "$ANDROID_SDK_DIR"

# Download and extract Android SDK Platform Tools
echo "Downloading Android SDK Platform Tools..."
PLATFORM_TOOLS_URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
curl -L $PLATFORM_TOOLS_URL -o "$TEMP_DIR"/platform-tools.zip

echo "Extracting Platform Tools to $ANDROID_SDK_DIR..."
unzip -q "$TEMP_DIR"/platform-tools.zip -d "$ANDROID_SDK_DIR"

# Set up environment variables
echo "Setting up environment variables..."
ENV_SETUP="
# Android SDK Environment Variables
export ANDROID_HOME=\$HOME/android-sdk
export ANDROID_SDK_ROOT=\$HOME/android-sdk
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
"

echo "Setting environment variables"

source "$CURRENT_DIR"/get_shell.sh
shell=$(default_shell)
SHELL_PROFILE=$(shell_profile "$shell")

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

source "$SHELL_PROFILE"

echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
