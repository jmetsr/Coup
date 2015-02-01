
var pusher = new Pusher('05eacba0b0c5fd1dba48');
var channel = pusher.subscribe('test_channel');
channel.bind('my_event', function(data) {
	var controllerScope = getScope()

	if (data.message[0] == "d") {
		controllerScope.users = controllerScope.users.filter(function(user)
		{
			return user.id != data.message.substring(2, parseInt(data.message.length))
		})
		controllerScope.$apply()
	}
	else if (JSON.parse(data.message).hasOwnProperty("nickname")){
		var user = JSON.parse(data.message)
		controllerScope.users.push(user)
		controllerScope.$apply()
	}	
	else {
		var proposedById = JSON.parse(data.message).proposerId;
		var proposedToIds = JSON.parse(data.message).playerIds;
		var myId = document.getElementById("id").innerHTML;
		var myNickname = controllerScope.findOpponentById(parseInt(myId)).nickname

		var namesList = proposedToIds.map(function(id){
			return controllerScope.findOpponentById(parseInt(id)).nickname
		})
		namesList = namesList.filter(function(nickname){
			return nickname != myNickname
		})
		var names = namesList.join(" and ")

		console.log(names)
		if (myId == proposedById && !contains(namesList,myNickname)){

			var proposingInfo = "<br> you proposed a game to "+names
			document.getElementById("text").innerHTML += proposingInfo
		}

		if (contains(eval(proposedToIds),myId)) {
			var controllerScope = getScope()
			var proposer = controllerScope.findOpponentById(parseInt(proposedById))
			if (namesList.length === 0){
				var proposingInfo = "<br>" + proposer.nickname + " proposed a game to you"
				document.getElementById("text").innerHTML += proposingInfo		
			} else {
				var proposingInfo = "<br>" + proposer.nickname + " proposed a game to you and " + names;
				document.getElementById("text").innerHTML += proposingInfo;
			}
			
		}
				
	}
});

