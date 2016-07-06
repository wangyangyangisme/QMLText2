pragma Singleton

import QtQuick 2.7

QtObject {
    function text1(str){
        console.log('Func.text (will wait 2000 ms for debug): ',str)
        return 2000
    }
    function talk(name,showName,dlg,voice){
        console.log('Func.talk: (will wait 3000 ms for debug)',name,showName,dlg,voice)
        return 3000
    }
}
