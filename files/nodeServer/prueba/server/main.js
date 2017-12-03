var express = require('express');
var app = express();
var server = require('http').Server(app);
var io = require('socket.io')(server);

app.use(express.static('public'));

app.get('/', function(req, res){
	res.status(200).send("Hola Mundo!");
});

app.get('/login', function(req, res){
	//socket.emit('new-message', payload);
 	sendMesage(this);
});

//Funcion de callback
server.listen(1234, function() {
	console.log('Servidor corriendo en http://localhost:1234');
});


var messages = [{
        text: "Hola soy un mensaje"
},{
		text: "hackeado!"
}];

io.on('connection', function(socket) {
	console.log('Un cliente se ha conectado');
	socket.emit('messages', messages);
	socket.on('new-message', function(data){
		//Lo suyo sería ahora meterlo en una base de datos
		messages.push(data);
		//
		// Guardo en un archivo
		//
		//
		console.log(data);

		//Se avisa al resto de clientes.
		io.sockets.emit('messages', messages);
	});
});
