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
call appium driver install uiautomator2

echo Appium installation completed.