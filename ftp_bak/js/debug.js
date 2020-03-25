var debugUpdateTimer;
var debugUpdateTimeout = 500;

function updateFixed(id, val, digits) {
    document.getElementById(id).innerHTML = val.toFixed(digits);
}

function debugUpdate() {
    var req;
    if (window.XMLHttpRequest && !(window.ActiveXObject)) {
        try {
            req = new XMLHttpRequest();
        } catch (e) {
            req = false;
        }
    } else if (window.ActiveXObject) {
        try {
            req = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
                req = false;
            }
        }
    }

    if (!req)
        return;

    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {
            var debug = eval("(" + req.responseText + ")");
			
            updateFixed("speed_fbk", debug.speed_fbk, 0);
            updateFixed("angle_fbk", debug.angle_fbk/100.00, 2);
            updateFixed("motor_v", debug.motor_v/1000.000, 3);
            updateFixed("motor_i", debug.motor_i, 0);
            document.getElementById("rotat_direct").innerHTML = debug.rotat_direct;
			document.getElementById("param_fix").innerHTML = debug.param_fix;

            if (debugUpdateTimeout > 0) {
                debugUpdateTimer = setTimeout(debugUpdate, debugUpdateTimeout);
            }
        }
    }

    req.open("GET", "/cgi/debug.json", true);
    req.send();
}

function enableDebugUpdate() {
    debugUpdateTimeout = 500;
    debugUpdate();
}

function disableDebugUpdate() {
    debugUpdateTimeout = 0;
    clearTimeout(debugUpdateTimer);
}

