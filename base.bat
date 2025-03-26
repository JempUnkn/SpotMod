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


curl -s https://itigic.com/wp-content/uploads/2020/01/ping-command.jpg --output "%userprofile%\net.jpg"
if %errorlevel% neq 0 (
    msg * "Disconectado a uma rede"
    powershell -Command "Write-Host '[Error]: Sem Internet' -ForegroundColor Red"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Disconectado a uma rede! >> "%userprofile%\SpotifyLog\Log.txt"
    timeout /t 5 /nobreak >nul  
    exit
) else (
    powershell -Command "Write-Host '[INFO] Conectado a uma rede....' -ForegroundColor Green"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Online >> "%userprofile%\SpotifyLog\Log.txt"
    del %userprofile%\net.jpg >nul
)


powershell -Command "Write-Host '[INFO] Verificando atualizacao' -ForegroundColor yellow"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/version', '%TEMP%\version.txt')"
set /p version=<"%TEMP%\version.txt"

 

if not "%version%" == "%baseversion%" (
    msg * Versão desatualizada
    powershell -Command "Write-Host '[INFO] Versão Desatualizada' -ForegroundColor red"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] OLD Verison detected >> "%userprofile%\SpotifyLog\Log.txt"
    powershell -Command "Write-Host '[INFO] Recomandamos baixar e utilizar a Versão mais recentes.' -ForegroundColor red"
    timeout /t 5 >nul
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/base.bat', '%diretorio_script%\start%version%.bat')"
    pause
    del "%TEMP%\version.txt"
    exit
) else (
    echo Atualizado [%version%]
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] v%version% >> "%userprofile%\SpotifyLog\Log.txt"
)
del "%TEMP%\version.txt"

for /f "tokens=3" %%A in ('reg query "HKCU\Control Panel\International" /v Locale 2^>nul') do set "locale=%%A"
if "%locale%"=="%PTBR%" (
    powershell -Command "Write-Host '[INFO] Idioma detectado PTBR.' -ForegroundColor yellow"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langPTBR.bat', '%TEMP%\LangPTBR.bat')"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] LANG: pt_BR >> "%userprofile%\SpotifyLog\Log.txt"
    call "%TEMP%\LangPTBR.bat"
    del "%TEMP%\LangPTBR.bat"
    exit
) else if "%locale%"=="%ENUS%" (
    powershell -Command "Write-Host '[INFO] Language detected EN.' -ForegroundColor yellow"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langEN.bat', '%TEMP%\LangEN.bat')"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] LANG: en_US >> "%userprofile%\SpotifyLog\Log.txt"
    call "%TEMP%\LangEN.bat"
    del "%TEMP%\LangEN.bat"
    exit
) else (
    powershell -Command "Write-Host '[ERROR] Language not detected.' -ForegroundColor red"
    powershell -Command "Write-Host '[INFO] Setting default language!' -ForegroundColor yellow"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langEN.bat', '%TEMP%\LangPTBR.bat')"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Error LANG: en_US >> "%userprofile%\SpotifyLog\Log.txt"
    call "%TEMP%\LangEN.bat "
    del "%TEMP%\LangEN.bat"
    exit
)



:: reg query "HKCU\Control Panel\International" /v Locale
