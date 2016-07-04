pragma Singleton

import QtQuick 2.7

QtObject {
    property string singletonString: 'this is singleton.'

    function test(){
        console.debug('Singleton object test.')
    }
}
