app = angular.module("coup", ['ngRoute', 'templates']);
app.factory('serverInteraction', function($http){
	return {
		makeRequestToGetUserData: function() {
			return $http.get("/users");
		},
		makeGameProposalRequest: function(data) {
			return $http.post('/games/propose', data);
		},
		accept: function() {
			return $http.get('/games/accept')
		},
		reject: function() {
			return $http.get('games/reject')
		}
	}

})