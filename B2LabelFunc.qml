pragma Singleton

import QtQuick 2.7

FontMetrics{
    function mesureRect(str,fontName,fontSize){
        this.font.family=fontName
        this.font.pointSize=fontSize
        return this.boundingRect(str)
    }
    function mesureWidth(str,fontName,fontSize){
        return mesureRect(str,fontName,fontSize).width
    }
    function calcGradPos(lineCount,i,lineGap,colorPos){
        /* contentHeight (normalized as 1.0) contains: 3xgap + 3xTTTT */
        /* some English letters, e.g. 'g' and 'j' will take the space of the gap below */
        // ----------gap--------    <--fontInfo.lineGap, control point: g1
        // TTTTTTTTTTTTTTTTTTTTT    <--colorInfo.pos, control point: p1
        // ----------gap--------    <--control point: b1, g2; b1 is slightly less than g2,g2=g1+1/lineCount
        // TTTTTTTTTTTTTTTTTTTTT    <--control point: p2; p2=p1+1/lineCount
        // ----------gap--------    <--control point: b2, g3; b2=b1+1/lineCount,g3=g2+1/lineCount
        // TTTTTTTTTTTTTTTTTTTTT    <--control point: p3; p3=p2+1/lineCount
        // ----------gap--------    <--control point: b3; b3=b2+1/lineCount
        /* according to this algorithm, tables for lineCount==1,2,3 will be: */
        // table with lineCount==1: [g1,g1,g1,g1,g1,g1,g1,p1,b1]
        // table with lineCount==2: [g1,g1,g1,g1,p1,b1,g2,p2,b2]
        // table with lineCount==3: [g1,p1,b1,g2,p2,b2,g3,p3,b3]
        var g=lineGap
        var p=colorPos/(1+g)
        var b=1
        var delta=0.05
        // set gradient control points table
        var table=[]
        // push enough g1 --> table
        var g1=g/lineCount
        for(var ii=0;ii<(3-lineCount)*3;ii++)
            table.push(g1)
        // now, push g1,p1,b1
        var p1=p/lineCount
        var b1=b/lineCount-delta
        for(ii=0;ii<lineCount;ii++){
            table.push(g1)
            table.push(p1)
            table.push(b1)
            g1+=1/lineCount
            p1+=1/lineCount
            b1+=1/lineCount
        }
        return table[i]
    }
    function calcGradColor(lineCount,i,colorInfo){
        var c1=colorInfo.c1
        var c2=colorInfo.c2
        var c3=colorInfo.c3
        var table=[ [c1,c1,c1,c1,c1,c1,c1,c2,c3],
                   [c1,c1,c1,c1,c2,c3,c1,c2,c3],
                   [c1,c2,c3,c1,c2,c3,c1,c2,c3]]
        return table[lineCount-1][i]
    }
    // W == totalWidth/lineWidth
    function calcPlayFxPos(lineCount,lineIndex,W){
        var pos=1.0
        if(lineIndex===lineCount-1 && W!==0){
            W+=lineCount*0.2
            pos=W-lineIndex
        }
        return Math.min(1,pos)
    }
    function calcPlayFxOpa(lineCount,i,W){
        W+=lineCount*0.2
        var p=Math.ceil(i/2)*(1/W)
        return Math.max(0,1-p)
    }
    function test(){
        console.log('this is label func test')
    }
}
