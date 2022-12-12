#!/bin/bash


INFORMEPATH=./informe-prac.log

menu(){

    echo -e "\n";
    echo ASO 22/23 - Practica 6
    echo Daniel Menéndez Mira;
    echo -e "\n";
    echo Gestión de Prácticas;
    echo ----------------------;
    echo -e "\n";
    echo Menú;
    echo    1')' Programar recogida de prácticas;
    echo    2')' Empaquetado de prácticas de una asignatura;
    echo    3')' Ver tamaño y fecha del ficehro de una asignatura;
    echo    4')' Finalizar programa;
    echo -e "\n";
    read -p "Opción: " option
    
    case $option in 
        1)
            echo opcion 1 
            menu1
            ;;
        2)
            echo opcion 2
            menu2
            ;;
        3)
            echo opcion 3
            menu3
            ;;
        4)
            echo opcion 4
            exit
            ;;
    esac
}

menu1(){
    existe=false
    echo -e "\n"
    echo Menú 1 - Programar recogida de prácticas
    echo -e "\n"
    read -p "Asignatura cuyas prácticas desea recoger: " asignatura
    #compruebo que el directorio de origen existe
    while [ "$existe" = false ] 
    do
    	read -p "Ruta con las cuentas de los alumnos: " rutaO
    	if [ -d $rutaO ]
    	then
    		existe=true
    	else
    		echo $(date) "[ERROR] - Directorio_Origen -> (gestiona-prac.sh)" El directorio de origen: $rutaO no existe >> $INFORMEPATH
    		echo -e "\n"
    		echo [ERROR] El directorio de origen: $rutaO no existe
    		echo Por favor, introduzca una ruta válida
    		echo -e "\n"
    	fi
    done
    
    #ahora compruebo si el directorio destino existe. Si no exite, lo creo (al menos el usuario se cerciora de donde va a meter las cosas)
    res=n
    while [ "$res" = n ]
    	do
    	read -p "Ruta para almacenar prácticas: " rutaD
    	
    	if [ ! -d $rutaD ]
    	then 
    		read -p "El directorio de destino no exite. ¿Desea crearlo ahora? (s/n) " res
    	
    		if [ "$res" = s ]
    		then
    		    res=s
    		    mkdir $rutaD   	
    		    echo El directorio de destino ha sido creado
    		    echo $(date) "[OK] - Creado el directorio -> (gestiona-prac.sh)" $rutaD >> $INFORMEPATH
    		else
    		    echo Debe especificar un directorio para almacenar las prácticas
    		fi
    	else
    		res=s #si el directorio ya existe pongo res=s y sale del bucle
    	fi
    done
    
    #confirmo la informacion 
    echo -e "\n"
    echo Se va a programar la recogida de las prácticas de $asignatura para
    echo mañana a las 8:00. Origen: $rutaO   Destino: $rutaD
    echo -e "\n"
    read -p "¿Está de acuerdo? (s/n)" resp
    #MODIFICAR ESTO pra evitar valores de $resp indeseados (distintos de s/n)
    if [ "$resp" = s ]
    then
    	#añadimos una tarea a cron para que ejecute "recoge-prac.sh" mañana a las 8:00 con los parametros recogidos 
	day=$(date --date="next day" +%d)
	month=$(date --date="next day" +%m)	
	
	#REVISAR: sin permisos root no deja acceder al directorio /crontabs
	
	#BORRAR ESTAS DOS LINEAS, SON LAS PRUEBAS:	
	#echo 13 17 12 12 "*" bash /home/daniel/Escritorio/ASO/ScriptASO/recoge-prac.sh $rutaO $rutaD >> /var/spool/cron/crontabs/root	
	#echo 13 17 12 12 "* cd /home/daniel/Escritorio; touch funciona.txt" >>	/var/spool/cron/crontabs/root
	
	#DESCOMENTAR LA SIGIUENTE LINEA:	
    	echo 00 08 $day $month "*" bash /home/daniel/Escritorio/ASO/ScriptASO/recoge-prac.sh $rutaO $rutaD >> /var/spool/cron/crontabs/root
    	
    	echo $(date) "[OK] - Tarea añadida a cron -> (gestiona-prac.sh)" 00 08 $day $month "*" bash /home/daniel/Escritorio/ASO/ScriptASO/recoge-prac.sh $rutaO $rutaD >> $INFORMEPATH
	echo Se ha programado correctamente la recogida de las prácticas de $asignatura para mañana $day/$month a las 08:00.
    fi
    
    menu
}

menu2(){
    echo -e "\n"
    echo Menú 2 - Empaquetar prácticas de la asignatura
    echo -e "\n"
    read -p "Asignatura cuyas prácticas desea empaquetar: " asignatura
    read -p "Ruta absoluta del directorio de prácticas: " rutaAbs
    
    if [ -d $rutaAbs ] #Si el directorio especificado existe, sigo ejecutando
    then
    	echo -e "\n" 
    	echo Se van a empaquetar las prácticas de la asignatura $asignatura 
    	echo presentes en el directorio $rutaAbs
    	echo -e "\n"
    	read -p "¿Está de acuerdo? (s/n) " resp
    	#Comprimo los ficheros existentes en el directorio especificado
    	
    	#obtener el nombre del directorio final
	nombreDir="${rutaABS%/}"
	nombreDir="${nombreDir##*/}"
    	
    	cd $rutaABS/.. ; 
    	sleep 1
    	tar -cf $asignatura.tar $nombreDir
    	sleep 1
    	mv $asignatura.tar $rutaABS
    	echo [OK] se ha empaquetado el directorio $rutaABS con las prácticas de la asignatura $asignatura 
    	echo      en el directorio $rutaABS bajo el nombre $asignatura.tar
    	
    	#sintaxis: tar -cf nombreArchivo.tar comprimir1.sh comprimir2.sh
    	
    else #Si el directorio no erxiste, informa del error y vuelve al menu principal
    	echo "[Error] El directorio especificado no existe"
    	echo $(date) "[ERROR] - Directorio_Origen -> (gestiona-prac.sh)" No es posible empaquetar. El directorio de origen: $rutaAbs no existe >> $INFORMEPATH	
    fi
    
    menu
}

menu3(){
    echo -e "\n"
    echo Menú 3 - Obtener nombre y tamaño del fichero
    echo -e "\n"
    read -p "Asignatura sobre la que queremos información: " asignatura
    #SALIDA: El fichero generado es (por ejemplo): aso-221013.tgz y ocupa <n> bytes.
}

menu    #NO BORRAR ESTO
