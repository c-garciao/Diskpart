@echo off
title Menu Particiones Primarias
if not exist Logs\ParticionesPrimarias (
	mkdir Logs\ParticionesPrimarias
)
del /Q lista_HD.txt > nul
del /Q borra_p_prim.txt > nul
del /Q crea_p_prim.txt > nul
:menu
title Menu Particion Primarias
cls
color 07
echo ---------------------Particion Primarias---------------------
echo a) Crear Particiones
echo b) Borrar Particiones
echo c) Listar particiones
echo d) Volver al menu
echo e) Salir del programa
echo f) Ver logs
echo -------------------------------------------------------------
echo Seleccione una opcion:
set /p opc=
if "%opc%" == "a" (
	goto crear
) else if "%opc%" == "b" (
	goto borrar
) else if "%opc%" == "c" (
	goto listar
) else if "%opc%" == "d" (
	Menu.bat
) else if "%opc%" == "e" (
	exit
) else if "%opc%" == "f" (
	start %cd%\Logs\ParticionesPrimarias
	goto menu
) else (
	echo Error. Introduzca una opcion valida.
	pause > nul
	goto menu
)
pause

:crear
color 2f
REM Variable que muestra el numero de particion que se va a ejecutar (por si se quiere crear mas de 1 a la vez)
set num_part=1
REM Vuelca la salida de un comando en un fichero SIN espacios ni tabulaciones
for /F "delims=" %%a in ('fsutil fsinfo drives') do set version=%%a
echo %version%>l_letras.txt
REM Esta linea lo procesa y elimina la primera palabra (para que solo se muestren las letras)
for /F "tokens=1,*" %%a in (l_letras.txt) do echo %%b > letras.txt
REM
cls
title Crear Particiones Primarias
color 2f
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
set /p disco= Seleccione disco en el que quiera crear particiones: 
cls
echo select disk %disco% > crea_p_prim.txt
echo attrib disk clear readonly noerr >> crea_p_prim.txt
echo online disk noerr >> crea_p_prim.txt
echo convert GPT noerr >> crea_p_prim.txt

set /p n_part= Seleccione cuantas particiones primarias quiere hacer: 
set contador=0
REM Incrementamos el contador por cada particion primaria que realice hasta que coincida
:: con el numero de particiones que quiera hacer el usuario. Se intento usar una estructura
:: FOR, pero la misma no deja realizar asignaciones dentro de ella
:preg
REM Aniadiremos al fichero de letras las que vaya asignado el usuario (por si hace varias particiones de una vez)

set /p tamanio= Introduzca en MB el tamanio de la particion numero %num_part%: 
set /p formato= Introduzca un formato (NTFS, FAT32) para la particion numero %num_part%: 
set /p etiqueta= Introduzca una etiqueta para la particion numero %num_part%: 
echo Letras EN USO:
type letras.txt
set /p letra= Introduzca una letra que NO este entre las anteriores: 
echo create partition primary size=%tamanio% >> crea_p_prim.txt
REM Aniadimos manualmente la letra que hemos "reservado", ya que hasta que no ejecute el sript de diskpart, seguiran estando disponibles. 
REM De esta forma, nos aseguramos que el usuario sepa siempre que letras estan OCUPADAS
echo %letra%:\ >> letras.txt
echo format fs=%formato% label="%etiqueta%" QUICK >> crea_p_prim.txt
echo assign letter=%letra% >> crea_p_prim.txt
set /a contador=%contador%+1
set /a num_part=%num_part%+1
if not %contador% == %n_part% (goto preg)

echo Se va a crear la particion. Pulse cualquier tecla para empezar...
pause > nul
echo ###################Crear Particion Primaria################### >> Logs\ParticionesPrimarias\creacion_p_prim.log
echo %date% %time% >> Logs\ParticionesPrimarias\creacion_p_prim.log
diskpart /s crea_p_prim.txt >> Logs\ParticionesPrimarias\creacion_p_prim.log
REM Preguntamos siempre si desea volver a realizar la accion
:pregunta_crear
set /p crear_p= Desea crear mas Particiones(si/no)?
if "%crear_p%" == "si" (
	goto crear
) else if "%crear_p%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_crear
)
:borrar
REM Seleccionamos una particion de un disco y la eliminamos
cls
title Borrar Particiones
color cf
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
set /p disco= Seleccione disco del que quiera borrar particiones:
echo select disk %disco% > lista_HD.txt
echo list partition >> lista_HD.txt
cls
diskpart /s lista_HD.txt
set /p particion= Seleccione particion a borrar:
REM Machacamos el archivo para evitar posibles problemas
echo select disk %disco% > borra_p_prim.txt
echo online disk noerr >> borra_p_prim.txt
echo attrib disk clear readonly noerr >> borra_p_prim.txt
echo select partition %particion% >> borra_p_prim.txt
echo delete partition override noerr >> borra_p_prim.txt
echo Pulse cualquier tecla para comenzar el BORRADO de la particion (NO se puede revertir)...
pause > nul
echo ###################Borrar Particion Primaria################### >> Logs\ParticionesPrimarias\borrado_p_prim.log
diskpart /s borra_p_prim.txt >> Logs\ParticionesPrimarias\borrado_p_prim.log
pause
:pregunta_borrar
set /p borrar_p= Desea borrar mas Particiones(si/no)?
if "%borrar_p%" == "si" (
	goto borrar
) else if "%borrar_p%" == "no" (
	goto menu
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_borrar
)
:listar
REM Volcamos en un temporal las particiones que hay en el momento de la ejecucion del script
cls
title Listar Particiones
echo list disk > lista_HD.txt
diskpart /s lista_HD.txt
set /p disco= Seleccione disco:
echo select disk %disco% > lista_HD.txt
echo online disk noerr >> lista_HD.txt
echo list partition >> lista_HD.txt
echo Se van a mostrar las particiones del disco: %disco%. Pulse cualquier tecla para continuar...
pause > nul
cls
diskpart /s lista_HD.txt
echo Pulse cualquier tecla para volver al menu...
pause > nul
goto menu