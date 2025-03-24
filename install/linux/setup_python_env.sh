#!/bin/bash
# Exit on error
set -e
CURRENT_DIR=$(dirname "$(realpath "$0")")
PUMA_ROOT="$CURRENT_DIR/../.."
#TODO install python 3.10
# TODO determine puma dir
cd "PUMA_ROOT"

echo "Setting up a virtual environment..."
sudo apt install python3-venv
sudo apt install python3-pip
python3 -m venv venv #TODO python 3.10
chmod 777 ./venv/bin/activate

source venv/bin/activate

echo "Installing requirements..."
pip install -r requirements.txt #TODO pip install should work after activating venv

echo "Puma setup completed"
