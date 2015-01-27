function IsJsonString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}
function contains(a, obj) {
	console.log("execute me")
    for (var i = 0; i < a.length; i++) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}


var pusher = new Pusher('05eacba0b0c5fd1dba48');
var channel = pusher.subscribe('test_channel');
channel.bind('my_event', function(data) {

	console.log(data.message)

	var appElement = document.querySelector('[ng-app=coup]');
	var appScope = angular.element(appElement).scope();
	var controllerScope = appScope.$$childHead;

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
		console.log("user created")

	}	
	else {
		
		var proposedById = JSON.parse(data.message).proposerId
		var myId = document.getElementById("id").innerHTML
		if (myId == proposedById){
			alert("you proposed a game")
		}
		
		var proposedToIds = JSON.parse(data.message).playerIds ;
		console.log(eval(proposedToIds)[0])
		
		
		if (contains(eval(proposedToIds),myId)) {
			alert("someone proposed a game to you")
		}
		
		
	}
	
	
	
});

