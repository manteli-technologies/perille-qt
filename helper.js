var DATA_MODELS = [];
var DATA_CONTAINERS = [];

function init() {
    // fill with 5 data models
    for( var i = 0; i < 5; i++) {
        var model = Qt.createQmlObject ( 'import QtQuick 1.0; ListModel {}', response );
        DATA_MODELS[i] = model;
    }

    // show response pane (must do like this to confirm that data models have been filled
    // var resultss = Qt.createComponent('ResultPane.qml')

}
