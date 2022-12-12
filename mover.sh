#!/bin/bash

for directorio in $(find /home/daniel/Escritorio/ASO/practicas -mindepth 1 -maxdepth 1 -type d)
do
	nombre="${directorio%/}"
	nombre="${nombre##*/}"
	echo $directorio es un Directorio que se llama $nombre;
	
	mv $directorio/prac.sh /home/daniel/Escritorio/ASO/pracASO/$nombre.sh
done
