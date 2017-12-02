#!/bin/bash

#Busca las interfaces wifi disponibles y guarda la primera,
# suponemos que puede ponerse en modo monitor
interfaces(){
  service network-manager restart
  iwconfig | grep "802.11" | cut -d " " -f1 > interfaces_toth
  clear
  interface_out=`sed -n 1p interfaces_toth`
}

#Pone en modo monitor la interfaz y guarda el nuevo nombre de la interfaz en modo monitor
monitorMode(){
  airmon-ng start $interface_out > monmode
  #mon_interface=`grep "monitor mode" monmode | cut -d " " -f7 | cut -d "]" -f2`
  mon_interface=`grep "monitor mode" monmode | cut -d " " -f9 | cut -d "]" -f2 | cut -d ")" -f1`
}

#Escanea las redes wifi disponibles durante 10 segundos y mata el proceso para poder continuar
scan(){
  { airodump-ng $mon_interface -w capture --write-interval 10 -o csv 2>> output.txt; } &
  sleep 10
  pkill airodump-ng
}

#Elige el nodo más cercano, con mejor señal, cuanto más cerca más cercano a 0 el valor
detect(){
  grep nodo capture*.csv | cut -d "," -f 5,14 > senial
  sed -i 's/ //g' senial #quitar espacios en blanco
  while IFS= read -r line; #busca el nodo con mejor señal
  do
    best=$line;
  done < <(cut -d "," -f 1 senial | sort -n | head -n1);

  best_node=`grep $best senial | cut -d "," -f 2` #nodo con mejor señal
}

#Realiza la conexión wifi con el nodo
connect(){
  nmcli device wifi connect $best_node password Password_Wifi_Here
}

#Borrado de archivos
clean(){
  rm *.csv
  rm monmode
  rm interfaces_toth
  rm senial
  airmon-ng stop $mon_interface
}

interfaces
monitorMode
scan
detect
connect
clean
