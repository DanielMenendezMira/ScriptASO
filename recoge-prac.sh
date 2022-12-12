#!/bin/bash
#1st parameter: rutaO (ruta de origen)
#2nd parameter: rutaD (ruta de destino)

#este script se encarga de recoger las prácticas
INFORMEPATH=./informe-prac.log
echo rutaOrigen: $1 >> /home/daniel/Escritorio/ASO/ScriptASO/informe-prac.log
echo rutaDestino: $2 >> /home/daniel/Escritorio/ASO/ScriptASO/informe-prac.log

for directorio in $(find $1 -mindepth 1 -maxdepth 1 -type d)
do
	#obtener el nombre del directorio final
	nombre="${directorio%/}"
	nombre="${nombre##*/}"
	echo $directorio es un Directorio que se llama $nombre >> $INFORMEPATH;
	
	#movemos el archivo a la nueva ubicacion
	mv $directorio/prac.sh $2/$nombre.sh
	echo $(date) "[OK] - Practica trasladada ->" Alumno: $nombre;   Origen: $directorio/prac.sh;   Destino: $2/$nombre.sh
done
