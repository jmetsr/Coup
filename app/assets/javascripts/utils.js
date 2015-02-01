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
