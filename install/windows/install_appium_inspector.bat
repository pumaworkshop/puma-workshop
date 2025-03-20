@echo off

:: Set the URL for the Appium Inspector download
set "APPIUM_INSPECTOR_URL=https://github.com/appium/appium-inspector/releases/download/v2025.3.1/Appium-Inspector-2025.3.1-win-x64.exe"

:: Set the path where the Appium Inspector will be downloaded
set "DOWNLOAD_PATH=Appium-Inspector.exe"

:: Check if the Appium Inspector executable already exists
if not exist "%DOWNLOAD_PATH%" (
    echo Appium Inspector not found. Downloading...

    :: Download the Appium Inspector executable
    powershell -Command "Invoke-WebRequest '%APPIUM_INSPECTOR_URL%' -OutFile '%DOWNLOAD_PATH%'"

    echo Appium Inspector downloaded successfully.
) else (
    echo Appium Inspector is already downloaded.
)

:: Install Appium inspector
echo Running the Appium Inspector installer...
start /wait "" "%DOWNLOAD_PATH%" /silent

echo Appium Inspector installation completed.

echo Setup completed.
