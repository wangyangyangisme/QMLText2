import QtQuick 2.7

Item {
    id: b2LabelFunc
    FontMetrics{
        id: fm
    }
    function mesureRect(str,fontName,fontSize){
        fm.font.family=fontName
        fm.font.pointSize=fontSize
        return fm.boundingRect(str)
    }
    function mesureWidth(str,fontName,fontSize){
        return mesureRect(str,fontName,fontSize).width
    }
    function calcGradPos(lineCount,divIndex,divPos){
        //TODO
    }
    function calcGradColor(lineCount,divIndex,divPos){
        //TODO
    }
}
