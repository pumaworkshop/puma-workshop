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
./venv/bin/pip3 install -r requirements.txt

echo "Setting up jupyter notebook settings"
export CONFIG_FILE=$HOME/.ipython/profile_default/ipython_config.py

if ! test -d $HOME/.ipython/; then
  mkdir "$HOME/.ipython/"
fi

if ! test -d $HOME/.ipython/profile_default/; then
  mkdir "$HOME/.ipython/profile_default/"
fi

if ! test -f $HOME/.ipython/profile_default/ipython_config.py; then
  cat > $HOME/.ipython/profile_default/ipython_config.py << EOF
  import os
  os.chdir('~/puma-workshop')
  c.InteractiveShellApp.extensions = ['autoreload'] >> "%CONFIG_FILE%"
  c.InteractiveShellApp.exec_lines = ['%%autoreload 2'] >> "%CONFIG_FILE%"
EOF
  echo "Configuration added to ipython_config.py"
fi

echo "Setup completed"
