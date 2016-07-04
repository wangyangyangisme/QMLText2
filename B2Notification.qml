pragma Singleton

import QtQuick 2.7

QtObject {
    property var entries: ([ ])
    property var result: null
    property bool isWaiting: false
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
    function find(entry){
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
    function wait(){
        var count=arguments.length
        if(count===0){
            console.log("*** Notification.wait(): You MUST wait something.")
            return
        }
        for(var i=0;i<count;i++){
            var oneEntry=arguments[i]
            if(oneEntry===null || (typeof oneEntry !== 'string' && typeof oneEntry !== 'object')){
                console.log("*** Notification.wait(): You must wait a string/object")
                return
            }
            if(find(oneEntry)!==null){
                console.log("*** Notification.wait(): This entry already exists!!")
                return
            }
            entries.push(oneEntry)
            console.log('will wait '+stringOf(oneEntry))
        }
        isWaiting=true
    }
    function notify(entry){
        console.assert(entry && (typeof(entry)=='string' || typeof(entry)=='object'))
        var i=find(entry)
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
            // should resume here
            console.log('will resume because:',stringOf(entry))
        }
    }
}
