#!/bin/bash

install(){ #instalar paquetes necesarios
  git clone https://github.com/oblique/create_ap
  cd create_ap
  make install
  apt-get install hostapd
}

showInterfaces(){ #mostrar interfaces
  iwconfig | grep "802.11" | cut -d " " -f1 > interfaces_toth
  clear
  echo -e "\e[1;33m :::::::::::::::::: INTERFACES WIFI ::::::::::::::::: \e[0m"
  cat interfaces_toth
  echo -e "\e[1;33m :::::::::::::::::::::::::::::::::::::::::::::::::::: \e[0m"
}

findExistingNodes(){ #encontrar nodos existentes
  iwconfig | grep "802.11" | cut -d " " -f1 > exist #interfaces wifi
  clear

  #suponemos que la primera existente permite modo monitor
  interf_out=`sed -n 1p exist`
  airmon-ng start $interf_out > monmode

  #interfaz en modo monitor
  mon_interface=`grep "monitor mode" monmode | cut -d " " -f9 | cut -d "]" -f2 | cut -d ")" -f1`

  #escaneo de redes próximas
  { airodump-ng $mon_interface -w capture --write-interval 10 -o csv 2>> output.txt; } &
  sleep 10

  #matamos el proceso para poder parar el escaneo de airodump-ng
  pkill airodump-ng

  grep nodo capture*.csv | cut -d "," -f 14 > senial
  sed -i 's/ //g' senial
  airmon-ng stop $mon_interface

  nextNode
}
nextNode(){
  #buscamos el último nodo generado
  last_node=`cat senial | sort -n | tail -n1`
  number_last_node=${last_node:4}
  number_next_node=$((number_last_node+1))
  #calculamos el siguiente nodo
  next_node="nodo${number_next_node}"
  echo $next_node > my_node
}
createAP(){ #crear un punto de acceso
  findExistingNodes
  iwconfig | grep "802.11" | cut -d " " -f1 > interfaces_toth
  clear

  interface_in=0
  interface_out=-1

  while [[ $interface_in != $interface_out && $interface_in != x ]]
  do

    echo -e "\e[1;33m :::::::::::::::::: CREAR AP ::::::::::::::::: \e[0m"
    if [[ $interface_in != $interface_out && $interface_in != 0 ]]
    then
      echo -e "\e[0;31m Error, no existe interfaz.\e[0m"
    fi

    echo -e "\e[1;34m Elige una de las siguientes interfaces: \e[0m"
    cat interfaces_toth | grep "wlan"
    echo -e "\e[1;34m Introduce interfaz (Para salir x): \e[0m"
    read interface_in
    interface_out=`cat interfaces_toth | grep -x $interface_in`

    clear
  done
  #cat interfaces_toth | grep "wlan" | sed -n 2p
  if [[ $interface_in == $interface_out ]]
  then
    create_ap -n $interface_in $next_node 1234Cyber
  fi

}

clean(){
  rm *_toth
  rm monmode
  rm *.csv
  rm exist
  rm output.txt
  clear
}

helpMan(){
  echo -e "\e[1;33m :::::::::::::::::::::::: HELP ::::::::::::::::::::::: \e[0m"
  echo "Este script se encarga de crear los puntos de accesos en los nodos,"
  echo "para ellos se usarán los siguientes comandos:"
  echo "a) Instala los paquetes necesarios para la creación de puntos de"
  echo "acceso."
  echo "b) Muestra las interfaces wifi disponibles en ese momento."
  echo "c) Crea un punto de acceso. Comprueba los que hay ya existentes, y"
  echo "crea el nuevo AP con un SSID no existente, con cifrado WPA."
  echo "d) Limpia los archivos generados en pasos anteriores, eliminándolos."
  echo "e) Para salir de la ejecución del script."
  echo "h) Muestra la ayuda"
  echo -e "\e[1;33m ::::::::::::::::::::::::::::::::::::::::::::::::::::: \e[0m"
}

menu(){
  clear
  menu=0
  while [ $menu != "e" ]
  do
    echo -e "\e[1;31m ==================== MENU TOTH ==================== \e[0m"
    echo -e "\e[0;31m a. Instalación de paquetes (Necesaria conexíon internet) \e[0m"
    echo -e "\e[0;31m b. Mostrar interfaces wifi\e[0m"
    echo -e "\e[0;31m c. Crear AP \e[0m"
    echo -e "\e[0;31m d. Limpiar \e[0m"
    echo -e "\e[0;31m e. Salir \e[0m"
    echo -e "\e[0;31m h. Help \e[0m"
    echo -e "\e[1;31m==================================================== \e[0m"
    echo -e "\e[1;34m Elige una de las opciones anteriores: \e[0m"
    read menu_in
    case $menu_in in
      a) install ;;
      b) showInterfaces ;;
      c) createAP ;;
      d) clean ;;
      e) echo "Hasta pronto" ;;
      h) helpMan ;;
      *) echo No has introducido una de las opciones anteriores ;;
    esac

    menu=$menu_in
  done
}

menu
