@echo off
cd /d "%~dp0"

set "checkout_workshop_success=false"
set "appium_install_success=false"

:: Install Appium
echo Running Appium installation...
call windows\install_appium.bat
IF %ERRORLEVEL% EQU 0 (
    set "appium_install_success=true"
) ELSE (
    echo Appium installation failed.
)

:: Run workshop setup
echo Running workshop environment setup...
call windows\setup_workshop_env.bat
IF %ERRORLEVEL% EQU 0 (
    set "checkout_workshop_success=true"
) ELSE (
    echo Workshop environment setup failed.
)

:: Summary of installations
echo Installation Summary:
echo ----------------------
IF "%appium_install_success%"=="true" (
    echo Appium installation succeeded.
) ELSE (
    echo Appium installation failed.
)
IF "%checkout_workshop_success%"=="true" (
    echo Workshop environment setup succeeded.
) ELSE (
    echo Workshop environment setup failed.
)
pause