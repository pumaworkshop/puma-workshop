#!/bin/bash
current_dir=$(dirname "$(realpath "$0")")

"$current_dir"/install_brew.sh
# Install Git
echo "Installing Git..."
brew install git

