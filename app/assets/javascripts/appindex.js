var app = angular.module("coup", ['ngRoute', 'templates']);

app.controller('MainController', function($scope, $http) {
	$scope.users = ['fvsrtb'];
	$scope.otherUsers = [];
	$scope.getUsers = function() {
		$http.get("/users").success(function(data){
			$scope.users = data
		}) 
	}

	$scope.getUsers();


	$scope.proposeGame = function () {
		var potentialOpponents = [];
		for (var i=0; i < $scope.users.length; i++){
			var id = String($scope.users[i].id)
			
			if (document.getElementById(id).checked){
				potentialOpponents.push(id)	
			}
		}
	
		var myId = document.getElementById("id").innerHTML;
		data = JSON.stringify({"proposerId": myId, "playerIds": potentialOpponents})
		$http.post('/games/propose', data).
 		success(function() { console.log("success") }).
 		error(function() { console.log("error") });
	}
	$scope.findOpponentById = function(id) {
		for (var i=0; i < $scope.users.length; i++) {
			if ($scope.users[i].id === id) {
				return $scope.users[i]
			}
		}
		return "not found"
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

var delay = 900000;
setTimeout(function(){
	alert("You have been logged out due to inactivity, please go back to http://localhost:3000/#/ and log in again")
},delay); 


