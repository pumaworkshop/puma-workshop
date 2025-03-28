@echo off

:: Check if Python 3 is installed
python --version >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Python 3 is not installed. Downloading Python 3...

    IF NOT EXIST "python-installer.exe" (
        echo python-installer.exe not found. Downloading...

        :: Download Python installer
        powershell -Command "Invoke-WebRequest 'https://www.python.org/ftp/python/3.12.9/python-3.12.9-amd64.exe' -OutFile 'python-installer.exe'"
        set "downloaded_python=y"
    ) ELSE (
        echo python-installer.exe already exists. Skipping download.
    )

    :: Install Python 3
    echo Installing Python...
    echo The installer will now ask for administrator rights
    start /wait "" "python-installer.exe" /quiet InstallAllUsers=1 PrependPath=1
    set "PATH=C:\Program Files\Python312;C:\Program Files\Python312\Scripts;%PATH%"

    :: Clean up
    IF defined downloaded_python (
        del python-installer.exe
    )

    echo Python 3 installed, version:
    python --version
) ELSE (
    echo Python 3 is already installed.
)
