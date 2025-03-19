@echo off

:: Check for administrator rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrative privileges. Please run as administrator.
    pause
    exit /b 1
)

:: Initialize success flags
set "git_success=false"
set "python_success=false"
set "adb_success=false"
set "node_appium_success=false"
set "checkout_workshop_success=false"

:: Run Git installation script
echo Running Git installation...
call windows\install_git.bat
IF %ERRORLEVEL% EQU 0 (
    set "git_success=true"
) ELSE (
    echo Git installation failed.
)

:: Run Python installation script
echo Running Python installation...
call windows\install_python.bat
IF %ERRORLEVEL% EQU 0 (
    set "python_success=true"
) ELSE (
    echo Python installation failed.
)

:: Run ADB installation script
echo Running ADB installation...
call windows\install_adb.bat
IF %ERRORLEVEL% EQU 0 (
    set "adb_success=true"
) ELSE (
    echo ADB installation failed.
)

:: Run Node.js and Appium installation script
echo Running Node.js and Appium installation...
call windows\install_node_appium.bat
IF %ERRORLEVEL% EQU 0 (
    set "node_appium_success=true"
) ELSE (
    echo Node.js and Appium installation failed.
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
IF "%git_success%"=="true" (
    echo Git installation succeeded.
) ELSE (
    echo Git installation failed.
)

IF "%python_success%"=="true" (
    echo Python installation succeeded.
) ELSE (
    echo Python installation failed.
)

IF "%adb_success%"=="true" (
    echo ADB installation succeeded.
) ELSE (
    echo ADB installation failed.
)

IF "%node_appium_success%"=="true" (
    echo Node.js and Appium installation succeeded.
) ELSE (
    echo Node.js and Appium installation failed.
)

IF "%checkout_workshop_success%"=="true" (
    echo Workshop environment setup succeeded.
) ELSE (
    echo Workshop environment setup failed.
)
