var app = angular.module("coup", ['ngRoute', 'templates']);

app.controller('MainController', function($scope, $http) {
	$scope.users = ['fvsrtb'];
	$scope.getUsers = function() {
		$http.get("/users").success(function(data){
			$scope.users = data
		}) 
	}
	$scope.getUsers()

});

app.config(function($routeProvider) {
	$routeProvider
	.when("/", { templateUrl: "new.html" })
	.when("/users", { templateUrl: "index.html", resolve: console.log("dcw") })
});

app.filter('oneForth', function() {
	return function(input,partNumber) {
		var size = Math.floor(input.length/4)
		if (partNumber === 1) {
			return input.slice(0,size)
		}
		if (partNumber === 2) {
			return input.slice(size+1,size*2)
		}
		if (partNumber === 3) {
			return input.slice(size*2+1,size*3)
		}
		if (partNumber === 4) {
			return input.slice(size*3+1,input.length)
		}
	}
})



