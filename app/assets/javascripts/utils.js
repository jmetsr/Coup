function IsJsonString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}
function contains(a, obj) {
    for (var i = 0; i < a.length; i++) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}

function getScope(){
    var appElement = document.querySelector('[ng-app=coup]');
    var appScope = angular.element(appElement).scope();   
    var controllerScope = appScope.$$childHead;
    return controllerScope
}

function getMyStringId() {
    return document.getElementById("id").innerHTML
}

function getMyId() {
    return parseInt(getMyStringId())
}

function otherPlayers(playerList) {
    return playerList.filter(function(user){
        return (user.id != getMyId()) && (user != getMyStringId())
    })
}

function proposeGame(proposingInfo, controllerScope) {
    document.getElementById("text").innerHTML += proposingInfo; 
    controllerScope.$broadcast('gameProposed');
};







