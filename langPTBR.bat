:langPT
title Verificando a Conexao 
set "diretorio_script=%~dp0" >nul
 

:: Yellow - Infomacao sobre algo em falta
:: Green - Sucesso, concluido, certo
:: Cyan - Comum
:: Red - erros 
  
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set dia=%%a& set mes=%%b& set ano=%%c) >nul
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (set hora=%%a& set minuto=%%b) >nul

powershell -Command "Write-Host '[LOG] Processo Iniciado as %hora%:%minuto% em %dia%/%mes%/%ano%' -ForegroundColor Cyan"
if not exist "%dirsave_upped%\SpotifyLog\Log.txt" (
    mkdir "%userprofile%\SpotifyLog" >nul
    if %errorlevel% neq 0 (
        msg * Erro ao criar um Diretorio LOG para o SpotMod
        powershell -Command "Write-Host '[Error]: Tentativa de criacao do Diretorio Log' -ForegroundColor Red"
        echo [%dia%/%mes%/%ano% %hora%:%minuto%] Error: Tentativa de criacao do DIR >> "%dirsave_upped%\SpotifyLog\Log.txt"
    ) else (
        powershell -Command "Write-Host '[INFO] Diretorio Log criado com sucesso!' -ForegroundColor Green"
        echo [%dia%/%mes%/%ano% %hora%:%minuto%] Diretorio LOG Criado >> "%dirsave_upped%\SpotifyLog\Log.txt"
    )
) else (
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Processo Iniciado >> "%dirsave_upped%\SpotifyLog\Log.txt"
)

title LOADING...
:: Criação do script temporário em VBScript (no diretório onde foi executado)
echo Set objShell = CreateObject("WScript.Shell") > temp.vbs
echo resposta = objShell.Popup("Deseja Injectar?", 0, "Marketplace", 4) >> temp.vbs
echo If resposta = 6 Then WScript.Quit(0) >> temp.vbs
echo If resposta = 7 Then WScript.Quit(1) >> temp.vbs

:: Executa o VBScript e captura o código de saída
cscript //nologo temp.vbs
set exitCode=%ERRORLEVEL%

:: Aguarda o término da execução do VBScript antes de proceder
if %exitCode%==0 (
    powershell -Command "Write-Host '[INFO] Continuando o processo...' -ForegroundColor Yellow"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Client escolheu: Continuar com o processo >> "%dirsave_upped%\SpotifyLog\Log.txt"
    goto verificacao
) else (
    powershell -Command "Write-Host '[CANCELANDO...]' -ForegroundColor red" 
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Processo cancelado >> "%dirsave_upped%\SpotifyLog\Log.txt"
)

:: Exclui o arquivo temporário
timeout /t 3 /nobreak >nul
del temp.vbs
exit /b
pause



:verificacao
echo [%dia%/%mes%/%ano% %hora%:%minuto%] Verificacao basicas >> "%dirsave_upped%\SpotifyLog\Log.txt"
powershell -Command "Write-Host '[INFO] Verificando se o Spotify esta instalado' -ForegroundColor Cyan"
if exist %userprofile%\AppData\Roaming\Spotify\Spotify.exe (
    powershell -Command "Write-Host '[INFO] Spotify Instalado' -ForegroundColor Green"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Spotify encontra-se Instalado >> "%dirsave_upped%\SpotifyLog\Log.txt"
    goto :continue
)

rem Caso o Spotify nao esteja instalado
powershell -Command "Write-Host '[INFO] Spotify nao instalado!' -ForegroundColor Yellow"
echo [%dia%/%mes%/%ano% %hora%:%minuto%] Spotify nao Instalado! >> "%dirsave_upped%\SpotifyLog\Log.txt"
timeout /t 3 /nobreak >nul

rem Procurando o executavel do Spotify
title Downloading...
powershell -Command "Write-Host '[INFO] Procurando o executavel do Spotify...' -ForegroundColor Cyan"
if not exist "%userprofile%\Downloads\SpotifySetup.exe" (
    powershell -Command "Write-Host '[INFO] Executavel do Spotify nao encontrado!' -ForegroundColor Red"
    powershell -Command "Write-Host '[INFO] Baixando o Spotify...' -ForegroundColor Yellow"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Try Download Spotify >> "%dirsave_upped%\SpotifyLog\Log.txt"
    set "downloadDir=%TEMP%\spotmod"
    mkdir %downloadDir%
    curl https://download.scdn.co/SpotifySetup.exe -o %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Baixando & Instalando o Spotify...' -ForegroundColor Cyan"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Iniciando o Spotify >> "%dirsave_upped%\SpotifyLog\Log.txt"
    start /wait %downloadDir%\SpotifySetup.exe
    del /q %downloadDir%\*
    rmdir %downloadDir%
    powershell -Command "Write-Host '[INFO] Spotify instalado com sucesso!' -ForegroundColor Green"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Download Concluido >> "%dirsave_upped%\SpotifyLog\Log.txt"
    powershell -Command "Write-Host '[IMPORTANT] Faz o Login numa conta do Spotify antes de continuar!' -ForegroundColor Yellow"
    timeout /t 7 /nobreak >nul
    echo.
    powershell -Command "Write-Host '[Press Any button to continue]' -ForegroundColor blue"
    
) else (
    powershell -Command "Write-Host '[INFO] Executavel do Spotify ja encontrado.' -ForegroundColor Green"
    set "downloadDir=%userprofile%\Downloads"
    curl https://download.scdn.co/SpotifySetup.exe -o %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Baixando & Instalando o Spotify...' -ForegroundColor Cyan"
    start /wait %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Spotify instalado com sucesso!' -ForegroundColor Green"
    powershell -Command "Write-Host '[IMPORTANT] Faz o Login numa conta do Spotify antes de continuar!' -ForegroundColor Yellow"
    timeout /t 7 /nobreak >nul
    echo.
    powershell -Command "Write-Host '[Press Any button to continue]' -ForegroundColor blue"
)

:continue
title LOADING...
powershell -Command "Write-Host '[INFO] Continuando o processo...' -ForegroundColor Yellow"

:: verificar se o mod ta instalado
echo [%dia%/%mes%/%ano% %hora%:%minuto%] Verificando a existencia do Spicetify >> "%dirsave_upped%\SpotifyLog\Log.txt"
spicetify --help >nul
if %errorlevel% equ 0 (
    powershell -Command "Write-Host '[INFO] Spicetify Detectado.' -ForegroundColor Green"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Spicetify Encontrado >> "%dirsave_upped%\SpotifyLog\Log.txt"
    powershell -Command "Write-Host '[UPDATING...]' -ForegroundColor Yellow"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Update >> "%dirsave_upped%\SpotifyLog\Log.txt"
    call :task
    spicetify update
    call :end
) else (
    powershell -Command "Write-Host '[INFO] Spicetify não Detectado.' -ForegroundColor Yellow"
)


:: Se o usuario selecionar "Sim" (codigo de saída 0), prossegue
if %exitCode% equ 0 (
    title Processo em andamento...
    call :task
    powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1 | iex"
    call :task
    powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1 | iex"
    title Processo Terminado!
    powershell -Command "Write-Host '[INFO] Concluido com sucesso!' -ForegroundColor Green"
    msg * "Reabrindo o Spotify"
) else (
    powershell -Command "Write-Host '[INFO] Processo cancelado pelo usuario.' -ForegroundColor Red"
)

:: Finaliza o script
:end
echo [%dia%/%mes%/%ano% %hora%:%minuto%] END... >> "%dirsave_upped%\SpotifyLog\Log.txt"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/License.html', '%TEMP%\License.html')"
start %TEMP%\License.html
timeout /t 7 >nul
msg * "LOG foi salvo no DIR: %userprofile%/SpotifyLog"
del %TEMP%\License.html
exit

:task
tasklist | find /i "Spotify.exe" >nul
if %errorlevel% equ 0 (
    powershell -Command "Write-Host '[INFO] Fechando o Spotify...' -ForegroundColor Yellow"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Finalizando Spotify >> "%dirsave_upped%\SpotifyLog\Log.txt"
    taskkill /f /im Spotify.exe
) else (
    powershell -Command "Write-Host '[INFO] Spotify ja esta fechado, continuando o processo...' -ForegroundColor Cyan"
    echo [%dia%/%mes%/%ano% %hora%:%minuto%] Spotify Fechado! >> "%dirsave_upped%\SpotifyLog\Log.txt"
) 
