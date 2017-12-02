var socket = io.connect('http://localhost:1234',{ 'forceNew': true });

socket.on('messages', function(data){
	console.log(data);
	render(data);
});


function render (data) {
	//La funcion map itera sobre ese array como un for
	var html = data.map(function(elem, index){
		return(`<div>
                        <strong>${elem.author}</stron>:
                        <en>${elem.text}</en>
                    </div>`);
	}).join(" ");

	document.getElementById('messages').innerHTML = html;
}

function addMessage(e) {
	var payload = {
		author: document.getElementById("username").value,
		text: document.getElementById("text").value
	}
	
	//console.log(payload);

	socket.emit('new-message', payload);

	return false;
}
