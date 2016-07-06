import QtGraphicalEffects 1.0
import QtQuick 2.7
import B2.LabelFunc 1.0
import B2.Notification 1.0

/* functions available */
// play(speed [,onStopped])
// fadeout(duration [,onStopped])
// setRect(x,y,w)
// setScale(s)
// setText(t)
// setInfo(fontInfo,colorInfo,shadowInfo)

/* params TBD */
// width: 800
// scaleFactor: 1.0
// text: ''
// fontInfo: {name:'Ping Fang SC',pointSize:80,color:'white',lineGap:0.1}
// colorInfo: {c1:Qt.rgba(...), c2:Qt.rgba(...), c3:Qt.rgba(...), pos:0.5}
// shadowInfo: {offset:{x:2,y:2}, opacity:0.8}

Item {
    id: b2Label
    height: t.height
    width: 800                              // TBD
    property string text: 'Hello Ballade'   // TBD
    property real scaleFactor: 1.0          // TBD
    property var fontInfo: ({name:'Ping Fang SC', pointSize:80, color:'white', lineGap:0.1})
    property var colorInfo: ({c1:Qt.rgba(1,1,1,1), c2:Qt.rgba(1,1,1,1), c3:Qt.rgba(0.5,0.6,1,1), pos:0.5})
    property var shadowInfo: ({offset:{x:2,y:2}, opacity:0.7})

    // t module (text+shadow+grad)
    Item{
        id: t
        width: parent.width
        height: text0.height
        property var lineGeo: ([ ])

        // text0 module
        // using: fontInfo: ({name:'Ping Fang SC',pointSize:80,color:'white',lineGap:0.1})
        Text{
            id: text0
            // geo
            leftPadding: 30*scaleFactor
            width: parent.width-2*leftPadding
            height: contentHeight
            // prop
            color: fontInfo.color
            font.family: fontInfo.name
            font.pointSize: fontInfo.pointSize * scaleFactor
            lineHeight: 1.0+fontInfo.lineGap
            text: b2Label.text
            wrapMode: Text.WordWrap
            visible: false
        }

        // shadow module <--- text0
        // using: property var shadowInfo: ({offset:{x:2,y:2}, opacity:0.7})
        Text{
            // geo
            leftPadding: text0.leftPadding
            width: text0.width
            height: text0.height
            x: shadowInfo.offset.x * scaleFactor
            y: shadowInfo.offset.y * scaleFactor
            z: -1
            // prop
            color: 'black'
            font: text0.font
            lineHeight: text0.lineHeight
            opacity: shadowInfo.opacity
            text: text0.text
            wrapMode: text0.wrapMode
        }

        // gradient module <--- text0
        LinearGradient{
            source: text0
            // geo
            anchors.fill: text0
            // props
            start: Qt.point(0,0)
            end: Qt.point(0,text0.height)
            gradient: Gradient{
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,0,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,0,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,1,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,1,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,2,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,2,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,3,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,3,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,4,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,4,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,5,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,5,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,6,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,6,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,7,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,7,colorInfo)}
                GradientStop {position:LabelFunc.calcGradPos(text0.lineCount,8,fontInfo.lineGap,colorInfo.pos);color:LabelFunc.calcGradColor(text0.lineCount,8,colorInfo)}
            }
        }

        // set t's visible to false
        visible: false
    } // end of t

    // play module <-- 't'
    property real playProcess:1
    property real totalWidth:0
    Item{
        id: playGrad
        anchors.fill: t
        Repeater{
            model: text0.lineCount
            LinearGradient{
                width: parent.width
                height: parent.height/text0.lineCount
                y: index*height
                start: Qt.point(0,0)
                end: Qt.point(t.width, 0)
                gradient: Gradient{
                    GradientStop {position:0; color:Qt.rgba(1,1,1,LabelFunc.calcPlayFxOpa(text0.lineCount,index*2,totalWidth/width))}
                    GradientStop {position:LabelFunc.calcPlayFxPos(text0.lineCount,index,totalWidth/width);color:Qt.rgba(1,1,1,LabelFunc.calcPlayFxOpa(text0.lineCount,index*2+1,totalWidth/width))}
                }
            }
        }
        visible: false
    }
    ThresholdMask{
        id: playMask
        source: t
        maskSource: playGrad
        // geo
        anchors.fill: t
        // props
        opacity: 0.5
        spread: 0.5
        threshold: 1-playProcess
    }
    NumberAnimation on playProcess {id:playAnim;from:0;to:1;running:false}
    function play(speed,onStopped){
        if(!speed || speed<0) speed=1.0
        totalWidth=LabelFunc.mesureWidth(text,fontInfo.name,fontInfo.pointSize)
        var totalDuration=totalWidth/text0.width/speed * 1000
        if(totalDuration<50) totalDuration=50
        playAnim.duration=totalDuration
        playAnim.stopped.connect(function(){
            playProcess=1
            if(onStopped) onStopped()
        })
        playAnim.restart()
        return totalDuration
    }
    function complete(){
        playAnim.complete()
    }

    // fadeout module <--- 'play'
    property real fadeoutProcess:0
    opacity: 1-fadeoutProcess
    GaussianBlur{
        source: playMask
        // geo
        anchors.fill: playMask
        // prop
        opacity: 0.3+8*fadeoutProcess
        radius: fadeoutProcess*20*scaleFactor
        samples: 20
    }
    DirectionalBlur{
        source: playMask
        // geo
        anchors.fill: playMask
        // prop
        angle: 90
        length: fadeoutProcess*70*scaleFactor
        opacity: 0.7+5*fadeoutProcess
        samples: 20
    }
    NumberAnimation on fadeoutProcess {id:fadeoutAnim;from:0;to:1;easing.type:Easing.InOutQuad;running:false}
    function fadeout(duration,onStopped){
        fadeoutAnim.duration=duration
        fadeoutAnim.stopped.connect(function(){
            text=''
            fadeoutProcess=0
            if(onStopped) onStopped()
        })
        fadeoutAnim.restart()
    }

    // other functions
    function setRect(x,y,w){
        this.x=x; this.y=y; this.width=width;
    }
    function setScale(s){
        scaleFactor=s
    }
    function setText(t){
        this.text=t
    }
    function setInfo(fontInfo,colorInfo,shadowInfo){
        if(fontInfo)
            this.fontInfo=fontInfo
        if(colorInfo)
            this.colorInfo=colorInfo
        if(shadowInfo)
            this.shadowInfo=shadowInfo
    }
}
