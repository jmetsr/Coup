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
function playersNotInAGame(playerList) {
    return playerList.filter(function(user){
        return (user.game_id == null)
    })
}

function proposeGame(proposingInfo, controllerScope) {
    document.getElementById("text").innerHTML += proposingInfo; 
    controllerScope.$broadcast('gameProposed');
};

function DisableButton(b){
    var ids = ['inc', 'frg', 'tax', 'stl', 'coup', 'asn', 'challenge', 'rsvtheft', 'blocka', 'blockc', 'exch', 'letem'];
    if (b != null && b.form != null){
        b.disabled = true;
        b.value = 'Submitting';
        b.form.submit();
    }
    for (id in ids){
        if (document.getElementById(ids[id]) != b && document.getElementById(ids[id]) != null){
            document.getElementById(ids[id]).disabled=true;
            console.log(ids[id])
        }
    }
}

if (typeof String.prototype.startsWith != 'function') {
  // see below for better implementation!
  String.prototype.startsWith = function (str){
    return this.indexOf(str) === 0;
  };
}


