# Gestión de discos mediante Diskpart
Herramienta de gestión de discos, volúmenes y particiones mediante la línea de comandos (herramienta Diskpart) en los sistemas operativos Windows.
## Getting Started

Proyecto creado con la finalidad de ofrecer una herramienta completa de administración de discos. Especialmente pensada para administradores de sistemas.
Se ha divido en varios scripts. Cada uno de ellos funciona independientemente de los demás, excepto Listar.bat y Borrar.bat, que son comunes a todos. Esto se realizó de esta forma para facilitar la comprensión y reducción de las líneas de código de la herramienta.

### Requisitos
* Necesario SO Windows (Windows Server para la opción de RAID-5)
### Instalación
Solo es necesario ejecutar el script "Menú.bat" desde cualquier terminal (es necesario ser administrador)
```
  .\Menu.bat
```
Nos mostrará el siguiente menú:

![cmd_2019-08-05_20-49-01](https://user-images.githubusercontent.com/51420640/62487751-ea108380-b7c2-11e9-9258-1846bfde0f0e.png)

## Despliegue de la aplicación

Es necesario saber muy bien qué hace cada script, puesto que la herramienta no pide confirmación y se puede perder información de los volúmenes. Es recomendable probarla primero en entornos virtuales o reales (en donde no nos preocupe perder datos)

Cada uno de los scripts, genera un fichero log en la carpeta correspondiente al volumen/partición creado/eliminado/modificado.
Ejemplo:

![imagen](https://user-images.githubusercontent.com/51420640/62488660-162d0400-b7c5-11e9-9d97-e7f34b8cbd48.png)



## Desarrollado con

* [Notepad++](https://notepad-plus-plus.org/) - Editor de textos utilizado
* [VirtualBox] (https://www.virtualbox.org/) - Entorno de virtualización utilizado
* [Windows Server 2008] (https://www.microsoft.com/es-es/download/details.aspx?id=5023) - Sistema operativo sobre el que se hicieron las pruebas

## Autor

* **Carlos Garcia** - *Programación, Front & BackEnd* - [c-garciao](https://gist.github.com/c-garciao)

## License

This project is licensed under the GNU License - see the [LICENSE.md](LICENSE.md) file for details

## Agradecimientos

* A Mario y Antonio, mis profesores de Sistemas Operativos.
* A mis compañeros de clase, por ayudarme cuando lo he necesitado.
