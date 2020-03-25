function clientSideInclude(id, url) {
    var req = false;
    // For Safari, Firefox, and other non-MS browsers
    if (window.XMLHttpRequest) {
        try {
            req = new XMLHttpRequest();
        } catch (e) {
            req = false;
        }
    } else if (window.ActiveXObject) {
        // For Internet Explorer on Windows
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
    var element = document.getElementById(id);
    if (!element) {
        alert("Bad id " + id + "passed to clientSideInclude."
            + "You need a div or span element "
            + "with this id in your page.");
        return;
    }
    if (req) {
        // Synchronous request, wait till we have it all
        req.open('GET', url, false);
        req.send(null);
        element.innerHTML = req.responseText;
    } else {
        element.innerHTML = "Sorry, your browser does not support "
            + "XMLHTTPRequest objects. This page requires "
            + "Internet Explorer 5 or better for Windows, "
            + "or Firefox for any system, or Safari. Other "
            + "compatible browsers may also exist.";
    }
}

function reloadCurrent() {
    window.location.reload();
}

function reloadIndex() {
    window.location = "/index.html";
}

function versionToString(version) {
    return "" + ((version >> 24) & 255) + "." +
        ((version >> 16) & 255) + "." +
        ((version >> 8) & 255) + "." +
        ((version) & 255);
}

function fpgaStateToString(state, factoryImage) {
    var str;

    if (state.factorymode) {
        str = "Failsafe<br/>Trigger:" +
            (state.powerup ? "powerup" : "") +
            (state.runconfig ? "runconfig" : "") +
            (state.wdtimer ? "wdtimer" : "") +
            (state.nstatus ? "nstatus" : "") +
            (state.crcerror ? "crcerror" : "") +
            (state.nconfig ? "nconfig" : "");
    } else if (state.appmode) {
        str = ((factoryImage == state.appaddr) ? "Factory" : "Application") +
            "<br/>Watchdog:" + (state.wden ? "Enabled" : "Disabled");
    }
    else {
        str = "Unknown";
    }

    return str;
}

function fpgaidToVersionString(fpgaid) {
    return versionToString(fpgaid.version);
}

function appidToVersionString(appid) {
    return versionToString(appid.version);
}

function sysidToString(sysid) {
    var str;

    switch (sysid.id) {
        case 0x48444C00: str = "boot(00)"; break;
        case 0x48444C01: str = "min(01)"; break;
        case 0x48444C02: str = "multiproc(02)"; break;
        case 0x48444C03: str = "hdlbot(03)"; break;
        case 0x44484C10: str = "hdltop(10)"; break;
        default: str = "" + sysid.id;
    }

    return str;
}

function imageToVersionString(image) {
    return versionToString(image.version);
}

function sysidFromImage(image) {
    return { 'id': image.res1, 'timestamp': image.res2 };
}

function infoUpdate() {
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
            var info = eval("(" + req.responseText + ")");

            document.getElementById("bot_fpga_mode").innerHTML = fpgaStateToString(info.state.bot, 0x00020000);
            document.getElementById("bot_fpga_type").innerHTML = "" + info.fpgaid.bot.id;
            document.getElementById("bot_fpga_version").innerHTML = fpgaidToVersionString(info.fpgaid.bot);
            document.getElementById("bot_fpga_sysid").innerHTML = sysidToString(info.sysid.bot);
            document.getElementById("bot_fpga_appid").innerHTML = appidToVersionString(info.appid.bot);

            document.getElementById("top_fpga_mode").innerHTML = fpgaStateToString(info.state.top, 0x00000000);
            document.getElementById("top_fpga_type").innerHTML = "" + info.fpgaid.top.id;
            document.getElementById("top_fpga_version").innerHTML = fpgaidToVersionString(info.fpgaid.top);
            document.getElementById("top_fpga_sysid").innerHTML = sysidToString(info.sysid.top);
            document.getElementById("top_fpga_appid").innerHTML = appidToVersionString(info.appid.top);

            document.getElementById("failsafe_image_version").innerHTML = imageToVersionString(info.image.failsafe);
            document.getElementById("failsafe_image_sysid").innerHTML = sysidToString(sysidFromImage(info.image.failsafe));

            document.getElementById("application_image_version").innerHTML = imageToVersionString(info.image.application);
            document.getElementById("application_image_sysid").innerHTML = sysidToString(sysidFromImage(info.image.application));
        }
    }

    req.open("GET", "/cgi/info.json", true);
    req.send();
}

function infoAreaUpdate() {
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
            var info = eval("(" + req.responseText + ")");

            document.getElementById('model').innerHTML = info.model;
            document.getElementById('serial').innerHTML = info.serial;
            document.getElementById('mac_addr').innerHTML = info.mac_addr;
        }
    }

    req.open("GET", "/cgi/info.json", true);
    req.send();
}

var statusUpdateTimer;
var statusUpdateTimeout = 500;
function updateFixed(id, val, digits) {
    document.getElementById(id).innerHTML = val.toFixed(digits);
}
function statusUpdate() {
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
            var status = eval("(" + req.responseText + ")");

			document.getElementById('laserState').innerHTML = status.laser.state;
            document.getElementById('position').innerHTML = status.gps.position;
            document.getElementById('ppsState').innerHTML = status.gps.pps_state;
            document.getElementById('motorState').innerHTML = status.motor.state;
            //document.getElementById('speed_fbk').innerHTML = status.motor.speed_fbk;
			updateFixed("speed_fbk", status.motor.speed_fbk/10.0, 1);
            updateFixed("angle_fbk", status.motor.angle_fbk/100.0, 2);
            updateFixed("motor_v", status.motor.motor_v/1000.0, 3);
			updateFixed("motor_i", status.motor.motor_i/10.0, 1);
			//document.getElementById('motor_i').innerHTML = status.motor.motor_i;
            document.getElementById("rotat_direct").innerHTML = status.motor.rotat_direct;
			document.getElementById("param_fix").innerHTML = status.motor.param_fix;

            if (statusUpdateTimeout > 0) {
                statusUpdateTimer = setTimeout("statusUpdate()", statusUpdateTimeout);
            }
        }
    }

    req.open("GET", "/cgi/status.json", true);
    req.send();
}

function enableStatusUpdate() {
    statusUpdateTimeout = 500;
    statusUpdate();
}

function disableStatusUpdate() {
    statusUpdateTimeout = 0;
    clearTimeout(statusUpdateTimer);
}

function onClickTab(objTab, idPanel) {
    var arTabs = objTab.parentNode.children;
    var objPanel = document.getElementById(idPanel);
    var arPanels = objPanel.parentNode.children;

    for (i = 0; i < arTabs.length; i++) {
        document.getElementById(arTabs[i].id).className = "myTab";
        document.getElementById(arPanels[i].id).className = "myPanel";
    }

    document.getElementById(objTab.id).className += " myTabActive";
    document.getElementById(objPanel.id).className += " myPanelActive";
}


function setRadio(radio, val) {
    for (var i = 0; i < radio.length; i++) {
        if (radio[i].value.toLowerCase() == val.toLowerCase())
            radio[i].checked = true;
    }
}

function setSelect(select, val) {
    for (var i = 0; i < select.options.length; i++) {
        if (select.options[i].value.toLowerCase() == val.toLowerCase())
            select.options[i].selected = true;
    }
}

function spinUp(ctl, max) {
    if (ctl.value < max)
        ++ctl.value;
}

function spinDown(ctl, min) {
    if (ctl.value > min)
        --ctl.value;
}

function refreshConfig() {
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
            var settings = eval("(" + req.responseText + ")");

            var panel = document.getElementById('idPanelConfig');

            setRadio(panel.children.laser.laser, settings.laser);
            setSelect(panel.children.returns.returns, settings.returns);

            panel.children.rpm.rpm.value = settings.rpm.toString();
            panel.children.fov.start.value = settings.fov.start.toString();
            panel.children.fov.end.value = settings.fov.end.toString();

            setRadio(panel.children.phaselock.enabled, settings.phaselock.enabled);
            panel.children.phaselock.offset.value = settings.phaselock.offset.toString();

            panel.children.host.addr.value = settings.host.addr;
            panel.children.host.dport.value = settings.host.dport;
            panel.children.host.tport.value = settings.host.tport;

            panel.children.net.addr.value = settings.net.addr;
            panel.children.net.mask.value = settings.net.mask;
            panel.children.net.gateway.value = settings.net.gateway;
            setRadio(panel.children.net.dhcp, settings.net.dhcp);
        }
    }

    req.open("GET", "/cgi/settings.json", true);
    req.send();
}

function refreshDebugConfig() {
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

            var panel = document.getElementById('idPanelDebug');

            setRadio(panel.children.debugMode.debugMode, debug.debugMode);
			setRadio(panel.children.openRing.openRing, debug.openRing);
			setRadio(panel.children.motorDrive.motorDrive, debug.motorDrive);
			setRadio(panel.children.paramFix.paramFix, debug.paramFix);
            panel.children.motor.setSpeed.value = debug.motor.setSpeed.toString();
            panel.children.motor.deadZone.value = debug.motor.deadZone.toString();
            panel.children.motor.advanceAngle.value = debug.motor.advanceAngle.toString();
            panel.children.motor.arPeriod.value = debug.motor.arPeriod.toString();
            panel.children.motor.asrKp.value = debug.motor.asrKp.toString();
            panel.children.motor.asrKi.value = debug.motor.asrKi.toString();
            panel.children.motor.acrKp.value = debug.motor.acrKp.toString();
            panel.children.motor.acrKi.value = debug.motor.acrKi.toString();
        }
    }

    req.open("GET", "/cgi/debug.json", true);
    req.send();
}

