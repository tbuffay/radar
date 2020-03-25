var debug = false;

var progressInterval;
var progressIntervalTimeout = 2000;

function progressUpdate() {
    // Handle the various browsers... Pre-IE7 doesn't support XMLHttpRequest.
    if (window.XMLHttpRequest && !(window.ActiveXObject)) {
        try {
            req = new XMLHttpRequest();
        } catch (e) {
            req = false;
        }
        // IE/Windows ActiveX
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

    // If request isn't possible, just return right away.
    if (!req)
        return;

    req.open("GET", "/cgi/progress.json", false);
    req.send(null);
    if (req.status == 200) {
        var progress = eval("(" + req.responseText + ")");
        if (debug) {
            document.getElementById('debug_panel').innerHTML += "speed = "
                + progress.speed + " " + progress.percent + "%" + '<br />';
        }
        bar = document.getElementById('progressbar');
        w = (progress.percent / 100) * 180;
        bar.style.width = w + 'px';
        document.getElementById('tp').innerHTML = progress.percent + "%";
        if (progress.state == 'done') {
            w = 190;
            bar.style.width = w + 'px';
            window.clearInterval(progressInterval);
            window.clearTimeout(progressInterval);
            return;
        } else if (progress.state == 'failed') {
            alert("Operation Failed!");
            window.clearInterval(progressInterval);
            window.clearTimeout(progressInterval);
        }
    } else {
        // Something didn't work....at least set an alert with useful information!
        alert("Error " + request.status + ":  " + request.statusText);
    }
}

function startProgress() {
    // Code needs to go here to generate the progress bar.
    progressInterval = window.setInterval(function () { progressUpdate(); }, progressIntervalTimeout);
};


