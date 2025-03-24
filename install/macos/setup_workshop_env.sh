#!/bin/bash

# Exit on error
set -e
CURRENT_DIR=$(dirname "$(realpath "$0")")

# Install Brew
"$CURRENT_DIR"/install_brew.sh

# Install Git
echo "Installing Git..."
brew install git

# Install Python3.10
brew install python@3.10

puma_dir="$HOME/puma-workshop"
if ! test -d "$puma_dir"; then
 git clone https://github.com/pumaworkshop/puma-workshop "$puma_dir"
fi

cd "$puma_dir"

echo "Setting up a virtual environment..."
python3.10 -m venv venv

source venv/bin/activate

echo "Installing requirements..."
pip install -r requirements.txt

echo "Setting up jupyter notebook settings"
config_dir="$HOME/.ipython/profile_default"
export CONFIG_FILE="$config_dir/ipython_config.py"

if ! test -d "$(dirname "$config_dir")"; then
  mkdir -p "$config_dir"
fi

# Add configuration to
cat >> "$CONFIG_FILE" << 'EOF'
import os
os.chdir(os.path.expanduser('~/puma-workshop'))
c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
EOF

echo "Configuration added to ipython_config.py"

echo "Puma setup completed"
