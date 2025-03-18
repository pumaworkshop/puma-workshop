@echo off

:: Check if Git is installed
where git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Git is not installed. Installing Git...

    :: Download Git installer
    powershell -Command "Invoke-WebRequest 'https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe' -OutFile 'git-installer.exe'"

    :: Install Git
    start /wait "" "git-installer.exe" /SILENT

    :: Clean up
    del git-installer.exe

    echo Git installation completed.
) ELSE (
    echo Git is already installed.
)
