pragma Singleton

import QtQuick 2.7
import B2.Notification 1.0

QtObject {
    property var label: null

    function text1(str){
        var note={class:'Text', func:'text1'}
        label.setText(str)
        label.play(1.0, function(){Notification.notify(note)})
        return note
    }

    function talk(name,showName,dlg,voice){
        console.log('Func.talk: (will wait 3000 ms for debug)',name,showName,dlg,voice)
        return 3000
    }
}
