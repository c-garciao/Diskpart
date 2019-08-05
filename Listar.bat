@echo off
title Listar Volumenes
REM Al igual que el script "Borrar.bat", este esta hecho para tener un solo comando para listar
:: volumenes. Es llamado igual que el de Borrar, tan solo pasandole un parametro, el nombre del script que lo invoca
::Permite aligerar el codigo de los scirpts
:listar
set /p llamada=<ultimoScript.txt
cls
title Listar Volumenes
color 8f
REM Volcamos en un temporal los volumenes que hay en el momento de la ejecucion del script
echo list volume > lista_HD.txt
echo Se van a mostrar las volumenes. Pulse cualquier tecla para continuar...
pause > nul
cls
diskpart /s lista_HD.txt
echo Pulse cualquier tecla para volver al menu...
pause > nul
REM Lanzamos el archivo que llamo a esta funcion
call %llamada%