@echo off
title Borrar Volumenes
:borrar
REM Recogemos en una variable el volcado de un texto (=< igual y simbolo de menor, que significa recoger de en vez de volcar en)
:: en el que esta guardado el ultimo script que llamo a este script
:: Nos permite agrupar la opcion de borrado en un solo fichero , evitando la redundancia del codigo
::Tambien guardamos en otro fichero (para evitarnos problemas), el nombre y extension del script que lanza esta "funcion"
set /p llamada=<ultimoScript.txt
set /p tipo=<tipo_vol.txt
cls
title Borrar Volumenes
color cf
echo list volume > lista_HD.txt

diskpart /s lista_HD.txt
set /p volumen= Seleccione el volumen que quiera borrar:
echo select volume %volumen% > borra_v.txt

echo delete volume noerr >> borra_v.txt
echo Pulse cualquier tecla para comenzar el BORRADO del volumen (esta opcion NO se puede revertir)...
REM No podemos saber que volumen va a borrar el usuario (habria que filtrar y listar por tipos)
:: la linea siguiente indica solo desde que menu se ha llamado a este script. La linea comentada era solo una prueba
REM echo El tipo de Volumen a borrar es:%tipo%
::
REM Para que pueda funcionar para todos los scripts, guardamos la ruta en una variable
set ruta=Logs\Volumen%tipo%\borrado_volumen_%tipo%.log
REM Y le eliminamos los espacios con la siguiente instruccion
set ruta=%ruta: =%
REM Es una comprobacion, indica la ruta en la que se encuentran los log. Se ha ocultado para evitar tener texto innecesario en pantalla
REM echo la ruta es %ruta%
pause > nul
echo ###################Borrar Volumen %tipo%################### >> %ruta%
echo %date% %time% >> %ruta%
diskpart /s borra_v.txt >> %ruta%
pause
:pregunta_borrar
set /p b_vol= Desea borrar mas volumenes(si/no)?
if "%b_vol%" == "si" (
	goto borrar
) else if "%b_vol%" == "no" (
	REM Le redirigimos al comando que llamo a este fichero
	call %llamada%
) else (
	echo Error. Opcion no valida
	pause > nul
	goto pregunta_borrar
)