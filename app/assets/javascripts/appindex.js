var app = angular.module("coup", ['ngRoute', 'templates']);

app.controller('MainController', function($scope, $http) {
	$scope.users = ['fvsrtb'];
	$scope.getUsers = function() {
		$http.get("/users").success(function(data){
			$scope.users = data
		}) 
	}
	$scope.getUsers()

	$scope.proposeGame = function () {
		var potentialOpponents = []
		var opponents = document.getElementById("otherPlayers").children;
		for (var i=0; i < opponents.length; i++){
			for (var j=0; j < opponents[i].children.length; j++){
				var player =  opponents[i].children[j].children.player
				var id = player.id
				if (document.getElementById(id).checked){
					potentialOpponents.push(id)				
				}
			}
		}
		
		potentialOpponents = JSON.stringify(potentialOpponents)
		
		var myId = document.getElementById("id").innerHTML;
		

		data = JSON.stringify({"proposerId": myId, "playerIds": potentialOpponents})
		$http.post('/games/propose', data).
 		success(function() { console.log("success") }).
 		error(function() { console.log("error") });
	}

});

app.config(function($routeProvider) {
	$routeProvider
	.when("/", { templateUrl: "new.html" })
	.when("/users", { templateUrl: "index.html" })
});

app.filter('oneForth', function() {
	return function(input,partNumber) {
		var size = Math.ceil(input.length/4)
		var leftOvers = input.length - size
		var nextSize = Math.ceil(leftOvers/3)
		var secondLeftOvers = input.length - (size + nextSize)
		var thirdSize = Math.ceil(secondLeftOvers/2)
		if (partNumber === 1) {
			return input.slice(0,size)
		}
		if (partNumber === 2) {	
			return input.slice(size,size+nextSize)
		}
		if (partNumber === 3) {
			return input.slice(size+nextSize,size+nextSize+thirdSize)
		}
		if (partNumber === 4) {
			return input.slice(size+nextSize+thirdSize,input.length)
		}
	}
})



