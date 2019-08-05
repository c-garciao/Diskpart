@echo off
if not exist Logs\VolumenSimple (
	mkdir Logs\VolumenSimple
)
:menu
title Menu Volumenes Simples
REM Borramos los archivos temporales de listado, creacion y borrado de los volumenes
REM  (se vuelve siempre al menu antes de porder salir del programa, salvo interrupcion del usuario)
REM Usamos el modificador /Q para que sea silencioso, sin pedir confirmacion. La salida la redirigimos a nul (nulo)
del /Q  lista_HD.txt > nul
del /Q  borra_v.txt > nul
del /Q  crea_v.txt > nul
cls
color 07
echo ---------------------Volumenes Simples---------------------
echo a) Crear Volumenes
echo b) Borrar Volumenes
echo c) Listar Volumenes
echo d) Volver al menu
echo e) Salir del programa
echo f) Ver logs
echo -----------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	goto crear
) else if "%opc%" == "b" (
	echo menuVsimples.bat > ultimoScript.txt
	echo Simple > tipo_vol.txt
	call Borrar.bat
) else if "%opc%" == "c" (
	echo menuVsimples.bat > ultimoScript.txt
	call Listar.bat
) else if "%opc%" == "d" (
	Menu.bat
) else if "%opc%" == "e" (
	exit
) else if "%opc%" == "f" (
	start %cd%\Logs\VolumenSimple
	goto menu
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
REM ################################################CREACION VOLUMEN SIMPLE################################################
:crear
REM1
for /F "delims=" %%a in ('fsutil fsinfo drives') do set version=%%a
echo %version%>l_letras.txt
REM Manipulamos el archivo para que eliminme la primera palabra y lo volcamos en otro archivo
for /F "tokens=1,*" %%a in (l_letras.txt) do echo %%b > letras.txt
REM
cls
title Crear Volumenes
color 2f
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
set /p disco= Seleccione disco en el que quiera crear volumen/es:
echo select disk %disco% > lista_HD.txt
echo select disk %disco% > crea_v.txt
echo attrib disk clear readonly noerr >> crea_v.txt
echo online disk noerr >> crea_v.txt
echo convert dynamic noerr >> crea_v.txt
set /p tamanio= Introduzca en MB el tamanio del volumen: 
set /p formato= Introduzca un formato (NTFS,...) para el volumen: 
set /p etiqueta= Introduzca una etiqueta para el volumen: 
echo Letras EN USO:
type letras.txt
set /p letra= Introduzca una letra que NO este entre las anteriores: 
echo create volume simple size=%tamanio% noerr >> crea_v.txt
echo format fs=%formato% label="%etiqueta%" QUICK noerr >> crea_v.txt
echo assign letter=%letra% >> crea_v.txt
echo Se va a crear el volumen. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Crear Volumen Simple################### >> Logs\VolumenSimple\creacion_volumen_s.log
echo %date% %time% >> Logs\VolumenSimple\creacion_volumen_s.log
diskpart /s crea_v.txt >> Logs\VolumenSimple\creacion_volumen_s.log
:pregunta_crear
set /p v_simp= Desea crear mas volumenes simples(si/no)?
if "%v_simp%" == "si" (
	goto crear
) else if "%v_simp%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_crear
)