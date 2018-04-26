import QtQuick 2.4

SystemSetUseModePageForm {

    Component.onCompleted: {
        if(online){
            modeOnline.checked = true
        }else{
            modeOffline.checked = true
        }
    }
    finish.onClicked:{
        if(modeOnline.checked==true){
            changeUseMode('online')
        }else{
            changeUseMode('offline')
        }   
    }
    function changeUseMode(type){
        var url ="http://"+goIpPort+"/changeLogin/"+type
        operatehttp.get(url, function(code, data){
            if(code===200){
                if(modeOnline.checked==true){
                    online = true
                }else{
                    online = false
                }
                emit: finishTask()
                stackView.pop()
            }else{
                messagebox.text = '更改使用模式失败'+code
                messagebox.visible = true
            }
        })
    }
}
