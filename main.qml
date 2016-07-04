import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import B2.Notification 1.0

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
        text: 'string test'
        onClicked: {
            test.text='This is <font color="red">red</font>. '+test.text.length

        }
    }

    Button {
        x: 300
        y: 500
        text: 'set & play'
        onClicked: {
            label.fontInfo.lineGap=0
            label.text='Hello World! This is the first line! and 2nd 3rd'
            label.play(1)
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
            label.fadeout(2000)
            label.fadeoutEnded.connect(onFadeoutEnded)
            console.log(Notification.singletonString)
            Notification.test()
        }
        function onFadeoutEnded(){
            console.log('detected fadeout ended.')
        }
    }
}
