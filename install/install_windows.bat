@echo off
set CURRENT_DIR=%cd%
echo %CURRENT_DIR%
cd /d "%~dp0"
set CURRENT_DIR=%cd%
echo %CURRENT_DIR%
pause

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
set "node_success=false"
set "appium_success=false"
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

:: Run Node.js installation script
echo Running Node.js installation...
call windows\install_node.bat
IF %ERRORLEVEL% EQU 0 (
    set "node_success=true"
) ELSE (
    echo Node.js installation failed.
)
pause

:: Run Appium installation script
echo Running Appium installation...
call windows\install_appium.bat
IF %ERRORLEVEL% EQU 0 (
    set "appium_success=true"
) ELSE (
    echo Appium installation failed.
)
pause

:: Run workshop setup
echo Running workshop environment setup...
call windows\setup_workshop_env.bat
IF %ERRORLEVEL% EQU 0 (
    set "checkout_workshop_success=true"
) ELSE (
    echo Workshop environment setup failed.
)
pause

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

IF "%node_success%"=="true" (
    echo Node.js installation succeeded.
) ELSE (
    echo Node.js installation failed.
)

IF "%appium_success%"=="true" (
    echo Appium installation succeeded.
) ELSE (
    echoAppium installation failed.
)

IF "%checkout_workshop_success%"=="true" (
    echo Workshop environment setup succeeded.
) ELSE (
    echo Workshop environment setup failed.
)
pause