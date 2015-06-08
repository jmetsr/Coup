window["channel: " + game.id ] = pusher.subscribe("game_channel_number_" + game.id );
window["channel: " + game.id ].bind('game_data_for_' +  game.id , function(data) {
	if (data.message[0] == "t"){    //a turn ended
		location.reload();
	}
	if (data.message[0] == "c"){    //cards finished dealing
		location.reload();	
	}
	if (data.message[0] == "y"){    //you win
		window.location = '/static_pages/you_win'
	}
	if (data.message[0] === "T"){
		document.getElementById("chat").innerHTML +=  data.message.substring(3) + "<br>"
		console.log(data.message + "")
	}
	if (((JSON.parse(data.message)).action === "coup") && ((JSON.parse(data.message)).opponent == current_user.nickname)){
		 document.getElementById('reactToCoup').className = ""
	}
	if (((JSON.parse(data.message)).action === "assassin") && ((JSON.parse(data.message)).opponent == current_user.nickname)){
		 document.getElementById('reactToAssassin').className = ""
		 document.getElementById('claimContessa').className = ""
	}
	if (((JSON.parse(data.message)).action === "theft") && ((JSON.parse(data.message)).opponent == current_user.nickname)){
		document.getElementById('reactToTheft').className = ""
	}
	if (((JSON.parse(data.message)).action === "foreign aid") && ((JSON.parse(data.message)).opponent != current_user.nickname)){
		 document.getElementById('reactToForeignAid').className = ""
	}
	if (((JSON.parse(data.message)).result === "fail") && ((JSON.parse(data.message)).player === current_user.nickname)){
		document.getElementById('reactToFailedChallenge').className = "";
		document.getElementById('reactToTax').className = "hidden";
		document.getElementById('reactToTheft').className = "hidden";
		document.getElementById('reactToExchange').className = "hidden";
		document.getElementById('reactToBlockTheftCaptin').className = "hidden";
		document.getElementById('reactToBlockTheftAmbassador').className = "hidden";
		document.getElementById('reactToBlockContessa').className = "hidden";
		document.getElementById('reactToForeignAid').className = "hidden";
	}
	if (((JSON.parse(data.message)).result === "succeede") && ((JSON.parse(data.message)).player === current_user.nickname )){
		document.getElementById('reactToSuccessfulChallenge').className = "";
	}
	if (((JSON.parse(data.message)).action === "tax") && ((JSON.parse(data.message)).opponent != current_user.nickname)){
		 document.getElementById('reactToTax').className = ""
	}
	if ((JSON.parse(data.message)).action === "block"){
		var infoString = (JSON.parse(data.message)).opponent + " blocks with " + (JSON.parse(data.message)).card
		document.getElementById('displayBlockInfo').innerHTML = infoString

	}
	if (((JSON.parse(data.message)).action === "block") && ((JSON.parse(data.message)).opponent != current_user.nickname) &&  (JSON.parse(data.message)).card == 'Contessa'){
		 document.getElementById('reactToBlockContessa').className = ""
	}
	if (((JSON.parse(data.message)).action === "block") && ((JSON.parse(data.message)).opponent != current_user.nickname) &&  (JSON.parse(data.message)).card == 'Duke'){
		 document.getElementById('reactToBlockForeignAid').className = ""
	}
	if (((JSON.parse(data.message)).action === "block") && ((JSON.parse(data.message)).opponent != current_user.nickname) &&  (JSON.parse(data.message)).card == 'Captin'){
		 document.getElementById('reactToBlockTheftCaptin').className = ""
	}
	if (((JSON.parse(data.message)).action === "block") && ((JSON.parse(data.message)).opponent != current_user.nickname) &&  (JSON.parse(data.message)).card == 'Ambassador'){
		 document.getElementById('reactToBlockTheftAmbassador').className = ""
	}
	if (((JSON.parse(data.message)).action === "exchange") && ((JSON.parse(data.message)).opponent != current_user.nickname)){
		 document.getElementById('reactToExchange').className = ""
	}


})
Pusher.log = function(msg){
	console.log(msg)
}