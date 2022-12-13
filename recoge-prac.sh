#!/bin/bash
#1st parameter: rutaO (ruta de origen)
#2nd parameter: rutaD (ruta de destino)

#este script se encarga de recoger las prácticas
INFORMEPATH=./informe-prac.log
echo $(date) "[OK] - Parámetros recibidos -> (recoge-prac.sh)" rutaOrigen: $1 "|" rutaDestino: $2 >> /home/daniel/Escritorio/ASO/ScriptASO/informe-prac.log

for directorio in $(find $1 -mindepth 1 -maxdepth 1 -type d)
do
	echo $(date) "[OK] - DENTRO FOR: -> (recoge-prac.sh)" $directorio $1 >> /home/daniel/Escritorio/ASO/ScriptASO/informe-prac.log
	#obtener el nombre del directorio final
	nombre="${directorio%/}"
	nombre="${nombre##*/}"
	
	#movemos el fichero a la nueva ubicacion cambiandole el nombre
	echo $(date) "[OK] - Práctica trasladada  -> (recoge-prac.sh)" Alumno: $nombre   Origen: $directorio/prac.sh   Destino: $2/$nombre.sh >> /home/daniel/Escritorio/ASO/ScriptASO/informe-prac.log
	mv $directorio/prac.sh $2/$nombre.sh	
done
