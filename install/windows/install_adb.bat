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
    echo adb.exe not found. Setting up Android SDK Platform Tools...

    :: Check if platform-tools.zip already exists
    :: TODO: location of install file needs to be robust, currently it's broken when running from the main install scripts
    IF NOT EXIST "platform-tools.zip" (
        echo platform-tools.zip not found. Downloading...

        :: Download Android SDK Platform Tools
        powershell -Command "Invoke-WebRequest 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile 'platform-tools.zip'"
        set "downloaded_zip=y"
    ) ELSE (
        echo platform-tools.zip already exists. Skipping download.
    )

    :: Unzip the downloaded file
    echo Installing platform-tools...
    powershell -Command "Expand-Archive -Path 'platform-tools.zip' -DestinationPath '%LOCALAPPDATA%\Android\Sdk'"

    :: Clean up only if the zip was downloaded
    IF defined downloaded_zip (
        del platform-tools.zip
    )

    echo Android SDK Platform Tools setup completed.
) ELSE (
    echo Android SDK is already set up correctly.
)
