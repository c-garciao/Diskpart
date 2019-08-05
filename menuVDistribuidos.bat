@echo off
if not exist Logs\VolumenDistribuido (
	mkdir Logs\VolumenDistribuido
)
:menu
title Menu Volumenes Distribuidos
del /Q lista_HD.txt > nul
del /Q borra_v_d.txt > nul
del /Q crea_v_e.txt > nul
cls
color 07
echo ---------------------Volumenes Distribuidos---------------------
echo a) Crear Volumenes Distribuidos
echo b) Borrar Volumenes
echo c) Extender Volumenes
echo d) Listar Volumenes
echo e) Volver al menu
echo f) Salir del programa
echo g) Ver logs
echo ----------------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	goto crear
) else if "%opc%" == "b" (
	echo menuVDistribuidos.bat > ultimoScript.txt
	echo Distribuido > tipo_vol.txt
	call Borrar.bat
) else if "%opc%" == "c" (
	goto extender
) else if "%opc%" == "d" (
	echo menuVDistribuidos.bat > ultimoScript.txt
	call Listar.bat
) else if "%opc%" == "e" (
	Menu.bat
) else if "%opc%" == "f" (
	exit
) else if "%opc%" == "g" (
	start %cd%\Logs\VolumenDistribuido
	goto menu
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
REM ################################################CREACION VOLUMEN DISTRIBUIDO################################################
:crear
REM
for /F "delims=" %%a in ('fsutil fsinfo drives') do set version=%%a
echo %version%>l_letras.txt
REM Manipulamos el archivo para que eliminme la primera palabra y lo volcamos en otro archivo
for /F "tokens=1,*" %%a in (l_letras.txt) do echo %%b > letras.txt
REM
cls
title Crear Volumenes Distribuidos
color 2f
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
set /p disco= Seleccione disco en el que quiera crear el volumen distribuido:
echo select disk %disco% > lista_HD.txt
REM
echo select disk %disco% > crea_v_e.txt
echo attrib disk clear readonly noerr >> crea_v_e.txt
echo online disk noerr >> crea_v_e.txt
echo convert dynamic noerr >> crea_v_e.txt
set /p tamanio= Introduzca en MB el tamanio del volumen: 
set /p formato= Introduzca un formato (NTFS,...) para el volumen: 
set /p etiqueta= Introduzca una etiqueta para el volumen: 
echo Letras EN USO:
type letras.txt
set /p letra= Introduzca una letra que NO este entre las anteriores: 
echo create volume simple size=%tamanio% noerr >> crea_v_e.txt
echo format fs=%formato% label="%etiqueta%" QUICK noerr >> crea_v_e.txt
echo assign letter=%letra% >> crea_v_e.txt
REM
set /p discoe= Seleccione disco sobre el que extender el volumen:
set /p tamanioe= Introduzca en MB el tamanio a extender: 
echo extend size=%tamanioe% disk=%discoe% >> crea_v_e.txt
echo Se va a crear el volumen. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Crear Volumen Extendido################### >> Logs\VolumenDistribuido\creacion_volumen_d.log
echo %date% %time% >> Logs\VolumenDistribuido\creacion_volumen_d.log
diskpart /s crea_v_e.txt >> Logs\VolumenDistribuido\creacion_volumen_d.log
:pregunta_crear
set /p v_simp= Desea crear mas volumenes distribuidos(si/no)?
if "%v_simp%" == "si" (
	goto crear
) else if "%v_simp%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_crear
)


:extender
REM Para extender un volumen existente, preguntamos que volumen quiere extender y
:: el disco en que lo quiera extender, asi como el tamanio. Lo volcamos a un archivo de texto
:: y lo ejecutamos. Como en cada accion, le preguntamos si desea volver a hacerla o volver al menu
cls
title Extender Volumen
color 3f
echo list volume > lista_HD.txt
diskpart /s lista_HD.txt
set /p volumen= Seleccione el volumen que quiera extender:
echo select volume %volumen% > extender_v_e.txt
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
set /p e_disco= Seleccione disco sobre el que extender el volumen:
set /p t_extiende= Seleccione el tamanio en MB para extender:
echo extend size=%t_extiende% disk=%e_disco% >> extender_v_e.txt
echo Se va a extender el volumen. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Extender Volumen################### >> Logs\VolumenDistribuido\extender_volumen_d.log
echo %date% %time% >> Logs\VolumenDistribuido\extender_volumen_d.log
diskpart /s extender_v_e.txt >> Logs\VolumenDistribuido\extender_volumen_d.log
:pregunta_extender
set /p v_simp= Desea extender mas volumenes(si/no)?
if "%v_simp%" == "si" (
	goto extender
) else if "%v_simp%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_extender
)