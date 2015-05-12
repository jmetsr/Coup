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

function DisableButton(b){
    var ids = ['inc', 'frg', 'tax', 'stl', 'coup', 'asn'];
    b.disabled = true;
    b.value = 'Submitting';
    b.form.submit();
    for (id in ids){
        if (document.getElementById(ids[id]) != b){
            document.getElementById(ids[id]).disabled=true;
        }
    }
}





