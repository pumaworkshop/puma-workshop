@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges to set system environment variables.
    echo Requesting administrator privileges...

    :: Self-elevate the script
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit /b
)

echo Checking Android SDK environment...

:: Define the default SDK location
set "DEFAULT_SDK_PATH=%USERPROFILE%\AppData\Local\Android\Sdk"

:: Initialize variables
set NEED_ENV_VARS=no
set NEED_SDK=no

:: Check if ANDROID_HOME is set
if not defined ANDROID_HOME (
    echo ANDROID_HOME environment variable is not set.
    set NEED_ENV_VARS=yes
) else (
    echo ANDROID_HOME is set to: %ANDROID_HOME%
)

:: Check if ANDROID_SDK_ROOT is set
if not defined ANDROID_SDK_ROOT (
    echo ANDROID_SDK_ROOT environment variable is not set.
    set NEED_ENV_VARS=yes
) else (
    echo ANDROID_SDK_ROOT is set to: %ANDROID_SDK_ROOT%
)

:: Check if ADB exists in the default location when env vars are not set
if "%NEED_ENV_VARS%"=="yes" (
    if exist "%DEFAULT_SDK_PATH%\platform-tools\adb.exe" (
        echo Found ADB at default location: %DEFAULT_SDK_PATH%\platform-tools\adb.exe
        echo Setting environment variables to default location.
        set "ANDROID_HOME=%DEFAULT_SDK_PATH%"
        set "ANDROID_SDK_ROOT=%DEFAULT_SDK_PATH%"
        goto update_env_vars
    ) else (
        echo ADB not found at default location.
        set NEED_SDK=yes
    )
)

:: If environment variables are set, check if they point to the same location
if not "%NEED_ENV_VARS%"=="yes" (
    if not "%ANDROID_HOME%" == "%ANDROID_SDK_ROOT%" (
        echo Warning: ANDROID_HOME and ANDROID_SDK_ROOT are different.
        echo ANDROID_HOME: %ANDROID_HOME%
        echo ANDROID_SDK_ROOT: %ANDROID_SDK_ROOT%
        set /p CHOICE="Do you want to continue with these settings? (Y/N): "
        if /i not "!CHOICE!" == "Y" (
            echo Setting both variables to ANDROID_HOME value.
            set "ANDROID_SDK_ROOT=%ANDROID_HOME%"
            goto update_env_vars
        )
    )
)

:: Check if ADB exists in the expected location
if defined ANDROID_SDK_ROOT (
    set "ADB_PATH=%ANDROID_SDK_ROOT%\platform-tools\adb.exe"
) else (
    set "ADB_PATH=%DEFAULT_SDK_PATH%\platform-tools\adb.exe"
)

if exist "!ADB_PATH!" (
    echo ADB found at: !ADB_PATH!
) else (
    echo ADB not found at: !ADB_PATH!
    echo Will download and install Android SDK Platform Tools.
    set NEED_SDK=yes
)

if "%NEED_SDK%"=="yes" goto download_sdk
goto end

:download_sdk
:: Create SDK directory if it doesn't exist
if not exist "%DEFAULT_SDK_PATH%" (
    echo Creating SDK directory: %DEFAULT_SDK_PATH%
    mkdir "%DEFAULT_SDK_PATH%"
)

:: Download Platform Tools
echo Downloading Android SDK Platform Tools...
powershell -Command "& {Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile '%TEMP%\platform-tools.zip'}"

:: Extract to SDK directory
echo Extracting Platform Tools...
powershell -Command "& {Expand-Archive -Path '%TEMP%\platform-tools.zip' -DestinationPath '%DEFAULT_SDK_PATH%' -Force}"

:: Clean up
del "%TEMP%\platform-tools.zip"

:: Set environment variables
set "ANDROID_HOME=%DEFAULT_SDK_PATH%"
set "ANDROID_SDK_ROOT=%DEFAULT_SDK_PATH%"

:update_env_vars
:: Set environment variables permanently
echo Setting environment variables permanently...
setx ANDROID_HOME "%ANDROID_HOME%" /M
if %errorlevel% neq 0 (
    echo Failed to set ANDROID_HOME environment variable.
    echo Please make sure the script is running with administrator privileges.
    exit /b 1
)

setx ANDROID_SDK_ROOT "%ANDROID_SDK_ROOT%" /M
if %errorlevel% neq 0 (
    echo Failed to set ANDROID_SDK_ROOT environment variable.
    echo Please make sure the script is running with administrator privileges.
    exit /b 1
)

:: Add platform-tools to PATH if not already there
echo Checking if platform-tools is in PATH...
echo %PATH% | findstr /C:"%ANDROID_SDK_ROOT%\platform-tools" > nul
if %errorlevel% neq 0 (
    echo Adding platform-tools to PATH...
    setx PATH "%PATH%;%ANDROID_SDK_ROOT%\platform-tools" /M
    if %errorlevel% neq 0 (
        echo Failed to update PATH environment variable.
        echo Please make sure the script is running with administrator privileges.
        exit /b 1
    )
)

:: Verify ADB is now accessible
echo Verifying ADB installation...
if exist "%ANDROID_SDK_ROOT%\platform-tools\adb.exe" (
    echo ADB installation successful.
) else (
    echo ADB installation failed. Please install manually.
    exit /b 1
)

:end
echo.
echo Android SDK environment setup complete.
echo ANDROID_HOME: %ANDROID_HOME%
echo ANDROID_SDK_ROOT: %ANDROID_SDK_ROOT%
echo ADB path: %ANDROID_SDK_ROOT%\platform-tools\adb.exe
echo.
echo Please restart your command prompt or any IDE for the changes to take effect.
