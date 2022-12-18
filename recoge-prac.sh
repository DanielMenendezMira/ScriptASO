#!/bin/bash
#1st parameter: rutaO (ruta de origen)
#2nd parameter: rutaD (ruta de destino)

#este script se encarga de recoger las prácticas
INFORMEPATH=./informe-prac.log
echo $(date) "[OK] - Parámetros recibidos -> (recoge-prac.sh)" rutaOrigen: $1 "|" rutaDestino: $2 >> $INFORMEPATH

for directorio in $(find $1 -mindepth 1 -maxdepth 1 -type d)
do
	#obtener el nombre del directorio final
	nombre="${directorio%/}" #separo la ruta por los campos /
	nombre="${nombre##*/}" #me quedo con el campo tras la ultima / para aislar el nombre del fichero
	
	#movemos el fichero a la nueva ubicacion cambiandole el nombre por el del alumno
	echo $(date) "[OK] - Práctica trasladada  -> (recoge-prac.sh)" Alumno: $nombre   Origen: $directorio/prac.sh   Destino: $2/$nombre.sh >> $INFORMEPATH
	mv $directorio/prac.sh $2/$nombre.sh	
done
