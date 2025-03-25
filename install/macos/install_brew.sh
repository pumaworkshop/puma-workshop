#!/bin/bash
current_dir=$(dirname "$(realpath "$0")")
source "$current_dir"/../common/get_shell.sh
SHELL_PROFILE=$(shell_profile)

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> "$SHELL_PROFILE"
    echo "eval $(/opt/homebrew/bin/brew shellenv)" >> "$SHELL_PROFILE"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

