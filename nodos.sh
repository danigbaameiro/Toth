#!/bin/bash

install(){
  git clone https://github.com/oblique/create_ap
  cd create_ap
  make install
  apt-get install hostapd
}

showInterfaces(){
  iwconfig | grep "802.11" | cut -d " " -f1 > interfaces_toth
  clear
  echo -e "\e[1;33m :::::::::::::::::: INTERFACES WIFI ::::::::::::::::: \e[0m"
  cat interfaces_toth
  echo -e "\e[1;33m :::::::::::::::::::::::::::::::::::::::::::::::::::: \e[0m"
}

createAP(){
  iwconfig | grep "802.11" | cut -d " " -f1 > interfaces_toth
  clear

  interface_in=0
  interface_out=-1

  while [[ $interface_in != $interface_out && $interface_in != x ]]
  do

    echo $interface_in
    echo $interface_out
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
    create_ap -n $interface_in nodo1 Password_Wifi_Here
  fi

}

clean(){
  rm *_toth
  clear
}

menu(){
  clear
  menu=0
  while [ $menu != "i" ]
  do
    echo -e "\e[1;31m ==================== MENU TOTH ==================== \e[0m"
    echo -e "\e[0;31m a. Instalación de paquetes (Necesaria conexíon internet) \e[0m"
    echo -e "\e[0;31m b. Mostrar interfaces wifi\e[0m"
    echo -e "\e[0;31m c. Crear AP \e[0m"
    echo -e "\e[0;31m d. Conectarse a AP \e[0m"
    echo -e "\e[0;31m e. \e[0m"
    echo -e "\e[0;31m f. \e[0m"
    echo -e "\e[0;31m g. \e[0m"
    echo -e "\e[0;31m h. Limpiar \e[0m"
    echo -e "\e[0;31m i. Salir \e[0m"
    echo -e "\e[1;31m==================================================== \e[0m"
    echo -e "\e[1;34m Elige una de las opciones anteriores: \e[0m"
    read menu_in
    case $menu_in in
      a) install ;;
      b) showInterfaces ;;
      c) createAP ;;
      d) showInterfaces ;;
      e) showInterfaces ;;
      f) showInterfaces ;;
      g) showInterfaces ;;
      h) clean ;;
      i) echo "Hasta pronto" ;;
      *) echo No has introducido una de las opciones anteriores ;;
    esac

    menu=$menu_in
  done
}

menu
