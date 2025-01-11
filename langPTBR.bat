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
if not exist "%userprofile%\SpotifyLog\Log.txt" (
    mkdir "%userprofile%\SpotifyLog" >nul
    if %errorlevel% neq 0 (
        msg * Erro ao criar um Diretorio LOG para o SpotMod
        powershell -Command "Write-Host '[Error]: Tentativa de criacao do Diretorio Log' -ForegroundColor Red"
    ) else (
        powershell -Command "Write-Host '[INFO] Diretorio Log criado com sucesso!' -ForegroundColor Green"
    )
) else (
    echo Processo Iniciado {%hora%:%minuto%} no dia {%dia%/%mes%/%ano%} >> "%userprofile%\SpotifyLog\Log.txt"
)
curl -s https://itigic.com/wp-content/uploads/2020/01/ping-command.jpg --output "%userprofile%\net.jpg"
if %errorlevel% neq 0 (
    msg * "Disconectado a uma rede"
    powershell -Command "Write-Host '[Error]: Sem Internet' -ForegroundColor Red"
    timeout /t 5 /nobreak >nul  
    exit
) else (
    powershell -Command "Write-Host '[INFO] Conectado a uma rede....' -ForegroundColor Green"
    del %userprofile%\net.jpg >nul
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
    goto verificacao
) else (
    powershell -Command "Write-Host '[CANCELANDO...]' -ForegroundColor red" 
)

:: Exclui o arquivo temporário
timeout /t 3 /nobreak >nul
del temp.vbs
exit /b
pause



:verificacao
powershell -Command "Write-Host '[INFO] Verificando se o Spotify esta instalado' -ForegroundColor Cyan"
if exist %userprofile%\AppData\Roaming\Spotify\Spotify.exe (
    powershell -Command "Write-Host '[INFO] Spotify Instalado' -ForegroundColor Green"
    goto :continue
)

rem Caso o Spotify nao esteja instalado
powershell -Command "Write-Host '[INFO] Spotify nao instalado!' -ForegroundColor Yellow"
timeout /t 3 /nobreak >nul

rem Procurando o executavel do Spotify
title Downloading...
powershell -Command "Write-Host '[INFO] Procurando o executavel do Spotify...' -ForegroundColor Cyan"
if not exist "%userprofile%\Downloads\SpotifySetup.exe" (
    powershell -Command "Write-Host '[INFO] Executavel do Spotify nao encontrado!' -ForegroundColor Red"
    powershell -Command "Write-Host '[INFO] Baixando o Spotify...' -ForegroundColor Yellow"
    set downloadDir=%temp%\spotmod
    mkdir %downloadDir%
    curl https://download.scdn.co/SpotifySetup.exe -o %downloadDir%\SpotifySetup.exe
    powershell -Command "Write-Host '[INFO] Baixando & Instalando o Spotify...' -ForegroundColor Cyan"
    start /wait %downloadDir%\SpotifySetup.exe
    del /q %downloadDir%\*
    rmdir %downloadDir%
    powershell -Command "Write-Host '[INFO] Spotify instalado com sucesso!' -ForegroundColor Green"
    powershell -Command "Write-Host '[IMPORTANT] Faz o Login numa conta do Spotify antes de continuar!' -ForegroundColor Yellow"
    timeout /t 7 /nobreak >nul
    echo.
    powershell -Command "Write-Host '[Press Any button to continue]' -ForegroundColor blue"
    
) else (
    powershell -Command "Write-Host '[INFO] Executavel do Spotify ja encontrado.' -ForegroundColor Green"
    set downloadDir=%userprofile%\Downloads
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
spicetify --help >nul
if %errorlevel% equ 0 (
    powershell -Command "Write-Host '[INFO] Spicetify Detectado.' -ForegroundColor Green"
    powershell -Command "Write-Host '[UPDATING...]' -ForegroundColor Yellow"
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
    powershell -Command "Write-Host '[INFO] Processo cancelado pelo usuario.' -ForegroundColor Yellow"
)

:: Finaliza o script
:end
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/License.html', '%TEMP%\License.html')"
start %TEMP%\License.html
timeout /t 2 >nul
del %TEMP%\License.html
exit

:task
tasklist | find /i "Spotify.exe" >nul
if %errorlevel% equ 0 (
    powershell -Command "Write-Host '[INFO] Fechando o Spotify...' -ForegroundColor Yellow"
    taskkill /f /im Spotify.exe
) else (
    powershell -Command "Write-Host '[INFO] Spotify ja esta fechado, continuando o processo...' -ForegroundColor Cyan"
)
