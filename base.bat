::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAjk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJgZkkaGErRXA==
::ZQ05rAF9IBncCkqN+0xwdVsEAlbMaCXpZg==
::ZQ05rAF9IAHYFVzEqQIDOBRAYQuGXA==
::eg0/rx1wNQPfEVWB+kM9LVsJDDeSM3+zAKwx5+yb
::fBEirQZwNQPfEVWB+kM9LVsJDDeSM3+XCbF8
::cRolqwZ3JBvQF1fEqQIDOBRAYQuGfCb6K7QO4+3v/+aGoUh9
::dhA7uBVwLU+EWHq91mcCDy4VYCDi
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATE9ltwCyJ2aTalCSqWIvW+Iaipv7jTwg==
::ZQ0/vhVqMQ3MEVWAtB9wJhQ0
::Zg8zqx1/OA3MEVWAtB9wMR5HLA==
::dhA7pRFwIByZRRmh2mgfEXs=
::Zh4grVQjdCyDJGyX8VAjFDhtbiGwG16TKpEgzO3o5P6IsnEwe8Z/S5/Uzr2IOdwx/0zocaoexnVOtcQIRBZNcgaiYg46ricMtGGRNonM/V2vHgbbqE4oHgU=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
:: chcp 65001 >nul
mode 100,24
color 0B
setlocal enabledelayedexpansion
cls

set "baseversion=0.2.5.1"

powershell -Command "Write-Host '                                               ' -ForegroundColor Green"
powershell -Command "Write-Host '          _____ _____ _____ _____    _____ _____ ____  ' -ForegroundColor Green"
powershell -Command "Write-Host '         |   __|  _  |     |_   _|  |     |     |    \ ' -ForegroundColor Green"
powershell -Command "Write-Host '         |__   |   __|  |  | | |    | | | |  |  |  |  |' -ForegroundColor Green"
powershell -Command "Write-Host '         |_____|__|  |_____| |_|    |_|_|_|_____|____/ ' -ForegroundColor Green"
powershell -Command "Write-Host '         [%baseversion%]' -ForegroundColor red"

echo.
echo.
set "diretorio_script=%~dp0" >nul
powershell -Command "Write-Host '[LOG] O MOD foi executado a partir do diretorio: %diretorio_script%.' -ForegroundColor yellow"
set "PTBR=00000416"
set "ENUS=00000409"


for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set dia=%%a& set mes=%%b& set ano=%%c) >nul
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (set hora=%%a& set minuto=%%b) >nul


:: =============================================================================================================================

:: =============================================================================================================================
setlocal enabledelayedexpansion

powershell -Command "Write-Host '[INFO] Verificacao do Save' -ForegroundColor Yellow"
set "dirsave=%TEMP%\.config_spotifyMOD"

if not exist "%dirsave%" (
    powershell -Command "Write-Host '[INFO] Selecione local para salvar os Logs' -ForegroundColor Yellow"
    FOR /F "usebackq tokens=* delims=" %%# IN (`POWERSHELL -nop -c "Add-Type -AssemblyName System.Windows.Forms; $folder = New-Object System.Windows.Forms.FolderBrowserDialog; $folder.Description='Save Logger'; if ($folder.ShowDialog() -eq 'OK') { $folder.SelectedPath }"`) DO (
        set "UIcaminhoselect=%%#"
        msg * "Pasta selecionada: %%#"
    )
    mkdir "!UIcaminhoselect!\SpotifyMod"
    echo !UIcaminhoselect!\SpotifyMod> "%dirsave%"
)

set "dirsave_upped="
for /f "usebackq delims=" %%a in ("%dirsave%") do (
    set "dirsave_upped=%%a"
)

powershell -Command "Write-Host '[OK] Saved em !dirsave_upped!' -ForegroundColor Green"
if not exist "!dirsave_upped!\SpotifyLog" mkdir "!dirsave_upped!\SpotifyLog"
set "dirsave_upped=!dirsave_upped!"

:: =============================================================================================================================
:: =============================================================================================================================

curl -s https://itigic.com/wp-content/uploads/2020/01/ping-command.jpg --output "%userprofile%\net.jpg"
if %errorlevel% neq 0 (
    msg * "Disconectado a uma rede"
    powershell -Command "Write-Host '[Error]: Sem Internet' -ForegroundColor Red"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Disconectado a uma rede! >> "%dirsave_upped%\SpotifyLog\Log.txt"
    timeout /t 5 /nobreak >nul  
    exit
) else (
    powershell -Command "Write-Host '[INFO] Conectado a uma rede....' -ForegroundColor Green"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Online >> "%dirsave_upped%\SpotifyLog\Log.txt"
    del %userprofile%\net.jpg >nul
)


powershell -Command "Write-Host '[INFO] Verificando atualizacao' -ForegroundColor yellow"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/version', '%TEMP%\version.txt')"
set /p version=<"%TEMP%\version.txt"

 

if not "%version%" == "%baseversion%" (
    msg * Versão desatualizada
    powershell -Command "Write-Host '[INFO] Versão Desatualizada' -ForegroundColor red"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] OLD Verison detected >> "%dirsave_upped%\SpotifyLog\Log.txt"
    powershell -Command "Write-Host '[INFO] Recomandamos baixar e utilizar a Versão mais recentes.' -ForegroundColor red"
    timeout /t 5 >nul
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/base.bat', '%diretorio_script%\start%version%.bat')"
    pause
    del "%TEMP%\version.txt"
    exit
) else (
    echo Atualizado [%version%]
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] v%version% >> "%dirsave_upped%\SpotifyLog\Log.txt"
)
del "%TEMP%\version.txt"

for /f "tokens=3" %%A in ('reg query "HKCU\Control Panel\International" /v Locale 2^>nul') do set "locale=%%A"
if "%locale%"=="%PTBR%" (
    powershell -Command "Write-Host '[INFO] Idioma detectado PTBR.' -ForegroundColor yellow"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langPTBR.bat', '%TEMP%\LangPTBR.bat')"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] LANG: pt_BR >> "%dirsave_upped%\SpotifyLog\Log.txt"
    call "%TEMP%\LangPTBR.bat"
    del "%TEMP%\LangPTBR.bat"
    exit
) else if "%locale%"=="%ENUS%" (
    powershell -Command "Write-Host '[INFO] Language detected EN.' -ForegroundColor yellow"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langEN.bat', '%TEMP%\LangEN.bat')"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] LANG: en_US >> "%dirsave_upped%\SpotifyLog\Log.txt"
    call "%TEMP%\LangEN.bat"
    del "%TEMP%\LangEN.bat"
    exit
) else (
    powershell -Command "Write-Host '[ERROR] Language not detected.' -ForegroundColor red"
    powershell -Command "Write-Host '[INFO] Setting default language!' -ForegroundColor yellow"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langEN.bat', '%TEMP%\langEN.bat')"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Error LANG: en_US >> "%dirsave_upped%\SpotifyLog\Log.txt"
    call "%TEMP%\LangEN.bat "
    del "%TEMP%\LangEN.bat"
    exit
)




exit /b
msg * ERROR!
powershell -Command "Write-Host '[ERROR] PULO DE LINHA' -ForegroundColor red"
pause
exit
