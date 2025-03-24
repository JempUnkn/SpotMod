#include <stdio.h>
// #include <unistd.h>
#include <stdlib.h>

int main(){
    // printf("TESTE\n");
    // exec um alternativo de :   powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/base.bat' -OutFile \"$env:TEMP\\base.bat\"; cmd /c \"$env:TEMP\\base.bat\"; Remove-Item \"$env:TEMP\\base.bat\""
    // system('@echo off && call C:/Users/CYBERGUILD/LangEN.bat');
    system("@echo off && title Setting...");
    system("curl -s \"https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/base.bat\" -o \"%TEMP%\\base.bat\"");
    system("cmd /c \"%TEMP%\\base.bat\"");
    system("del \"%TEMP%\\base.bat\"");
    return 0;
}