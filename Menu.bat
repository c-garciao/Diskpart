@echo off
:: ESTO TAMBIEN ES UN COMENTARIO (al igual que REM)
REM Eliminamos todos los ficheros temporales que creamos en los apartados.
REM El registro de los cambios se quedan guardados en ficheros .Log, en la carpeta Logs\<tipoVolumen\particion>. Hay logs de creacion, borrado y extension (solo V. Extendidos)
REM Igualmente, cada fichero se sobreescribe al ejecutar el script que los crea, por lo que
:: no quedaran datos residuales que puedan causar algun tipo de fallo
REM Hay un meu "generico" de BORRADO de volumenes, permitiendo eliminar mas de 130 lineas de codigo redundantes (las mismas lineas por cada tipo de volumen). Lo mismo ocurre para listar volumenes
del /Q *.txt > nul
:menu
REM Menu que llama al resto de scripts 
REM El resto de menus comparten opciones iguales: borrar, listar, salir del programa y mostrar 
:: los log en el explorador de Windows (start <ruta_logs>)
REM Para crear particion/volumen, son siempre las mismas preguntas: 
::	en que disco, tamanio, formato, etiqueta y letra
REM Se han usado colores vistosos para mayor comodidad (verde: crear, rojo: borrar, gris:listar, azul: extender)
title Menu Diskpart
cls
color 07
echo ---------------------Menu Diskpart---------------------
echo a) Particiones Primarias
echo b) Volumenes Simples
echo c) Volumenes Distribuidos
echo d) Volumenes Seccionados
echo e) Volumenes Espejados
echo f) Volumenes Raid-5
echo g) Salir del programa
echo -------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	menuPprimarias.bat
) else if "%opc%" == "b" (
	menuVSimples.bat
) else if "%opc%" == "c" (
	menuVDistribuidos.bat
) else if "%opc%" == "d" (
	menuVSeccionados.bat
) else if "%opc%" == "e" (
	menuVEspejados.bat
) else if "%opc%" == "f" (
	menuVRaid-5.bat
) else if "%opc%" == "g" (
	exit
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
pause
