.pragma library

var _types = [];

_types[1] = busData;
_types[2] = tramData;
_types[3] = busData;
_types[4] = busData;
_types[5] = busData;
_types[6] = metroData;
_types[7] = ferryData;
_types[8] = busData;
_types[12] = trainData;
_types[21] = busData;
_types[22] = busData;
_types[23] = busData;
_types[24] = busData;
_types[25] = busData;

// takes in a single leg and extaxts start/end times of that + type
function decode( legData ) {
    var leg = {};
    var firstLeg = legData.locs[0];
    var lastLeg = legData.locs[ legData.locs.length -1 ];
    leg.first = {};
    leg.first.location = firstLeg.coord;
    leg.first.name = firstLeg.name ? firstLeg.name : '';
    leg.first.time = _parseTime( firstLeg.arrTime );
    leg.last = {};
    leg.last.location = lastLeg.coord;
    leg.last.name = lastLeg.name ? lastLeg.name : '';
    leg.last.time = _parseTime( lastLeg.depTime );
    leg.type = decode_code( legData.type, legData.code ).type
    leg.code = decode_code( legData.type, legData.code ).code;
    return leg;
}

function decode_code (type, code) {
    if( type == 'walk' ) return { code: '', type : 'walk' };
    return _types[type](code);
}

function busData (code) {
    var line = code.slice(1,5);
    line = _removeZeros(line);
    return { type: 'bus', code: line };
}

function trainData(code) {
    var code = code[4];
    return { type: 'train', code: code}
}

function tramData(code) {
    var code = code.slice(3,5).trim();
    return { type: 'tram', code: code}
}

function metroData(code){
    if( code[6] == 2 ) {
        code = 'Ruoholahti';
    } else {
        code = code[4] == 'M' ? 'Mellunmäki': 'Vuosaari';
    }
    return { type: 'metro', code: code}
}

function ferryData(code) {
    return { type: 'ferry', code: ''}
}

function _removeZeros( line ) {
    while( line[0] == '0' ) {
        line = line.slice(1);
    }
    return line;
}

function _parseTime(timeString){
        // HSL returns dates as yyyymmddhhmm -string
        var t = timeString;
        return new Date( t.slice(0,4) , // yyyy
                         parseInt( t.slice(4,6) ) - 1 , // mm, starst from 0
                         t.slice(6,8) , // dd
                         t.slice(8,10)  , // hh
                         t.slice(10,12) , // mm
                        00, 00 ); // secs, ms:
}
