
var pusher = new Pusher('05eacba0b0c5fd1dba48');
var channel = pusher.subscribe('test_channel');
channel.bind('my_event', function(data) {
	console.log(data.message)
	var controllerScope = getScope()

	if (data.message[0] == "d") {
		controllerScope.users = controllerScope.users.filter(function(user)
		{
			return user.id != data.message.substring(2, parseInt(data.message.length))
		})
		controllerScope.$apply()
	}


	else if (data.message[0] == "a") { //They accepted
		console.log("message of game acceptance received")
		var accepterId = parseInt(data.message.substring(8))
		var acceptence = "<br>" + controllerScope.findOpponentById(accepterId).nickname + " accepts";
		document.getElementById("text").innerHTML += acceptence;
		string = data.message
		if (string.substring(string.indexOf(":")+2)  === "true"){
			console.log("weve all accepted!!!");
			if (accepterId === getMyId()){
				var numberOfPlayers = parseInt(string.substring(string.indexOf("=")+2));
				controllerScope.startGame(numberOfPlayers);
			} else {
				//join the game, problem: how do they know what game to join,
				//solution: suscribe to another channel after proposal,
				//but then we must refactor now
			}

		}
		
	}
	else if (data.message[0] == "r") { //They rejected
		console.log("message of game rejection received")
		var rejecterId = parseInt(data.message.substring(8))
		var rejection = "<br>" + controllerScope.findOpponentById(rejecterId).nickname + " rejects";
		document.getElementById("text").innerHTML += rejection; 
		document.getElementById("gameProposeButton").disabled = false //reinable the button

	
	}
	else if (JSON.parse(data.message).hasOwnProperty("nickname")){
		var user = JSON.parse(data.message)
		controllerScope.users.push(user)
		controllerScope.otherUsers.push(user)
		controllerScope.$apply()
	}
	else {
		var proposedById = JSON.parse(data.message).proposerId;
		var proposedToIds = JSON.parse(data.message).playerIds;
		var myNickname = controllerScope.findOpponentById(getMyId()).nickname
				
		var namesList = otherPlayers(proposedToIds).map(function(id){
		  	return controllerScope.findOpponentById(parseInt(id)).nickname
		})

		var names = namesList.join(" and ")

		if (getMyStringId() == proposedById) {
			var proposingInfo = "<br> you proposed a game to "+names
			proposeGame(proposingInfo, controllerScope);
		}


		if (contains(eval(proposedToIds),getMyStringId())) {
			var controllerScope = getScope()
			var proposer = controllerScope.findOpponentById(parseInt(proposedById))
			if (namesList.length === 0){
				var proposingInfo = "<br>" + proposer.nickname + " proposed a game to you"
				proposeGame(proposingInfo, controllerScope);
			} else {
				var proposingInfo = "<br>" + proposer.nickname + " proposed a game to you and " + names;
				proposeGame(proposingInfo, controllerScope);
			}	
		}		
	}
});

