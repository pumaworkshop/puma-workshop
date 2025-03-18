@echo off

:: Check if Python 3 is installed
where python >nul 2>nul
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
    start /wait "" "python-installer.exe" /quiet InstallAllUsers=1 PrependPath=1

    :: Clean up
    IF defined downloaded_python (
        del python-installer.exe
    )

    echo Python 3 installation completed.
) ELSE (
    echo Python 3 is already installed.
)
