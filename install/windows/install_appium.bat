@echo off

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