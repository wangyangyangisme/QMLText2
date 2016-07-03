import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 960
    height: 640
    color: Qt.rgba(0.25,0.25,0.45,1)
    B2Label{
        id: label
    }

    Button {
        x: 300
        y: 500
        text: 'play'
        onClicked: {
            label.play(0.2)
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
        }
    }
}
