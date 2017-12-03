#!/bin/bash

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'

function start {
	# Crea la carpeta nodos y la carpeta user
	if [ -d nodos/ ] || [ -d user/ ];
		then
			echo "Borre las carpetas nodos/ y user/"
		else
			echo "Creando carpetas"
			mkdir nodos
			mkdir user
	fi

	# Pregunta cuantos nodos desea crear

	echo "Cuantos nodos se van a crear? "
	read RESPUESTA

	# Crea respecto a ese número claves privadas y públicas
	## Todo fichero público se guardará en una carpeta que se llame tmp
	## La clave privada irá a cada dron

	cd files


	# Cada usuario debe tener:
	## CLave privada con la que descifrará la contra del nodo
	if [ -d keyFolder ];
		then
			echo "Ya tiene las claves creadas, borre para unas nuevas y vuelva a ejecutar"
	else
		./token_gen.sh key
	fi

		cp keyFolder/public_key.pem ../user/public_key_gen.pem

	# Dentro de la carpeta creará cada nodo

	cd ../nodos

	# Cada nodo debe contener:
	## Fichero createap.sh
	## Clave publica que se enviará al usuario
	## Carpeta con todas las claves publicas de todos los nodos
	## Clave privada que es solo suya

	mkdir /tmp/keyFolder

	for ((i=1;i<=$RESPUESTA;i+=1)); do
		if [ -d nodo$i ];
		then
			echo "El nodo "nodo$i" ya esta creado. Borre para actualizar"
		else
			mkdir nodo$i
		fi

		cp ../files/create_ap.sh nodo$i/
		mkdir nodo$i/nodeServer
		cp -r ../files/nodeServer/* nodo$i/nodeServer
		cp ../files/conexion.sh nodo$i/
		cp ../files/keyFolder/public_key.pem nodo$i/public_key_gen.pem
		cp ../files/./token_gen.sh nodo$i/
		cd nodo$i	
		./token_gen.sh key
		rm token_gen.sh
		cd ..
		cp nodo$i/keyFolder/public_key.pem '/tmp/keyFolder/nodo'$i'_public_key.pem'
	done

	for ((i=1;i<=$RESPUESTA;i+=1)); do
		mkdir nodo$i/allPubKey
	 	cp /tmp/keyFolder/* nodo$i/allPubKey
	done


	rm -r ../files/keyFolder
	rm -r /tmp/keyFolder
}

function help {
echo -e "$GREEN config realiza toda la configuración creando dos carpetas, user y dron. 

     - La carpeta user será para otorgarsela al usuario previamente conocido, de tal forma que pueda realizar una autenticación con el dron.
	 - La carpeta nodos contendrá cada carpeta que irá dentro del dron. Luego más adelante se trasladará cada una de las carpetas creadas a un dron. Y una vez en el propio dron se ejecutaran las herramientas que se precisen para establecer el nodo."
}

case "$1" in
	start)
		start
	;;
	help)
		help
	;;
*)

echo -e "$BLUE

████████╗ ██████╗ ████████╗██╗  ██╗
╚══██╔══╝██╔═══██╗╚══██╔══╝██║  ██║
   ██║   ██║   ██║   ██║   ███████║
   ██║   ██║   ██║   ██║   ██╔══██║
   ██║   ╚██████╔╝   ██║   ██║  ██║
   ╚═╝    ╚═════╝    ╚═╝   ╚═╝  ╚═╝

     
Transport Oriented to Hive (v 0.0)
	Developed by Daniel \"Sawyer\" Garcia <dagaba13@gmail.com>
				 Miriam \"Loo9o\" Tendero <miriamte@ucm.es>
$RED┌──[$GREEN$USER$YELLOW@$BLUE`hostname`$RED]─[$GREEN$PWD$RED]
$RED└──╼ \$$GREEN"" token_gen $RED{$GREEN""start$RED|$GREEN""help""$RED}

$RED start$BLUE -$GREEN Create a token for nodes
$RED help$BLUE -$GREEN Do you need a hand? ;)

$RESETCOLOR" >&2

exit 1
;;
esac

echo -e $RESETCOLOR

exit 0


