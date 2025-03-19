#!/bin/bash

# Exit on error
set -e

echo "Installing git..."
sudo apt install git

if test -d $HOME/directory; then
 mkdir "puma-workshop"
 git clone https://github.com/pumaworkshop/puma-workshop puma-workshop
fi

cd puma-workshop

echo "Setting up a virtual environment..."
python3 -m venv venv

sh venv/bin/activate

echo "Installing requirements..."
pip install -r requirements.txt

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

deactivate

echo "Setup completed"
