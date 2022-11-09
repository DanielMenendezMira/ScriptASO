
menu(){
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
    read -p "Opción(hh): " option
    
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
    echo -e "\n"
    echo Menú 1 - Programar recogida de prácticas
    echo -e "\n"
    read -p "Asigantura cuyas prácticas desea recoger: " asignatura
    read -p "Ruta con las cuentas de los alumnos: " rutaO
    read -p  "Ruta para almacenar prácticas: " rutaD
    echo -e "\n" 
    echo Se va a programar la recogida de las prácticas de $asignatura para \n
    echo mañana a las 8:00. Origen: $rutaO   Destino: $rutaD
    echo -e "\n"
    read -p "¿Está de acuerdo? (s/n) " resp
    menu
}
menu2(){
    echo -e "\n"
    echo Menú 2 - Empaquetar prácticas de la asignatura
    echo -e "\n"
    read -p "Asigantura cuyas prácticas desea empaquetar: " asignatura
    read -p "Ruta absoluta del directorio de prácticas: " rutaAbs
    echo -e "\n" 
    #Si hay algún problema (por ejemplo, el directorio a salvar no existe), 
    #la herramienta presenta un mensaje de error en pantalla y en el fichero de incidencias, y vuelve al menú principal.
    echo Se van a empaquetar las prácticas de la asignatura $asignatura \n
    echo presentes en el directorio $rutaAbs
    echo -e "\n"
    read -p "¿Está de acuerdo? (s/n) " resp
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
