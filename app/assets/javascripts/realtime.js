console.log("realtime.js")
Pusher.log = function(message) {
  if (window.console && window.console.log) {
    window.console.log(message);
  } 
};

var pusher = new Pusher('05eacba0b0c5fd1dba48');
var channel = pusher.subscribe('test_channel');
channel.bind('my_event', function(data) {
	console.log(data.message);

    var appElement = document.querySelector('[ng-app=coup]');
	var appScope = angular.element(appElement).scope();
	var controllerScope = appScope.$$childHead;
	var user = JSON.parse(data.message)
	controllerScope.users.push(user)
	console.log(controllerScope.users)
	controllerScope.$apply()


	
});

