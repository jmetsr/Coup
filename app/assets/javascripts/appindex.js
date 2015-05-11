app.controller('MainController', function($scope, serverInteraction) {
	$scope.users = ['fvsrtb'];
	$scope.otherUsers = [];
	

	$scope.getUsers = function() {
		serverInteraction.makeRequestToGetUserData().success(function(data){
			$scope.users = data
			$scope.otherUsers = otherPlayers(data)
		}) 
	}
	$scope.getUsers();


	$scope.proposeGame = function () {
		var potentialOpponents = [];
		for (var i=0; i < $scope.otherUsers.length; i++){
			var id = String($scope.otherUsers[i].id)
			
			if (document.getElementById(id).checked){
				potentialOpponents.push(id)	
			}
		}
		var myId = getMyStringId();
		data = JSON.stringify({"proposerId": myId, "playerIds": potentialOpponents})

 		serverInteraction.makeGameProposalRequest(data).
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
	$scope.acceptGame = function() {
		serverInteraction.accept().
			success(function(){ console.log("success") }).
			error(function(){ console.log("error")});
	}
	$scope.rejectGame = function() {
		serverInteraction.reject().
			success(function(){ console.log("success") }).
			error(function(){ console.log("error")});
	}
	$scope.startGame = function(data) {
		serverInteraction.play(data).
			success(function(result){ 
				$scope.game = result.id
			}).
			error(function(){ console.log("error")});
	}
	$scope.join = function(data,id) {
		serverInteraction.join(data,id).
			success(function(result){
				console.log("success");
				$scope.game = result.game_id
				$scope.apply
				for (i=0; i<50000000; i++){}
				window.location = "/games/" + $scope.game
				$scope.apply
			}).
			error(function(){  //if its an error, wait a bit and try again
				for (i=0; i<1000000; i++){}
				$scope.join(data,id)
			//recursivly call the function
			});
	}
	$scope.proposer = [];
	$scope.accepter = "dscs";
	


});

app.config(function($routeProvider) {
	$routeProvider
	.when("/", { templateUrl: "new.html" })
	.when("/users", { templateUrl: "index.html" })
	.when("/play", {templateUrl: "play.html"})
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
logout = setTimeout(function(){
	alert("You have been logged out due to inactivity, please go back to http://localhost:3000/#/ and log in again")
},delay); 

app.directive('respondToGame', function() {
	return {
		restrict: 'E',
		templateUrl:  'acceptproposal.html',

		link: function(scope, element, attributes){
			scope.$on("gameProposed", function(){
				element.removeClass("hidden")
				document.getElementById("gameProposeButton").setAttribute("disabled", "true")
			})
		}
	}
});

