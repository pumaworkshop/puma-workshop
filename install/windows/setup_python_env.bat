@echo off

set "CURRENT_DIR=%~dp0"
set "PUMA_ROOT=%CURRENT_DIR%..\.."
cd /d "%PUMA_ROOT%"

:: Set up a virtual environment
echo Setting up a virtual environment...
python -m venv venv

:: Activate the virtual environment
call venv\Scripts\activate.bat

:: Install the requirements
echo Installing requirements...
pip install -r requirements.txt

:: Deactivate the virtual environment
deactivate

echo Setup completed.
