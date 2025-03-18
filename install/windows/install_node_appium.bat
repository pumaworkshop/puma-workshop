@echo off

:: Check if Node.js is installed
where node >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Node.js is not installed. Installing Node.js...

    IF NOT EXIST "node-installer.msi" (
        echo node-installer.msi not found. Downloading...

        :: Download Node.js installer
        powershell -Command "Invoke-WebRequest 'https://nodejs.org/dist/v22.14.0/node-v22.14.0-x64.msi' -OutFile 'node-installer.msi'"
        set "downloaded_node=y"
    ) ELSE (
        echo node-installer.msi already exists. Skipping download.
    )

    :: Install Node.js
    echo Installing nodeJS...
    start /wait "" msiexec /i "node-installer.msi" /quiet /norestart

    :: Clean up
    IF defined downloaded_node (
        del node-installer.msi
    )

    echo Node.js installation completed.
) ELSE (
    echo Node.js is already installed.
)

:: Install Appium using npm
echo Installing Appium...
npm install -g appium
appium driver install uiautomator2

echo Appium installation completed.
