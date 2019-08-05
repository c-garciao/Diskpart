@echo off
if not exist Logs\VolumenSeccionado (
	mkdir Logs\VolumenSeccionado
)


:menu
title Menu Volumenes Seccionados
del /Q lista_HD.txt > nul
del /Q borra_v_s.txt > nul
del /Q crea_v_s.txt > nul
cls
color 07
REM color 3f
echo ---------------------Volumenes Seccionados---------------------
echo a) Crear Volumenes Seccionados
echo b) Borrar Volumenes
echo c) Listar Volumenes
echo d) Volver al menu
echo e) Salir del programa
echo f) Ver logs
echo ---------------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	goto crear
) else if "%opc%" == "b" (
	echo menuVSeccionados.bat > ultimoScript.txt
	echo Seccionado > tipo_vol.txt
	call Borrar.bat
) else if "%opc%" == "c" (
	echo menuVSeccionados.bat > ultimoScript.txt
	call Listar.bat
) else if "%opc%" == "d" (
	Menu.bat
) else if "%opc%" == "e" (
	exit
) else if "%opc%" == "f" (
	start %cd%\Logs\VolumenSeccionado
	goto menu
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
REM ################################################CREACION VOLUMEN DISTRIBUIDO################################################
:crear
REM ------------------------------------------------
for /F "delims=" %%a in ('fsutil fsinfo drives') do set version=%%a
echo %version%>l_letras.txt
REM Manipulamos el archivo para que eliminme la primera palabra y lo volcamos en otro archivo
for /F "tokens=1,*" %%a in (l_letras.txt) do echo %%b > letras.txt
REM del /Q l_letras.txt > nul
REM ------------------------------------------------
REM SIEMPRE al a hora de CREAR particiones/volumenes:
::	Seleccionar discos
::	Eliminar atributo de solo lectura
::	Ponerlos online
::	Convertirlos a dinamico
::	Todo ello acompaniado de la orden "noerr", que permite que siga la ejecucion de los comandos aun cuando encuentre errores (no interrumpe la ejecucion)
cls
title Crear Volumenes Seccionados
color 2f
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
echo. > crea_v_s.txt
REM Se introducen los discos que van a formar el volumen seccionado de la forma indicada.
::El bucle recorre uno a uno los numeros sin tener en cuenta las comas (pero SI los espacios)
:: e imprime las ordenes en el fichero de configuracion.
:: Este bucle se usa tambien para RAID5. Una vez creados, NO es posible su modificacion/extension
echo Introduzca el numero de los discos que formaran el volumen
set /p cuantos= seccionado SEPARADOS POR COMAS Y SIN ESPACIOS(ej: 1,2,3):
set lista=%cuantos%
	for %%i in (%lista%) do (
		echo select disk %%i >> crea_v_s.txt
		echo attrib disk clear readonly noerr >> crea_v_s.txt
		echo online disk noerr >> crea_v_s.txt
		echo convert dynamic noerr >> crea_v_s.txt
)
REM
set /p tamanio= Introduzca en MB el tamanio del volumen: 
set /p formato= Introduzca un formato (NTFS,...) para el volumen: 
set /p etiqueta= Introduzca una etiqueta para el volumen: 
echo Letras EN USO:
type letras.txt
set /p letra= Introduzca una letra que NO este entre las anteriores: 
echo create volume stripe size=%tamanio% disk=%cuantos% >> crea_v_s.txt
echo format fs=%formato% label="%etiqueta%" QUICK noerr >> crea_v_s.txt
echo assign letter=%letra% >> crea_v_s.txt
REM
echo Se va a crear el volumen seccionado. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Crear Volumen Seccionado################### >> Logs\VolumenSeccionado\creacion_volumen_s.log
echo %date% %time% >> Logs\VolumenSeccionado\creacion_volumen_s.log
diskpart /s crea_v_s.txt >> Logs\VolumenSeccionado\creacion_volumen_s.log
:pregunta_crear
set /p v_sec= Desea crear mas volumenes seccionados(si/no)?
if "%v_sec%" == "si" (
	goto crear
) else if "%v_sec%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_crear
)