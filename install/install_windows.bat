@echo off
cd /d "%~dp0\windows"

:: Initialize success flags
set "git_success=false"
set "python_success=false"
set "adb_success=false"
set "node_success=false"
set "setup_python_env_success=false"
set "appium_install_success=false"
set "appium_inspector_install_success=false"

:: Run Python installation script
echo Running Python installation...
call install_python.bat
IF %ERRORLEVEL% EQU 0 (
    set "python_success=true"
) ELSE (
    echo Python installation failed.
)

:: Run ADB installation script
echo Running ADB installation...
call install_adb.bat
IF %ERRORLEVEL% EQU 0 (
    set "adb_success=true"
) ELSE (
    echo ADB installation failed.
)

:: Run Node.js installation script
echo Running Node.js installation...
call install_node.bat
IF %ERRORLEVEL% EQU 0 (
    set "node_success=true"
) ELSE (
    echo Node.js installation failed.
)

:: Install Appium
echo Running Appium installation...
call install_appium.bat
IF %ERRORLEVEL% EQU 0 (
    set "appium_install_success=true"
) ELSE (
    echo Appium installation failed.
)

:: Install Appium Inspector
echo Running Appium Inspector installation...
call install_appium_inspector.bat
IF %ERRORLEVEL% EQU 0 (
    set "appium_inspector_install_success=true"
) ELSE (
    echo Appium Inspector installation failed.
)

:: Run python setup
cd /d "%CURRENT_DIR%"
echo Running python environment setup...
call windows\setup_python_env.bat
IF %ERRORLEVEL% EQU 0 (
    set "setup_python_env_success=true"
) ELSE (
    echo Python environment setup failed.
)

:: Summary of installations
echo
echo ----------------------
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
IF "%appium_install_success%"=="true" (
    echo Appium installation succeeded.
) ELSE (
    echo Appium installation failed.
)
IF "%appium_inspector_install_success%"=="true" (
    echo Appium Inspector installation succeeded.
) ELSE (
    echo Appium Inspector installation failed.
)
IF "%checkout_workshop_success%"=="true" (
    echo Workshop environment setup succeeded.
) ELSE (
    echo Workshop environment setup failed.
)

pause