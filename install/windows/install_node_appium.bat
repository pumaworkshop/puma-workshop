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

:: Check if Appium is already installed
npm list -g --depth=0 | findstr /C:"appium" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo Appium is not installed. Installing Appium...
    call npm install -g appium
    echo Appium installed.
) ELSE (
    echo Appium is already installed.
)

:: Check if uiautomator2 driver is installed
appium driver list --installed 2>&1 | findstr /C:"uiautomator2" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo uiautomator2 driver is not installed. Installing uiautomator2 driver...
    call appium driver install uiautomator2
) ELSE (
    echo uiautomator2 driver is already installed.
)

echo Appium installation completed.
