#!/bin/bash

# Exit on error
set -e

# Install NVM (Node Version Manager)
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# Source NVM to use it immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install Node.js v19
echo "Installing Node.js v19..."
nvm install 19
nvm use 19
nvm alias default 19

echo "Installing Appium..."
npm install -g appium
