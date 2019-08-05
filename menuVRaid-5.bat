@echo off
if not exist Logs\VolumenRAID5 (
	mkdir Logs\VolumenRAID5
)
:menu
title Menu Volumenes RAID-5
del /Q lista_HD.txt > nul
del /Q borra_v_raid5.txt > nul
del /Q crea_v_raid5.txt > nul
cls
color 07
echo ---------------------Volumenes RAID-5---------------------
echo a) Crear Volumen RAID-5
echo b) Borrar Volumenes
echo c) Listar Volumenes
echo d) Volver al menu
echo e) Salir del programa
echo f) Ver logs
echo ----------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	goto crear
) else if "%opc%" == "b" (
	echo menuVRaid-5.bat > ultimoScript.txt
	echo RAID5 > tipo_vol.txt
	call Borrar.bat
) else if "%opc%" == "c" (
	echo menuVRaid-5.bat > ultimoScript.txt
	call Listar.bat
) else if "%opc%" == "d" (
	Menu.bat
) else if "%opc%" == "e" (
	exit
) else if "%opc%" == "f" (
	start %cd%\Logs\VolumenRAID5
	goto menu
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
REM ################################################CREACION VOLUMEN RAID-5################################################
:crear
REM ------------------------------------------------
REM Listamos las letras usadas en el momento de ejecucion (fsutil fsinfo drives), lo vuelca
:: en 
for /F "delims=" %%a in ('fsutil fsinfo drives') do set version=%%a
echo %version%>l_letras.txt
REM Manipulamos el archivo para que elimine la primera palabra y lo volcamos en otro archivo
for /F "tokens=1,*" %%a in (l_letras.txt) do echo %%b > letras.txt
REM ------------------------------------------------
cls
title Crear Volumenes Espejados
color 2f
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
REM Linea que añade una linea en blanco en el archivo (lo machaca para evitar problemas). Diskpart salta las lineas en blanco. De hacer dentro del bucle, se quedaria solo con los datos de la ultima vuelta
echo. > crea_v_raid5.txt
set /p cuantos= Introduzca el numero de los discos(minimo 3) que formaran el espejo SEPARADOS POR COMAS Y SIN ESPACIOS(ej: 1,2,3):
REM Bucle que selecciona los discos introducidos, les [borra] el atributo solo lectura y los [convierte] en dinamicos
set lista=%cuantos%
	for %%i in (%lista%) do (
		echo select disk %%i >> crea_v_raid5.txt
		echo attrib disk clear readonly noerr >> crea_v_raid5.txt
		echo online disk noerr >> crea_v_raid5.txt
		echo convert dynamic noerr >> crea_v_raid5.txt
)
REM
set /p tamanio= Introduzca en MB el tamanio de cada HD del volumen RAID-5: 
set /p formato= Introduzca un formato (NTFS,...) para el volumen: 
set /p etiqueta= Introduzca una etiqueta para el volumen: 
echo Letras EN USO:
type letras.txt
set /p letra= Introduzca una letra que NO este entre las anteriores: 
echo create volume raid size=%tamanio% disk=%cuantos% >> crea_v_raid5.txt
echo format fs=%formato% label="%etiqueta%" QUICK noerr >> crea_v_raid5.txt
echo assign letter=%letra% >> crea_v_raid5.txt
REM
echo Se va a crear el volumen espejado. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Crear Volumen RAID-5################### >> Logs\VolumenRAID5\creacion_volumen_esp.log
echo %date% %time% >> Logs\VolumenRAID5\creacion_volumen_esp.log
diskpart /s crea_v_raid5.txt >> Logs\VolumenRAID5\creacion_volumen_esp.log
:pregunta_crear
set /p v_r5= Desea crear mas volumenes seccionados(si/no)?
if "%v_r5%" == "si" (
	goto crear
) else if "%v_r5%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_crear
)
