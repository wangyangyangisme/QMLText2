pragma Singleton

import QtQuick 2.7

Item {
    opacity: 0
    visible: false

    property var entries: ([ ])
    property var result: null
    property bool isWaiting: false
    property var callbackFunc: null

    function test(){
        console.debug('Singleton object test.')
    }
    function stringOf(t){
        if(t===null)
            return 'null'
        else if(typeof(t)==='string')
            return t
        else if(typeof t == 'object'){
            var str='{'
            for(var k in t)
                str+=(k + ':' + stringOf(t[k]) + ' ')
            str+='}'
            return str
        }else
            return toString(t)
    }
    function index(entry){
        if(typeof(entry)=='string'){
            for(var i=0;i<entries.length;i++)
                if(entries[i]==entry)
                    return i
        }else{
            for(var i=0;i<entries.length;i++){
                var eq=true
                if(typeof(entries[i])=='object'){
                    for(var key in entries[i]){
                        if(key!=='next' && entries[i][key]!==entry[key]){
                            eq=false
                            break
                        }
                    }
                    if(eq)
                        return i
                }
            }
        }
        return null
    }

    function notify(entry){
        console.assert(entry && (typeof(entry)=='string' || typeof(entry)=='object'))
        var i=index(entry)
        if(i===null){
            console.log('*** Notification.notify(): can NOT find this entry:',stringOf(entry))
            return
        }else{
            console.log('Notification.notify(): notified:',stringOf(entry))
        }
        // check 'next'
        if(entries[i].next){
            entries[i]=entries[i].next
            console.log('move to next.')
        }else
            entries.splice(i,1)
        // check if entries is empty
        if(entries.length===0){
            result=entry.result
            isWaiting=false
            // resume here
            console.log('Notification.notify(): will resume because:',stringOf(entry))
            if(callbackFunc === null){
                console.log('***Notification.notify(): can NOT find call back func.')
            }else{
                callbackFunc()
                callbackFunc=null
            }
        }
    }

    // waitFor can be null, number>0, string or table
    function wait(waitFor,callback){
        if(!waitFor){
            callback()
            return
        }else if(typeof waitFor === 'number'){
            console.log('Notification.waitAndCall(): will wait time:'+waitFor)
            _setTimeOut(callback, waitFor)
            return
        }else if(typeof waitFor === 'string' || typeof waitFor === 'object'){
            console.log('Notification.waitAndCall(): will wait string:'+waitFor)
            if(index(waitFor) !== null){
                console.log('*** Notification.wait(): you are waiting '+JSON.stringify(waitFor)+'!')
                return
            }
            entries.push(waitFor)
            callbackFunc=callback
            isWaiting=true
        }else{
            console.log('*** Notification.waitAndCall(): waitFor must be null,number,string or table(object).')
            return
        }
    }
    // private func
    Timer{ id: timer }
    function _setTimeOut(callback, delay){
        timer.interval=delay
        timer.triggered.connect(callback)
        timer.restart()
    }
}
