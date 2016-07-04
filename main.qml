import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import B2.Notification 1.0
import B2.File 1.0

ApplicationWindow {
    visible: true
    width: 960
    height: 640
    color: Qt.rgba(0.25,0.25,0.45,1)
    B2Label{
        id: label
    }
    Text{
        id: test
        x:300
        y:50
        font.pointSize: 40
    }

    Button {
        x:100
        y:500
        text: 'FileWrite'
        onClicked: {
            var data='286万岁!'
            var suc=File.write(File.dataPath('1.sav'), data)
            this.text='FileWrite:'+suc
        }
    }
    Button {
        x:100
        y:400
        text: 'FileRead'
        onClicked: {
            var data=File.read(File.dataPath('1.sav'))
            this.text='FileRead:'+data
        }
    }
    Button {
        x:100
        y:300
        text: 'FileRemove'
        onClicked: {
            var success=File.remove(File.dataPath('1.sav'))
            this.text="FileRemove:"+success
        }
    }

    Button {
        x: 300
        y: 500
        text: 'set & play'
        onClicked: {
            label.fontInfo=({name:'Ping Fang SC', pointSize:50, color:'white', lineGap:0.1})
            label.text='Hello World! This is the first line! and 2nd 3rd and many, h'
            label.play(1.0, function(){Notification.notify({class:'Text', name:'play'})})
            Notification.wait({class:'Text',name:'play'})
        }
    }
    Button {
        x: 500
        y: 500
        text: 'complete'
        onClicked: {
            label.complete()
        }
    }

    Button{
        x: 700
        y: 500
        text: 'fadeout'
        onClicked: {
            label.fadeout(2000, function(){Notification.notify({class:'Text', name:'fade'})})
            Notification.wait({class:'Text', name:'fade'})
        }
        function onFadeoutEnded(){
            console.log('detected fadeout ended.')
        }
    }
}
