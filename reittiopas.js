.pragma library

var REITTIOPAS = 'http://api.reittiopas.fi/hsl/beta/'
var USER = 'matnel'
var PASS = 'tchrb6ch'

var COORDINATES = 'wgs84' // by default always use this format

function _http_get( parameters, success ) {
    var req = new XMLHttpRequest();
    req.onreadystatechange = function() {
        if (req.readyState == XMLHttpRequest.DONE) {
            var json = eval( req.responseText );
            success( json );
         }
    }
    // add default parameters
    parameters.epsg_in = COORDINATES;
    parameters.epsg_out = COORDINATES;
    parameters.user = USER;
    parameters.pass = PASS;
    // encode parameters to a query string
    // TODO: can this be made nicer
    var query = [];
    for(var p in parameters) {
          query.push(p + "=" + parameters[p] );
    }
    console.log( REITTIOPAS + '?' + query.join('&')  );
    req.open("GET", REITTIOPAS + '?' + query.join('&') );
    req.send();
}


function location_to_address( latitude, longitude, success ) {
        var parameters = {};
        parameters.request = 'reverse_geocode';
        parameters.coordinate = longitude + ',' + latitude;
        _http_get(parameters, function(json) {
                success( json );
        } );
}

function address_to_location(term, success) {
        var parameters = {};
        parameters.request = 'geocode';
        parameters.key = term;
        _http_get(parameters, success );
}

function route(from, to, time, mode, success) {
        var parameters = {};
        parameters.request = 'route';
        parameters.from = from;
        parameters.to = to;
        // TODO may be broken
        parameters.date =  Qt.formatDate( time , 'yyyyMMdd' );
        parameters.time = Qt.formatTime( time, 'hhmm');
        parameters.timetype = mode;
        parameters.show = 5;
        _http_get( parameters, success );
}
