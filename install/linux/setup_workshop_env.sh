#!/bin/bash
# Exit on error
set -e

echo "Installing Git..."
sudo apt install git
cd ~

#TODO install python 3.10
puma_dir="$HOME/puma-workshop"
if ! test -d "$puma_dir"; then
 git clone https://github.com/pumaworkshop/puma-workshop "$puma_dir"
fi

cd "$puma_dir"

echo "Setting up a virtual environment..."
sudo apt install python3-venv
sudo apt install python3-pip
python3 -m venv venv #TODO python 3.10
chmod 777 ./venv/bin/activate

./venv/bin/activate

echo "Installing requirements..."
./venv/bin/pip3 install -r requirements.txt #TODO pip should work after activating venv

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
