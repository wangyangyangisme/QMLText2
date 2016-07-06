pragma Singleton

import QtQuick 2.7
import B2.File 1.0
import B2.Func 1.0
import B2.Notification 1.0

QtObject {
    function myTrim(s){
        return s.trim().replace(/\s*$/,'')
    }
    // aux functions
    function isBasicCommand(s){
        return myTrim(s).charAt(0)==='+'
    }
    function isCommand(s){
        return myTrim(s).charAt(0)==='@'
    }
    function isComment(s){
        return myTrim(s).charAt(0)===';'
    }
    function isLabel(s){
        return myTrim(s).charAt(0)==='*'
    }
    function isScript(s){
        var c=myTrim(s).charAt(0)
        return c.length>0 && c!=='+' && c!=='@' && c!==';' && c!=='*' && c!=='-' && c!=='='
    }
    function isTalk(s){
        return myTrim(s).charAt(0)==='-'
    }
    function isWait(s){
        return myTrim(s).charAt(0)==='='
    }
    function isEmpty(s){
        return myTrim(s).length===0
    }
    function isIfBranch(s){
        s=myTrim(s)  // removes WS at front & tail
        if(s.substring(0,1)==='@'){
            console.log('*** Parser.isIfBranch(): please remove "@" at the beginning.')
            return false
        }
        if(s.substring(0,2)==='if'){
            return s.match(/^if\s*\(.+\)\s*then$/)!==null
        }
        else if(s.substring(0,6)==='elseif')
            return s.match(/^elseif\s*\(.+\)\s*then$/)!==null
        else if(s==='else')
            return true
        else if(s==='end')
            return true
        return false
    }
    function getExpField(s){
        s=myTrim(s)
        if(s.substring(0,2)==='if')
            return s.substring(2,s.length-4)
        else if(s.substring(0,6)==='elseif')
            return s.substring(6,s.length-4)
        console.log('*** Parser.getExpField(): this line must start with "if" or "elseif".')
        return null
    }

    // props
    property var script: ([ ])
    property string curFile: '(null)'
    property int curLine: -1
    property int nextLine: -1
    property string gameDate: '????-??-??'
    property string curLabel: 'N/A'
    property var ifStack: ([ ])

    // save and load
    function save(){
        var parserData={
            curFile: curFile,
            curLine: curLine,
            nextLine: nextLine,
            gameDate: gameDate,
            curLabel: curLabel,
            ifStack: ifStack
        }
        return JSON.stringify(parserData)
    }
    function load(data){
        var parserData=JSON.parse(data)
        reset(parserData.curFile)
        curFile=parserData.curFile
        curLine=parserData.curLine
        nextLine=parserData.nextLine
        gameDate=parserData.gameDate
        curLabel=parserData.curLabel
        ifStack=parserData.ifStack
    }

    // reset & reload functions
    function reset(file){
        script=([ ])
        curFile=file
        curLine=-1
        nextLine=-1
        gameDate='????-??-??'
        curLabel='N/A'
        ifStack=([ ])
        reload()
    }
    function reload(){
        var path=File.resourcePath('script/'+curFile)
        script=([ ])
        var allLines=File.lines(path)
        for(var i=0;i<allLines.length;i++){
            var line=allLines[i]
            var trimmedLine=myTrim(line)
            if (isScript(line)){
                trimmedLine=trimmedLine.replace(/\'/,"\\'").replace(/\"/,'\\"')
                script.push("@Func.text1('"+trimmedLine+"')")
            }else if (isTalk(line)) {
                trimmedLine=trimmedLine.replace(/\'/,"\\'").replace(/\"/,'\\"')
                script.push(getTalk(trimmedLine))
            }else
                script.push(trimmedLine)
        }
        if(script.length>5000)
            console.log('*** Parser.reload(): should not contain >5000 lines! File:'+curFile)
    }

    // run
    function run(from){
        // check params
        if(!from || from<=0)
            from=0
        // set current and next line
        curLine=from-1
        nextLine=from
        // main loop
        function executeNextLine(){
            curLine=nextLine
            nextLine+=1
            console.log('executeNextLine: cur,next=',curLine,nextLine)
            if(curLine>=script.length){
                console.log('Parser.run(): finished entire script.')
                return
            }
            var line=script[curLine]
            //HasRead.set(curFile,curLine,true)
            var waitFor=processOne(line)    // can be null, undefined, number, string or table(object)
            Notification.wait(waitFor,executeNextLine)
        }
        // now trigger it to start
        executeNextLine()
    }

    //************************************************************
    //                      Private Functions
    //************************************************************
    // script processing functions
    function getTalk(line){
        var i=([ ])
        var name=null
        var showName=null
        var voice=null
        var dlg=null
        i[0]=0
        i[1]=line.indexOf('-',i[0]+1)
        // if we have \ before -, then it does not count
        if(i[1]!==-1 && line.substring(i[1]-1,i[1])==='\\') i[1]=-1
        if(i[1]!==-1){
            i[2]=line.indexOf('-',i[1]+1)
            if(i[2]!==-1 && line.substring(i[2]-1,i[2])==='\\') i[2]=-1
        }
        if(i[2]!==-1){
            i[3]=line.indexOf('-',i[2]+1)
            if(i[3]!==-1 && line.substring(i[3]-1,i[3])==='\\') i[3]=-1
        }
        // remove "-1"s
        for(var j=i.length-1;j>=0;j--)
            if(i[j]===-1)
                i.pop()
        if(i.length===1)
            return "@Func.talk('No Name','No Name','No Dialog')"
        name=line.substring(i[0]+1,i[1])
        if(i.length===2){
            showName=name
            dlg=line.substring(i[1]+1)
        }else{
            showName=line.substring(i[1]+1,i[2])
            if(i.length===3)
                dlg=line.substring(i[2]+1)
            else if(i.length===4){
                voice=line.substring(i[2]+1,i[3])
                dlg=line.substring(i[3]+1)
            }
        }
        if(name===null || name.length===0)
            name='No Name'
        if(showName===null || showName.length===0)
            showName=name
        if(dlg===null || dlg.length===0)
            dlg='No Dialog'
        if(voice===null || voice.length===0)
            return "@Func.talk('"+name+"','"+showName+"','"+dlg+"')"
        else
            return "@Func.talk('"+name+"','"+showName+"','"+dlg+"','"+voice+"')"
    }
    function processOne(line){
        if(isEmpty(line)){
            console.log(curLine+'<EMPTY>')
            return null
        }else if(isBasicCommand(line)){
            var trimmedBCommand=line.substring(1)
            console.log(curLine+'<BCMD>:\t\t'+trimmedBCommand)
            return processBasicCommand(trimmedBCommand)
        }else if(isCommand(line)){
            var trimmedCommand=line.substring(1)
            if(isIfBranch(trimmedCommand)){
                console.log(curLine+'<IFBRANCH>\t'+trimmedCommand)
                return processIfBranch(trimmedCommand)
            }else{
                console.log(curLine+'<CMD>:\t\t'+trimmedCommand)
                return processCommand(trimmedCommand)
            }
        }else if(isComment(line)){
            console.log(curLine+'<COMMENT>\t'+line.substring(1))
            return null
        }else if(isLabel(line)){
            var index_seperator=line.indexOf('|')
            if(index_seperator!==-1){
                var newLabel=line.substring(index_seperator+1)
                console.log(curLine+'<LABEL>:\t'+curLabel+'==>'+newLabel)
                if(newLabel.length>0)
                    curLabel=newLabel
            }else
                console.log(curLine+'<LABEL>:'+curLine)
            return null
        }else if(isWait(line)){
            console.log(curLine+'<WAIT>:'+line)
            return processWait(line)
        }else{
            console.log('*** Parser.processOne(): unknown type of this script line:'+line)
            return null
        }
    }
    function processBasicCommand(command){
        return myEval(command,'processBasicCommand')
    }
    function processCommand(command){
        return myEval(command,'processCommand')
    }
    function processIfBranch(branch){
        var depth=ifStack.length
        var currentNode=(depth>0?ifStack[depth-1]:null)
        var exp=null
        if('if'===branch.substring(0,2)){
            exp=getExpField(branch)
            if(exp.length<=0 || depth<0){
                console.log('***Parser.processIfBranch: exp should NOT be empty, and depth should >=0')
                return
            }
            if(depth>0){
                if('running'!==currentNode.status){
                    ifStack.push({startLine:curLine, status:'skipping'})
                    jumpToNextIfBranch('if')
                    return
                }
            }
            var res=myEval(exp)
            if(res || res===0)
                ifStack.push({startLine:curLine, status:'running'})
            else{
                ifStack.push({startLine:curLine, status:'pending'})
                jumpToNextIfBranch('if')
            }
        }else if('elseif'===branch.substring(0,6)){
            exp=getExpField(branch)
            if(exp.length<=0 || depth<0){
                console.log('***Parser.processIfBranch: exp should NOT be empty, and depth should >=0')
                return
            }
            if(!currentNode){
                console.log('***Parser.processIfBranch: elseif-currentNode should NOT be nil at:',curFile,curLine)
                return
            }
            if('pending'!==currentNode.status){
                currentNode.status='skipping'
                jumpToNextIfBranch('elseif')
                return
            }
            var res2=myEval(exp)
            if(res2 || res2===0)
                currentNode.status='running'
            else
                jumpToNextIfBranch('elseif')
        }else if('else'===branch.substring(0,4)){
            if(!currentNode){
                console.log('***Parser.processIfBranch: elseif-currentNode should NOT be nil at:',curFile,curLine)
                return
            }
            if('pending'!==currentNode.status){
                currentNode.status='skipping'
                jumpToNextIfBranch('else')
            }else
                currentNode.status='running'
        }else if('end'===branch.substring(0,3)){
            if(depth>0){
                ifStack.pop()
                if(ifStack.length>0 && ifStack[ifStack.length-1].status!=='running')
                    jumpToNextIfBranch('end')
            }
        }else{
            console.log('***Parser.processIfBranch: if-branch error.')
        }
    }
    function processWait(line){
        var exp=line.substring(1)
        return myEval(exp,'processWait')
    }
    function myEval(exp,command){
        var result=null
        try{
            result=eval(exp)
        }catch(e) {
            console.log('***Parser.'+command+': error executing expression:'+exp)
            return null
        }
        return result
    }
    function jumpToNextIfBranch(fromWhat){
        for(var i=curLine+1; i<script.length; i++){
            var line=script[i]
            if(isCommand(line) && isIfBranch(line.substring(1))){
                nextLine=i
                return
            }
        }
        console.log('***Parser.jumpToNextIfBranch(): find unclosed branch at:',curLine,fromWhat)
    }
}
