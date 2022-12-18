#!/bin/bash


INFORMEPATH=./informe-prac.log
PWD=$(pwd)
menu(){

    echo -e "\n"
    echo ASO 22/23 - Practica 6
    echo Daniel Menéndez Mira
    echo -e "\n"
    echo "***********************************************"
    echo "*           GESTIÓN DE PRÁCTICAS              *"
    echo "***********************************************"
    echo -e "\n"
    echo Menú principal;
    echo    1')' Programar recogida de prácticas
    echo    2')' Empaquetado de prácticas de una asignatura
    echo    3')' Ver tamaño y fecha del ficehro de una asignatura
    echo    4')' Finalizar programa
    echo -e "\n"
    read -p "Opción: " option
    
    case $option in 
        1)
            menu1
            ;;
        2)
            menu2
            ;;
        3)
            menu3
            ;;
        4)
            echo "***********************************************"
            echo "*             FIN DEL PROGRAMA                *"
            echo "***********************************************"
            sleep 1
            exit
            ;;
    esac
}

menu1(){
    existe=false #para comprobar si los directorios existen
    echo -e "\n"
    echo Menú 1 - Programar recogida de prácticas
    echo ----------------------------------------
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
    		echo $(date) "[ERROR] - Directorio_Origen  -> (gestiona-prac.sh)" El directorio de origen: $rutaO no existe >> $INFORMEPATH
    		echo -e "\n"
    		echo [ERROR] El directorio de origen: $rutaO no existe
    		echo Por favor, introduzca una ruta válida
    		echo -e "\n"
    	fi
    done
    
    #ahora compruebo si el directorio destino existe. Si no exite, lo creo pero preguntando al usuario, ya que es posible que simplemente haya escrito mal la ruta y le evito empezar todo de nuevo
    existe=false
    while [ "$existe" == false ]
    	do
    	
    	read -p "Ruta para almacenar prácticas: " rutaD
    	
    	if [ ! -d $rutaD ] #si el directorio de destino no existe
    	then 
    		read -p "El directorio de destino no exite. ¿Desea crearlo ahora? (s/n) " respuesta
    	
    		if [ "$respuesta" == s ] || [ "$respuesta" == S ]
    		then
    		    mkdir $rutaD 
    		    existe=true #para que en la proxima comprobacin del while salga directamente en lugar de dar otras 2 vueltas mas  	
    		    echo El directorio de destino $rutaD ha sido creado
    		    echo $(date) "[OK] - Creado el directorio -> (gestiona-prac.sh)" $rutaD >> $INFORMEPATH
    		else
    		    echo Debe especificar un directorio para almacenar las prácticas
    		fi
    	else
    		existe=true #si el directorio ya existe pongo existe=true y sale del bucle
    	fi
    done
    
    #confirmo la informacion 
    echo -e "\n"
    echo Se va a programar la recogida de las prácticas de $asignatura para
    echo mañana a las 8:00. Origen: $rutaO   Destino: $rutaD
    echo -e "\n"
    read -p "¿Está de acuerdo? (s/n)" resp
    
    if [ "$resp" == s ] || [ "$resp" == S ]
    then
    	#añadimos la tarea a cron para que ejecute "recoge-prac.sh" mañana a las 8:00 con los parametros recogidos 
	day=$(date --date="next day" +%d)
	month=$(date --date="next day" +%m)
	#----(PROBAR ESTO) con esto evitamos que se sobreescriba el cron cada vez que añadimos una nueva tarea
	crontab -l | cat >> aux.txt #creo un txt temporal donde copio lo que haya en en el cron
	echo 37 20 15 12 "*" bash $PWD/recoge-prac.sh $rutaO $rutaD >> aux.txt #añado la tarea al txt
	cat aux.txt | crontab - #meto todo de nuevo al cron
	rm aux.txt #elimino el txt
	#----
    	echo $(date) "[OK] - Tarea añadida a cron -> (gestiona-prac.sh)" 37 20 $day $month "*" bash $PWD/recoge-prac.sh $rutaO $rutaD >> $INFORMEPATH
	echo Se ha programado correctamente la recogida de las prácticas de $asignatura para mañana $day/$month a las 08:00.
    else
        #si la respuesta es distinta se "s" se vuelve a ejecutar el menu1 de forma recursiva
        menu1    
    fi
    
    menu
}

menu2(){
    echo -e "\n"
    echo Menú 2 - Empaquetar prácticas de la asignatura
    echo ----------------------------------------------
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
    	
    	if [ "$resp" == s ] || [ "$resp" == S ] #Confirmacion
    	then
	    	#Comprimo los ficheros existentes en el directorio especificado:   	
	    	
	    	#1.-obtener el nombre del directorio final
		nombreDir="${rutaAbs%/}" #separo la ruta por los campos /
		nombreDir="${nombreDir##*/}" #me quedo con el campo tras la ultima / para aislar el nombre del fichero
		#2.-Añado al .log los parametros recibidos para la compresion
	    	echo $(date) "[OK] - Parámetros recibidos: -> (gestiona-prac.sh)" Empaquetar asignatura $asignatura. Directorio de Origen: $rutaAbs. Nombre del ultimo directorio: $nombreDir >> $INFORMEPATH
	    	#3.-Me muevo al directorio superior
	    	cd $rutaAbs/.. ; 
	    	#4.-Comprimo la carpeta completa para que al descomprimir no se desparramen todas las practicas
	    	tar cfz $rutaAbs/$asignatura-$(date +%y%m%d).tgz $nombreDir
	    	tar cfz $rutaAbs/$asignatura-251222.tgz $nombreDir
	    	barraProgreso #lo hacemos bonito
	    	
	    	echo $(date) "[OK] - Practica empaquetadas -> (gestiona-prac.sh)" Practicas de $asignatura empaquetadas en $rutaAbs >> $INFORMEPATH
	    	echo [OK] se ha empaquetado el directorio $rutaAbs con las prácticas de la asignatura $asignatura 
	    	echo      en el directorio $rutaAbs bajo el nombre $asignatura.tgz
    	fi    	
    else #Si el directorio no erxiste, informa del error y vuelve al menu principal
    	echo "[Error] El directorio especificado no existe"
    	echo $(date) "[ERROR] - Directorio_Origen -> (gestiona-prac.sh)" No es posible empaquetar. El directorio de origen: $rutaAbs no existe >> $INFORMEPATH
    fi
    
    menu
}

menu3(){
    echo -e "\n"
    echo Menú 3 - Obtener nombre y tamaño del fichero
    echo --------------------------------------------
    echo -e "\n"
    read -p "Asignatura sobre la que queremos información: " asignatura
    barraProgreso
    #devuelve true si y solo si la variable i tiene longitud distinta de 0 (es decir, si ha encontrado algo)
    if [[ $(find ~ -regextype posix-egrep -regex "/[A-Za-z0-9/]*$asignatura-[0-9]{6}.tgz") ]] 
    then
    	echo La información obtenida de la asignatura empaquetada $asignatura es la siguiente:
    	#repito la búsqueda por si hay varios .tgz de la misma asignatura (esto no es muy complejidad-friendly pero no sé hacerlo de otra forma)
    	for i in $(find ~ -regextype posix-egrep -regex "/[A-Za-z0-9/]*$asignatura-[0-9]{6}.tgz")
    	do 	
	tamano=$(stat -c%s "$i") #obtengo el tamaño del fichero
	nombre="${i%/}" #separo la ruta por los campos /
	nombre="${nombre##*/}" #me quedo con el campo tras la ultima / para aislar el nombre del fichero
		
	echo -e "\n" El fichero generado es: $nombre y ocupa: $tamano bytes
	echo -e El fichero se encuentra en $i
	echo $(date) "[OK] - Realizo busqueda .tgz -> (gestiona-prac.sh)" El fichero generado es: $i y ocupa: $tamano bytes >> $INFORMEPATH
    	done
    else
    	echo -e "\n"No se han encontrado ficheros .tgz de la asignatura $asignatura
    fi    

    read -p "Pulse cualquier tecla para volver al menú principal"
    menu
    
}

barraProgreso(){
	echo -ne '[########-------------------------------------] (17%)\r'
	sleep 0,5
	echo -ne '[################-----------------------------] (33%)\r'
	sleep 0,5
	echo -ne '[#######################----------------------] (50%)\r'
	sleep 0,5
	echo -ne '[##############################---------------] (67%)\r'
	sleep 0,5
	echo -ne '[######################################-------] (84%)\r'
	sleep 0,5
	echo -ne '[#############################################] (100%)\r'
}
menu    #NO BORRAR ESTO
