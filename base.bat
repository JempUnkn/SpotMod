::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWHreyHcjLQlHcCe7Hk6IIYA1xMzHy++UqVkSRN4SV6ub6aSBNOkV83nGYJ8h0kZ2kcgJAghdMBq/YwNU
::fBE1pAF6MU+EWHreyHcjLQlHcCe7Hk6IIYA1xMzHy++UqVkSRN4SV6ub6aSBNOkV83nodJgq5k54qoUODQ84
::fBE1pAF6MU+EWHreyHcjLQlHcCe7Hk6IIYA1xMzHy++UqVkSRN4SV6ub6aSBNOkV83nodJgq81QUmsoYbA==
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
::Zh4grVQjdCyDJGyX8VAjFDhtbiGwG16TKpEgzO3o5P6IsnEwe8Z/S5/Uzr2IOdwx/0zocaoexnVOtcQIRBZNcgaiYg46ricMtGGRNonM/V2vHgbaqE4oHgU=
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


powershell -Command "Write-Host '                                               ' -ForegroundColor Green"
powershell -Command "Write-Host '          _____ _____ _____ _____    _____ _____ ____  ' -ForegroundColor Green"
powershell -Command "Write-Host '         |   __|  _  |     |_   _|  |     |     |    \ ' -ForegroundColor Green"
powershell -Command "Write-Host '         |__   |   __|  |  | | |    | | | |  |  |  |  |' -ForegroundColor Green"
powershell -Command "Write-Host '         |_____|__|  |_____| |_|    |_|_|_|_____|____/ ' -ForegroundColor Green"
powershell -Command "Write-Host '                                               ' -ForegroundColor Green"


echo.
echo.
set "diretorio_script=%~dp0" >nul
powershell -Command "Write-Host '[INFO] O MOD foi executado a partir do diretorio: %diretorio_script%.' -ForegroundColor yellow"
set "PTBR=00000416"
set "ENUS=00000409"
for /f "tokens=3" %%A in ('reg query "HKCU\Control Panel\International" /v Locale 2^>nul') do set "locale=%%A"
if "%locale%"=="%PTBR%" (
    powershell -Command "Write-Host '[INFO] Idioma detectado PTBR.' -ForegroundColor yellow"
    call "%diretorio_script%langPTBR.bat"
) else if "%locale%"=="%ENUS%" (
    powershell -Command "Write-Host '[INFO] Language detected EN.' -ForegroundColor yellow"
    call "%diretorio_script%langEN.bat"
) else (
    powershell -Command "Write-Host '[ERROR] Language not detected.' -ForegroundColor red"
    powershell -Command "Write-Host '[INFO] Setting default language!' -ForegroundColor yellow"
    call "%diretorio_script%langEN.bat"
)



:: reg query "HKCU\Control Panel\International" /v Locale