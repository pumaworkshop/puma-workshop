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

:: Deactivate the virtual environment
deactivate

echo Setup completed.
