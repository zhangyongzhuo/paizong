import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
ModifyPasswordPageForm {
    signal savePasswordState(bool isSuccess)
    finish.onClicked:{
        savePassword()
    }
    onSavePasswordState: {
        if(isSuccess){
            jumpTimer.start()
        }
    }
    Timer{
        id: jumpTimer
        interval: 1000
        repeat: false
        onTriggered: {
            stackView.pop()
        }
    }
    function savePassword(){
        if(newpassword.text!==confirmpassword.text){
            messagebox.visible = true
            messagebox.text = "确认密码必须与新密码相同"
            console.log("确认新登录密码必须和新登录密码相等!")
            emit: savePasswordState(false)
            return
        }
        if(newpassword.text===oldpassword.text){
            messagebox.visible = true
            messagebox.text = "新登录密码不可以与旧登录密码相同"
            console.log("新登录密码不可以与旧登录密码相同!")
            emit: savePasswordState(false)
            return
        }
        if(newpassword.text.indexOf(" ")>=0){
            messagebox.visible = true
            messagebox.text = "密码不应包含空格"
            console.log("密码不应包含空格")
            emit: savePasswordState(false)
            return
        }
        //数据库密码修改接口
        var datajson = {
            "old": oldpassword.text,
            "new": newpassword.text,
            "policeIdcard"     : policeIdCard,
            "userName":userName
        }

        console.log("-----修改密码："+JSON.stringify(datajson))

        var url ="http://"+goIpPort+"/changePassword"
        operatehttp.post(url,function(code, data){
            console.log(code,data)
            var obj = JSON.parse(data)
            if(code === 200){
                console.log("修改密码成功")
                messagebox.visible = true
                messagebox.text = "密码修改成功"
                emit: savePasswordState(true)
            }else{
                messagebox.visible = true
                messagebox.text = obj.msg
                emit: savePasswordState(false)
            }
        },"(0)="+JSON.stringify(datajson))
    }
}
