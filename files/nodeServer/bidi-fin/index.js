var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var port = process.env.PORT || 3000;
var qrcode = require('qrcode-generator');

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

app.get('/login', function(req, res){
  //res.send('Hola mundo!');
 
	var Db = require('mongodb').Db,
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    ReplSetServers = require('mongodb').ReplSetServers,
    ObjectID = require('mongodb').ObjectID,
    Binary = require('mongodb').Binary,
    GridStore = require('mongodb').GridStore,
    Grid = require('mongodb').Grid,
    Code = require('mongodb').Code,
    assert = require('assert');

	var db = new Db('test', new Server('localhost', 27017));
	db.open(function(err, db) {
	  // Fetch a collection to insert document into
	  var collection = db.collection("token");
	  // Insert a single document

	  collection.insert([{hello:'world_safe1'}], {w:1}, function(err, result) {
		assert.equal(null, err);

		// Fetch the document
		/*collection.findOne({hello:'world_safe2'}, function(err, item) {
		  assert.equal(null, err);
		  assert.equal('world_safe2', item.hello);

		  console.log(item);		
	
		  db.close();
		})*/

		collection.find({}).toArray(function(err, item) {
			if (err) throw err;
			console.log(item);		
		    db.close();
		})
	  });
	});
});

app.get('/register', function(req, res){ 
	var name = req.query.name || '';
	var token = '';

	var typeNumber = 4;
	var errorCorrectionLevel = 'L';
	var qr = qrcode(typeNumber, errorCorrectionLevel);

	var crypto = require('crypto');
	// Genero un id raandom
	var idRandom = crypto.randomBytes(20).toString('hex');

	// Vamos a requerir del modulo que provee Node.js 
	// llamado child_process
	var exec = require('child_process').exec, child;
	// Creamos la función y pasamos el string pwd 
	// que será nuestro comando a ejecutar

	const crypto2 = require('crypto2');
	var comand = crypto2.encrypt.rsa(idRandom, ../public_key_gen.pem, (err, encrypted) => {
  		console.log(encrypted);
	});

	/*child = exec(comand,
	// Pasamos los parámetros error, stdout la salida 
	// que mostrara el comando
	  function (error, stdout, stderr) {
		// Imprimimos en pantalla con console.log
		console.log(stdout);
		// controlamos el error
		if (error !== null) {
		  console.log('exec error: ' + error);
		}
	});*/

	qr.addData('Hi!');
	qr.make();
	var imageqr = qr.createImgTag();

	if (name != '')
    token = "Hola " + id;
 
  res.send('<html><body>'
        + '<script type="text/javascript" src="qrcode.js"></script>'
          + '<h1>Saludo</h1>'
        + '<!--div id="placeHolder"></div-->'
        + '<div>' + imageqr + '</div>'
          + '<p>' + token + '</p>'
          + '<form method="get" action="/login">'
          + '<label for="id">¿Cómo te llamas?</label>'
          + '<input type="text" name="id" id="id">'  
          + '<input type="submit" value="Enviar"/>'
          + '</form>'
          + '</body></html>');

});

io.on('connection', function(socket){
  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
  });
});

http.listen(port, function(){
  console.log('listening on *:' + port);
});
