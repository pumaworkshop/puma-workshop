@echo off

:: Check if Appium is already installed
npm list -g --depth=0 | findstr /C:"appium" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo Appium is not installed. Installing Appium...
    call npm install -g appium
    call appium driver install uiautomator2
    echo Appium installed.
) ELSE (
    echo Appium is already installed.
)

echo Appium installation completed.