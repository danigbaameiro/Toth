# Toth - Transport Oriented to Hive

Sistema basado en drones que permita establecer una red de telecomunicaciones en zonas en las que no se disponga de infraestructura, velando por la protección y velocidad de los mensajes

## Getting Started

1. Clone the repository: `git clone https://github.com/Sawyer13/Toth`

### Prerequisites

You need to install node and npm

2. Install [npm and Node.js](https://nodejs.org/en/download/)
```
>> Debian, Ubuntu
$ sudo apt-get install build-essential
$ sudo apt-get install nodejs
$ sudo apt-get install aircrack-ng
```

### Installing

El proceso de instalación se divide en varias fases:

#### 1. Fase 1:
Con esta fase buscamos desplegar todo el equipamiento necesario que tendrán tanto los usuarios de la red de telecomunicaciones como los drones. De tal forma que tras ejecutar el script solo habrá que copiar y pegar en los distintos dispositivos.

<img src="https://ibb.co/mz8yzb">

Ejecutaremos el script config.sh
```
./config.sh
```
Vemos que muestra dos opciones, start o help, ejecutaremos start:
```
./config.sh start
```
Ahora tendremos en nuestra carpeta principal dos nuevas carpetas, user y nodos.

**Lo que hemos hecho es dar a cada nodo todo lo que debería poseer y dar al usuario lo que necesita para la conexión. 
**Se han utilizado las herramientas token_gen.sh para la generación de las claves publicas y privadas


#### 2. Fase 2:
Dentro de la carpeta nodos estan las carpetas que irán a cada nodo. Cogemos una carpeta, cortamos, y pegamos dentro del nodo que deseemos usar.

A continuación, ...

And repeat

```
until finished
```
#### 3. Fase 3:

Trasladaremos al usuario la carpeta user. Esta carpeta le servirá para poder descifrar el id con el que se conectará al dron.


## Probando la aplicación
** Todo lo que se debe desarrollar **

## Built With

* [NodeJS](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [BASH](https://maven.apache.org/) - Dependency Management


## Authors

* **Daniel García Baameiro** - [Sawyer13](https://github.comSawyer13)
* **Miriam Tendero López** - [loo90](https://github.com/loo9o)

## License

This project is licensed under the GNU-GPL License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* LibreLabUCM
* FDIst
* Cybercamp
* Universidad Complutense de Madrid
