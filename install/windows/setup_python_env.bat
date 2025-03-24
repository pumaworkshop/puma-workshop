@echo off

:: Set the GitHub repository URL and the local directory to clone into
set "REPO_URL=https://github.com/pumaworkshop/puma-workshop"
set "LOCAL_DIR=puma-workshop"

:: Check if the local directory already exists
IF NOT EXIST "%LOCAL_DIR%" (
    :: Clone the GitHub repository
    echo Cloning the repository...
    git clone %REPO_URL% %LOCAL_DIR%
) ELSE (
    echo Local directory already exists. Skipping clone.
)

:: Change to the repository directory
cd %LOCAL_DIR%

:: Set up a virtual environment
echo Setting up a virtual environment...
python -m venv venv

:: Activate the virtual environment
call venv\Scripts\activate.bat

:: Install the requirements
echo Installing requirements...
pip install -r requirements.txt

:: jupyter notebook configuration: working dir and auto reload
:: Set the path to the user's home directory
echo setting jupyter notebook settings

set USERPROFILE=%HOMEPATH%

:: Define the path to the ipython_config.py file
set CONFIG_FILE=%USERPROFILE%\.ipython\profile_default\ipython_config.py

:: Create the directory if it doesn't exist
if not exist "%USERPROFILE%\.ipython" (
    mkdir "%USERPROFILE%\.ipython"
)
if not exist "%USERPROFILE%\.ipython\profile_default" (
    mkdir "%USERPROFILE%\.ipython\profile_default"
)

:: Create the file if it doesn't exist
if not exist "%CONFIG_FILE%" (
    type nul > "%CONFIG_FILE%"
)

:: Append the configuration lines to the file
echo import os >> "%CONFIG_FILE%"
echo os.chdir('/path/to/puma-workshop') >> "%CONFIG_FILE%"
echo c.InteractiveShellApp.extensions = ['autoreload'] >> "%CONFIG_FILE%"
echo c.InteractiveShellApp.exec_lines = ['%%autoreload 2'] >> "%CONFIG_FILE%"

echo Configuration added to ipython_config.py.

:: Deactivate the virtual environment
deactivate


echo Setup completed.
