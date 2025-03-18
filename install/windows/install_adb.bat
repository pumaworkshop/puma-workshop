@echo off

:: Check if ANDROID_HOME is set
IF "%ANDROID_HOME%"=="" (
    echo ANDROID_HOME is not set. Setting up Android SDK...
    SETX ANDROID_HOME "%LOCALAPPDATA%\Android\Sdk"
)

:: Check if ANDROID_SDK_ROOT is set
IF "%ANDROID_SDK_ROOT%"=="" (
    echo ANDROID_SDK_ROOT is not set. Setting up Android SDK...
    SETX ANDROID_SDK_ROOT "%LOCALAPPDATA%\Android\Sdk"
)

:: Check if adb.exe exists in the expected location
IF NOT EXIST "%ANDROID_SDK_ROOT%\platform-tools\adb.exe" (
    echo adb.exe not found. Downloading Android SDK Platform Tools...

    :: Download Android SDK Platform Tools
    powershell -Command "Invoke-WebRequest 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile 'platform-tools.zip'"

    :: Unzip the downloaded file
    powershell -Command "Expand-Archive -Path 'platform-tools.zip' -DestinationPath '%LOCALAPPDATA%\Android\Sdk'"

    :: Clean up
    del platform-tools.zip

    echo Android SDK Platform Tools setup completed.
) ELSE (
    echo Android SDK is already set up correctly.
)
