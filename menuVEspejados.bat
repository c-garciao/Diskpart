@echo off
if not exist Logs\VolumenEspejado (
	mkdir Logs\VolumenEspejado
)
:menu
title Menu Volumenes Espejados
del /Q lista_HD.txt > nul
del /Q borra_v_esp.txt > nul
del /Q crea_v_esp.txt > nul
cls
color 07
echo ---------------------Volumenes Espejados---------------------
echo a) Crear Volumenes Espejados
echo b) Borrar Volumenes
echo c) Listar Volumenes
echo d) Volver al menu
echo e) Salir del programa
echo f) Ver logs
echo -------------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	goto crear
) else if "%opc%" == "b" (
	echo menuVEspejados.bat > ultimoScript.txt
	echo Espejado > tipo_vol.txt
	call Borrar.bat
) else if "%opc%" == "c" (
	echo menuVEspejados.bat > ultimoScript.txt
	call Listar.bat
) else if "%opc%" == "d" (
	Menu.bat
) else if "%opc%" == "e" (
	exit
) else if "%opc%" == "f" (
	start %cd%\Logs\VolumenEspejado
	goto menu
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
REM ################################################CREACION VOLUMEN ESPEJADO################################################
:crear
REM ------------------------------------------------
for /F "delims=" %%a in ('fsutil fsinfo drives') do set version=%%a
echo %version%>l_letras.txt
REM Manipulamos el archivo para que eliminme la primera palabra y lo volcamos en otro archivo
for /F "tokens=1,*" %%a in (l_letras.txt) do echo %%b > letras.txt
REM ------------------------------------------------
cls
title Crear Volumenes Espejados
color 2f
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
REM Linea que añade una linea en blanco en el archivo (lo machaca para evitar problemas). Diskpart salta las lineas en blanco. De hacer dentro del bucle, se quedaria solo con los datos de la ultima vuelta
echo. > crea_v_esp.txt
set /p cuantos= Introduzca el numero de SOLO 2 discos que formaran el espejo SEPARADOS POR COMAS Y SIN ESPACIOS(ej: 1,3):
set lista=%cuantos%
	for %%i in (%lista%) do (
		echo select disk %%i >> crea_v_esp.txt
		echo attrib disk clear readonly noerr >> crea_v_esp.txt
		echo online disk noerr >> crea_v_esp.txt
		echo convert dynamic noerr >> crea_v_esp.txt
)
REM
set /p tamanio= Introduzca en MB el tamanio del volumen: 
set /p formato= Introduzca un formato (NTFS,...) para el volumen: 
set /p etiqueta= Introduzca una etiqueta para el volumen: 
echo Letras EN USO:
type letras.txt
set /p letra= Introduzca una letra que NO este entre las anteriores: 
echo create volume mirror size=%tamanio% disk=%cuantos% >> crea_v_esp.txt
echo format fs=%formato% label="%etiqueta%" QUICK noerr >> crea_v_esp.txt
echo assign letter=%letra% >> crea_v_esp.txt
REM
echo Se va a crear el volumen espejado. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Crear Volumen Espejado################### >> Logs\VolumenEspejado\creacion_volumen_esp.log
echo %date% %time% >> Logs\VolumenEspejado\creacion_volumen_esp.log
diskpart /s crea_v_esp.txt >> Logs\VolumenEspejado\creacion_volumen_esp.log
:pregunta_crear
set /p v_dist= Desea crear mas volumenes seccionados(si/no)?
if "%v_dist%" == "si" (
	goto crear
) else if "%v_dist%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_crear
)