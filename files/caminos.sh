#!/bin/bash

# json_origen
# json_origen json_destino
# salida a json_destino
# Si se envía un json es que en el nodo destino no existe ese camino y se incrementa en 1
# Si se envían 2 json es que existen en ambos nodos y se compara cual es el menor + 1 y se guarda


#necesario instalar jq
# '{"dest":"nodo1","cost":3, "next":"nodo3"}'
# '{"dest":"nodo1","cost":1, "next":"nodo2"}'

# next el que envía la tabla
# dest el cliente

suma2(){
  cost_calculado=$(($cost1 + 1))
  if [[ $cost_calculado -eq $cost2 ]]; then
    echo "entra1"
    devolverNada
  elif [[ $cost_calculado -gt $cost2 ]]; then
    devolverNada
  elif [[ $cost_calculado -lt $cost2 ]]; then
    cost3=$cost_calculado
    devolver
  else
    echo "error"
  fi
}

suma(){
  cost3=$(($cost1 + 1))
  devolver
}

devolver(){
  echo {"dest":"${dest1}","cost":${cost3}, "next":"${next}"}
}

devolverNada(){
  echo "null"
}

case $1 in
  help)
  echo "Script que sirve para sumar el coste de la tabla de ruta de ese nodo"
  echo "Introduce:"
  echo "ssid_origen json_origen"
  echo "o"
  echo "ssid_origen json_origen json_destino"
  echo "Ejemplo: "
  echo "./caminos.sh nodo2 '{"dest":"nodo1","cost":3, "next":"nodo3"}' '{"dest":"nodo1","cost": 1, "next":"nodo2"}"
  echo "./caminos.sh nodo2 '{"dest":"nodo1","cost":1, "next":"nodo3"}'"
    ;;
    *)


    if [ ! -f "my_node" ]; then
      echo "archivo my node no existe. Ejecutar create_ap"
      exit
    fi

    next=`grep nodo my_node`

    dest1=`jq -M -r '.dest' <<< $1`
    cost1=`jq -M -r '.cost' <<< $1`
    next1=`jq -M -r '.next' <<< $1`

    if [[ -n "$2" ]]; then
      dest2=`jq -M -r '.dest' <<< $2`
      cost2=`jq -M -r '.cost' <<< $2`
      next2=`jq -M -r '.next' <<< $2`
      if [[ $dest1 -eq $dest2 ]]; then
        suma2
      else
        echo "error tiene que ser el destino igual"
      fi
    elif [[ -z $2 ]]; then
      suma
    fi

    ;;
esac
