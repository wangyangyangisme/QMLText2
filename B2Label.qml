import QtGraphicalEffects 1.0
import QtQuick 2.7

/* params TBD */
// width: 800
// scale: 1.0
// text: ''
// fontInfo: {name:'Ping Fang SC',pointSize:80,color:'white',lineGap:0.1}
// colorInfo: {c1:Qt.rgba(...), c2:Qt.rgba(...), c3:Qt.rgba(...), pos:0.5}
// shadowInfo: {offset:{x:2,y:2}, opacity:0.8}

/* functions available */
// play(speed)
// clear()
// fadeout(duration[,onStopped])

Item {
    id: b2Label
    width: 800                              // TBD
    scale: 1.0                              // TBD
    property string text: 'Hello Ballade'   // TBD
    height: t.height
    property var fontInfo: ({name:'Ping Fang SC',pointSize:80,color:'white',lineGap:0.1})
    property var shadowInfo: ({offset:{x:2,y:2}, opacity:0.7})

    // aux module
    B2LabelFunc{
        id: func
    }

    // text with shadow & play fx
    Item{
        id: t
        width: parent.width
        height: text0.height

        // text module
        // using: fontInfo: ({name:'Ping Fang SC',pointSize:80,color:'white',lineGap:0.1})
        Text{
            id: text0
            // geo
            leftPadding: 30*scale
            width: parent.width-2*leftPadding
            height: contentHeight
            // prop
            color: fontInfo.color
            font.family: fontInfo.name
            font.pointSize: fontInfo.pointSize * scale
            lineHeight: 1.0+fontInfo.lineGap
            text: b2Label.text
            wrapMode: Text.WordWrap
            visible: false
        }

        // shadow fx module
        // using: property var shadowInfo: ({offset:{x:2,y:2}, opacity:0.7})
        Text{
            id: shadow
            // geo
            leftPadding: text0.leftPadding
            width: text0.width
            height: text0.height
            x: shadowInfo.offset.x * scale
            y: shadowInfo.offset.y * scale
            z: -1
            // prop
            color: 'black'
            font: text0.font
            lineHeight: text0.lineHeight
            opacity: shadowInfo.opacity
            text: text0.text
            wrapMode: text0.wrapMode
            visible: false
        }

        // play fx module -- apply to the root node
        property real playProcess:1
        LinearGradient{
            id: playGrad
            anchors.fill: text0
            start: Qt.point(0,0)
            end: Qt.point(parent.width,0)
            gradient: Gradient{
                GradientStop {position:0; color:Qt.rgba(1,1,1,1)}
                GradientStop {position:1; color:Qt.rgba(1,1,1,0)}
            }
            visible: false
        }
        ThresholdMask{
            id: playMask
            source: text0
            maskSource: playGrad
            // geo
            anchors.fill: text0
            // props
            spread: 0.5
            threshold: 1-parent.playProcess
        }
        NumberAnimation on playProcess {id:playAnim;from:0;to:1;running:false;
            property var myOnStopped
            onStopped:myOnStopped()
        }
        function play(speed,onStopped){
            if(!speed || speed<0) speed=1.0
            var totalWidth=func.mesureWidth(text,fontInfo.name,fontInfo.pointSize)
            playAnim.duration=totalWidth/text0.width/speed * 1000
            playAnim.myOnStopped=function(){
                playProcess=1
                if(onStopped) onStopped()
            }
            playAnim.restart()
        }
        function complete(){
            playAnim.complete()
        }
    }

    // gradient fx module
    LinearGradient{
        id: grad
        source: t
        // geo
        anchors.fill: t
        // props
        start: Qt.point(0,0)
        end: Qt.point(0,t.height)
        gradient: Gradient{
            GradientStop {position:0; color:Qt.rgba(1,1,1,1)}
            GradientStop {position:0.4; color:Qt.rgba(1,1,1,1)}
            GradientStop {position:1; color:Qt.rgba(0.5,0.5,1,1)}
        }
        visible: false
    }

    // fadeout fx module
    property real fadeoutProcess:0
    opacity: 1-fadeoutProcess
    GaussianBlur{
        id: gBlur
        source: grad
        // geo
        anchors.fill: grad
        // prop
        opacity: 0.3+2*fadeoutProcess
        radius: fadeoutProcess*20*scale
        samples: 20
    }
    DirectionalBlur{
        id: dBlur
        source: grad
        // geo
        anchors.fill: grad
        // prop
        angle: 90
        length: fadeoutProcess*70*scale
        opacity: 0.7+1*fadeoutProcess
        samples: 20
    }
    NumberAnimation on fadeoutProcess {id:fadeoutAnim;from:0;to:1;easing.type:Easing.InOutQuad;running:false;
        property var myOnStopped
        onStopped: myOnStopped()
    }

    // functions
    function fadeout(duration,onStopped){
        fadeoutAnim.duration=duration
        fadeoutAnim.myOnStopped=function(){
            text=''
            fadeoutProcess=0
            if(onStopped) onStopped()
        }
        fadeoutAnim.restart()
    }
    function play(speed,onStopped){
        t.play(speed,onStopped)
    }
    function complete(){
        t.complete()
    }
}
