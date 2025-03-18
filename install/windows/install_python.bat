@echo off
setlocal enabledelayedexpansion

echo Checking for Python 3 installation...

:: Check if Python is installed by trying to get its version
python --version > nul 2>&1
if %errorlevel% equ 0 (
    :: Python is installed, now check if it's Python 3
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    for /f "tokens=1 delims=." %%i in ("!PYTHON_VERSION!") do set PYTHON_MAJOR=%%i

    if !PYTHON_MAJOR! equ 3 (
        echo Python 3 is already installed: !PYTHON_VERSION!
    ) else (
        echo Python is installed but it's not version 3. Installing Python 3...
        goto install_python
    )
) else (
    :: Python is not installed
    echo Python is not installed. Installing Python 3...
    goto install_python
)

goto end

:install_python
:: Download Python 3.12 installer
echo Downloading Python 3.12 installer...
powershell -Command "& {Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe' -OutFile 'python-installer.exe'}"

:: Install Python 3 (with pip) silently and add to PATH
echo Installing Python 3.12...
start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

:: Verify installation
echo Verifying Python 3.12 installation...
python --version > nul 2>&1
if %errorlevel% equ 0 (
    echo Python 3.12 installation successful.
) else (
    echo Python 3.12 installation failed. Please install manually.
    exit /b 1
)

:: Clean up installer
del python-installer.exe

:end
echo Python 3 check completed.