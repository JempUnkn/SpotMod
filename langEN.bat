:langEN
title Checking Connection 


:: Yellow - Information about something missing
:: Green - Success, completed, correct
:: Cyan - Common
:: Red - Errors
  
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set day=%%a& set month=%%b& set year=%%c) >nul
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (set hour=%%a& set minute=%%b) >nul

powershell -Command "Write-Host '[LOG] Process Started at %hour%:%minute% on %day%/%month%/%year%' -ForegroundColor Cyan"
if not exist "%userprofile%\SpotifyLog\Log.txt" (
    mkdir "%userprofile%\SpotifyLog" >nul
    if %errorlevel% neq 0 (
        msg * Error creating LOG Directory for SpotMod
        powershell -Command "Write-Host '[Error]: Attempt to create Log Directory' -ForegroundColor Red"
    ) else (
        powershell -Command "Write-Host '[INFO] Log Directory created successfully!' -ForegroundColor Green"
    )
) else (
    echo Process Started {%hour%:%minute%} on the day {%day%/%month%/%year%} >> "%userprofile%\SpotifyLog\Log.txt"
)
curl -s https://itigic.com/wp-content/uploads/2020/01/ping-command.jpg --output "%userprofile%\net.jpg"
if %errorlevel% neq 0 (
    msg * "Disconnected from network"
    powershell -Command "Write-Host '[Error]: No Internet' -ForegroundColor Red" 
    timeout /t 5 /nobreak >nul
    exit
) else (
    powershell -Command "Write-Host '[INFO] Connected to a network....' -ForegroundColor Green"
    del %userprofile%\net.jpg >nul
) 

title LOADING...
:: Create temporary VBScript (in the directory where it was executed)
echo Set objShell = CreateObject("WScript.Shell") > temp.vbs
echo response = objShell.Popup("Do you want to inject?", 0, "Marketplace", 4) >> temp.vbs
echo If response = 6 Then WScript.Quit(0) >> temp.vbs
echo If response = 7 Then WScript.Quit(1) >> temp.vbs

:: Execute the VBScript and capture the exit code
cscript //nologo temp.vbs
set exitCode=%ERRORLEVEL%

:: Wait for the VBScript to finish before continuing
if %exitCode%==0 (
    powershell -Command "Write-Host '[INFO] Continuing the process...' -ForegroundColor Yellow"
    goto verification
) else (
    powershell -Command "Write-Host '[CANCELLED...]' -ForegroundColor red"
)

:: Delete the temporary file
timeout /t 3 /nobreak >nul
del temp.vbs
del langPTBR.bat
del langEN.bat
exit
pause

:verification
powershell -Command "Write-Host '[INFO] Checking if Spotify is installed' -ForegroundColor Cyan"
if exist %userprofile%\AppData\Roaming\Spotify\Spotify.exe (
    powershell -Command "Write-Host '[INFO] Spotify installed' -ForegroundColor Green"
    goto :continue
)

rem If Spotify is not installed
powershell -Command "Write-Host '[INFO] Spotify not installed!' -ForegroundColor Yellow"
timeout /t 3 /nobreak >nul

rem Search for the Spotify executable
title Downloading...
powershell -Command "Write-Host '[INFO] Searching for Spotify executable...' -ForegroundColor Cyan"
if not exist "%userprofile%\Downloads\SpotifySetup.exe" (
    powershell -Command "Write-Host '[INFO] Spotify executable not found!' -ForegroundColor Red"
    powershell -Command "Write-Host '[INFO] Downloading Spotify...' -ForegroundColor Yellow"
    set downloadDir=%temp%\spotmod
    mkdir %downloadDir%
    curl https://download.scdn.co/SpotifySetup.exe -o %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Downloading & Installing Spotify...' -ForegroundColor Cyan"
    start /wait %downloadDir%\SpotifySetup.exe
    del /q %downloadDir%\*
    rmdir %downloadDir%
    powershell -Command "Write-Host '[INFO] Spotify installed successfully!' -ForegroundColor Green"
    powershell -Command "Write-Host '[IMPORTANT] Log in to a Spotify account before continuing!' -ForegroundColor Yellow"
    timeout /t 7 /nobreak >nul
    echo.
    powershell -Command "Write-Host '[Press any key to continue]' -ForegroundColor blue"
    
) else (
    powershell -Command "Write-Host '[INFO] Spotify executable already found.' -ForegroundColor Green"
    set downloadDir=%userprofile%\Downloads
    curl https://download.scdn.co/SpotifySetup.exe -o %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Downloading & Installing Spotify...' -ForegroundColor Cyan"
    start /wait %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Spotify installed successfully!' -ForegroundColor Green"
    powershell -Command "Write-Host '[IMPORTANT] Log in to a Spotify account before continuing!' -ForegroundColor Yellow"
    timeout /t 7 /nobreak >nul
    echo.
    powershell -Command "Write-Host '[Press any key to continue]' -ForegroundColor blue"
)

:continue
title LOADING...
powershell -Command "Write-Host '[INFO] Continuing the process...' -ForegroundColor Yellow"

:: Check if Spicetify is installed
spicetify --help >nul
if %errorlevel% equ 0 (
    powershell -Command "Write-Host '[INFO] Spicetify detected.' -ForegroundColor Green"
    powershell -Command "Write-Host '[UPDATING...]' -ForegroundColor Yellow"
    call :task
    spicetify update
    call :end
) else (
    powershell -Command "Write-Host '[INFO] Spicetify not detected.' -ForegroundColor Yellow"
)

:: If the user selects "Yes" (exit code 0), continue
if %exitCode% equ 0 (
    title Process ongoing...
    call :task
    powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1 | iex"
    call :task
    powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1 | iex"
    title Process completed!
    powershell -Command "Write-Host '[INFO] Finished successfully!' -ForegroundColor Green"
    msg * "Reopen Spotify"
) else (
    powershell -Command "Write-Host '[INFO] Process cancelled by user.' -ForegroundColor Yellow"
)


:: Finalize the script
:end
start License.html
timeout /t 2 >nul
del License.html
del langPTBR.bat
del langEN.bat
exit

:task
tasklist | find /i "Spotify.exe" >nul
if %errorlevel% equ 0 (
    powershell -Command "Write-Host '[INFO] Closing Spotify...' -ForegroundColor Yellow"
    taskkill /f /im Spotify.exe
) else (
    powershell -Command "Write-Host '[INFO] Spotify already closed, continuing the process...' -ForegroundColor Cyan"
)