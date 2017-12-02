#!/bin/bash

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'

function nodo {
	echo "Funcion nodo"
	# Change this word
	
	DATE=$(date +'%s')
	
	echo "Comprobando si existen las claves publica y privada..."
	
	
	## Comprueba, sino ejecuta otra cosa	
	
	
	# Sacamos las direcciones MAC
	MACNAME=$(/sbin/ifconfig |grep ether |awk '{ print $2 ";" }' |tr -d '\n')

	DIFERENCIA="nodo_"$MACNAME	

	FRASE=$(echo -e '"{"username":'`hostname`',"timestamp":'$DATE', "node":'$DIFERENCIA'}"')

	echo $FRASE

	cd keyFolder
	#ENCRYPT=$(echo $FRASE | openssl aes-256-cbc -a -salt -k $CONTRASENA)
	ENCRYPT=$(echo $FRASE | openssl rsautl -encrypt -pubin -inkey public_key.pem -out >(base64))
	

	# DECRYPT=$(echo $ENCRYPT | openssl aes-256-cbc -a -d -salt -k $CONTRASENA)
	DECRYPT=$(openssl rsautl -decrypt -inkey private_key.pem -in <(echo "$ENCRYPT" | base64 -d))
	
	cd ..

	echo -e "Encriptado: $ENCRYPT"
	echo -e "Desencriptado: $DECRYPT"
}

function dron {
	echo "Funcion dron"
	# Change this word

	

}

function key {
	echo -e "Procediendo a generar las claves...

For Asymmetric encryption you must first generate your private key and extract the public key."

	mkdir keyFolder
	cd keyFolder

	echo -e "Generando la privada clave..."
	PRIVATE=$(openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048)
	
	echo -e "Generando la clave pública..."
	PUBLIC=$(openssl rsa -pubout -in private_key.pem -out public_key.pem)

	cd ..

	echo "Claves creadas! :)"
}

case "$1" in
	nodo)
		nodo
	;;
	dron)
		dron
	;;
	key)
		key
	;;
*)

echo -e "
Cybercamp Token Generator (v 0.0)
	Developed by Daniel \"Sawyer\" Garcia <dagaba13@gmail.com>

$RED┌──[$GREEN$USER$YELLOW@$BLUE`hostname`$RED]─[$GREEN$PWD$RED]
$RED└──╼ \$$GREEN"" token_gen $RED{$GREEN""nodo$RED|$GREEN""dron""}

$RED nodo$BLUE -$GREEN Create a token for nodes
$RED dron$BLUE -$GREEN Create a token for users 
$RED key $BLUE -$GREEN Create private and public key
$RED help$BLUE -$GREEN Do you need a hand? ;)
$RESETCOLOR
" >&2


exit 1
;;
esac

echo -e $RESETCOLOR

exit 0
