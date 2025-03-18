@echo off
setlocal enabledelayedexpansion

:: Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Node.js is not installed. Installing Node.js v20...

    :: Download Node.js v20 installer
    curl -o nodejs.msi https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi

    :: Install Node.js silently
    msiexec /i nodejs.msi /quiet /norestart

    :: Wait for installation to complete
    echo Waiting for Node.js installation to complete...
    timeout /t 10 /nobreak >nul

    :: Refresh environment variables
    set "NODEJS_PATH=C:\Program Files\nodejs"
    if exist "!NODEJS_PATH!\node.exe" (
        echo Node.js installation successful.
    ) else (
        echo Failed to install Node.js. Exiting...
        exit /b 1
    )
) else (
    echo Node.js is already installed.
)

:: Ensure npm is available
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo npm command not found. Please restart the terminal or check your PATH.
    exit /b 1
)

:: Install Appium
echo Installing Appium...
npm install -g appium
appium driver install uiautomator2

echo Appium installation complete.
endlocal
pause
