#!/bin/bash
CURRENT_DIR=$(dirname "$(realpath "$0")")
# Determine the current shell

source "$CURRENT_DIR"/macos/get_shell.sh
shell=$(default_shell)
SHELL_PROFILE=$(shell_profile $shell)
# Check the current shell and set the appropriate profile file


# Check if the profile file exists, if not, create it
if [ ! -f "$SHELL_PROFILE" ]; then
    touch "$SHELL_PROFILE"
    echo "Created $SHELL_PROFILE"
fi

# Set up environment variables
echo "Setting up environment variables..."
ENV_SETUP="
# Android SDK Environment Variables
export ANDROID_HOME=\$HOME/android-sdk
export ANDROID_SDK_ROOT=\$HOME/android-sdk
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
"


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
export "$SHELL_PROFILE"