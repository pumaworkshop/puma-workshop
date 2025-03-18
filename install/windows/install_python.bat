@echo off

:: Check if Python 3 is installed
where python >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Python 3 is not installed. Downloading Python 3...

    :: Download Python installer
    powershell -Command "Invoke-WebRequest 'https://www.python.org/ftp/python/3.12.9/python-3.12.9-amd64.exe' -OutFile 'python-installer.exe'"

    echo Python 3 downloaded, installing...

    :: Install Python 3
    start /wait "" "python-installer.exe" /quiet InstallAllUsers=1 PrependPath=1

    :: Clean up
    del python-installer.exe

    echo Python 3 installation completed.
) ELSE (
    echo Python 3 is already installed.
)
