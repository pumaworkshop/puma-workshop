#!/bin/bash

# Exit on error
set -e

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
