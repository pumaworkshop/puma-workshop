#!/bin/bash

# Exit on error
set -e

# Install Node.js v19
echo "Installing Node.js v19..."
nvm install 19
nvm use 19
nvm alias default 19

echo "Installing Appium..."
npm install -g appium
