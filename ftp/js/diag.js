var diagnosticsUpdateTimer;
var diagnosticsUpdateTimeout = 500;

function updateFixed(id, val, digits) {
    document.getElementById(id).innerHTML = val.toFixed(digits);
}

function hdltop_volts_to_hv(volts) {
    return 101.0 * (volts - 5.0);
}

function lm20_volts_to_degCel(volts) {
    return -1481.96 + Math.sqrt(2.1962E6 + (1.8639 - volts) / 3.88E-6);
}

function acs17_volts_to_amps(volts) {
    return 10.0 * (volts - 2.5);
}

function scale_volt_temp(volt_temp) {

    var scale_2x_vref = 5.0 / 4096;
    var scale_1x_vref = 10.0 / 100;

    for (var sample in volt_temp.top)
        volt_temp.top[sample] *= scale_1x_vref;

    for (var sample in volt_temp.bot)
        volt_temp.bot[sample] *= scale_2x_vref;

    //volt_temp.top.hv = hdltop_volts_to_hv(volt_temp.top.hv);
    //volt_temp.top.lm20_temp = lm20_volts_to_degCel(volt_temp.top.lm20_temp);
    //volt_temp.top.pwr_5v *= 2.0;

    volt_temp.bot.i_out = acs17_volts_to_amps(volt_temp.bot.i_out);
    volt_temp.bot.lm20_temp = lm20_volts_to_degCel(volt_temp.bot.lm20_temp);
    volt_temp.bot.pwr_5v *= 2.0;
}

function diagnosticsUpdate() {
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
            var diag = eval("(" + req.responseText + ")");

            scale_volt_temp(diag.volt_temp);

            updateFixed("top_hv", diag.volt_temp.top.hv, 1);
            updateFixed("top_lm20_temp", diag.volt_temp.top.lm20_temp, 2);
            updateFixed("top_pwr_5v", diag.volt_temp.top.pwr_5v, 3);
            updateFixed("top_pwr_12v", diag.volt_temp.top.pwr_12v, 3);
            updateFixed("top_pwr_8v", diag.volt_temp.top.pwr_8v, 3);
            updateFixed("top_pwr_3v", diag.volt_temp.top.pwr_3v, 3);
            //updateFixed("top_pwr_vccint", diag.volt_temp.top.pwr_vccint, 3);

            updateFixed("bot_i_out", diag.volt_temp.bot.i_out, 3);
            updateFixed("bot_lm20_temp", diag.volt_temp.bot.lm20_temp, 3);
            //updateFixed("bot_pwr_1_2v", diag.volt_temp.bot.pwr_1_2v, 3);
            updateFixed("bot_pwr_5v", diag.volt_temp.bot.pwr_5v, 3);
            //updateFixed("bot_pwr_2_5v", diag.volt_temp.bot.pwr_2_5v, 3);
            updateFixed("bot_pwr_3_3v", diag.volt_temp.bot.pwr_3_3v, 3);
            updateFixed("bot_pwr_v_in", diag.volt_temp.bot.pwr_v_in*11.0, 3);
            //updateFixed("bot_pwr_1_25v", diag.volt_temp.bot.pwr_1_25v, 3);

            updateFixed("vhv", diag.vhv, 0);

            if (diagnosticsUpdateTimeout > 0) {
                diagnosticsUpdateTimer = setTimeout(diagnosticsUpdate, diagnosticsUpdateTimeout);
            }
        }
    }

    req.open("GET", "/cgi/diag.json", true);
    req.send();
}

function enableDiagnosticsUpdate() {
    diagnosticsUpdateTimeout = 500;
    diagnosticsUpdate();
}

function disableDiagnosticsUpdate() {
    diagnosticsUpdateTimeout = 0;
    clearTimeout(diagnosticsUpdateTimer);
}

