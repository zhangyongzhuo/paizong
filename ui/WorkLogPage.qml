import QtQuick 2.5
import QtMultimedia 5.5
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0

WorkLogPageForm {
    property int    finishIndex:-1
    property int    entryPageMode:0 //模式增删改查
    property string workLogText:""
    property int    logId:0
    property bool   isAtt: false

    Component.onCompleted:{
        workSpecification.text=workLogText
        wordsNumber.text=workSpecification.text.length+"/"+512
    }

    finish.onClicked:{
        //调用保存日志接口
        if(isAtt){
            messagebox.text = "正在提交工作日志，请稍候"
            messagebox.visible = true
        }
        else if(JSL.trimAll(workSpecification.text) == ""){
            messagebox.text = '请输入有效的工作日志内容'
            messagebox.visible = true
        }
        else{
            if(entryPageMode == QmlData.VISIT_TYPE_INCREASE){//新增工作日志
                addLogInfo()
            }
            else if(entryPageMode == QmlData.VISIT_TYPE_MODIFY){//修改已有工作日志
                editLogInfo()
            }
        }
    }

    back.onClicked: {
        if(isAtt){
            messagebox.text = "正在提交工作日志，请稍候"
            messagebox.visible = true
        }
    }

    //保存日志信息
    function addLogInfo(){
         var datajson={
            "idCard": policeIdCard,
            "logText":JSL.trimAll(workSpecification.text),
            "longitude":longitude,
            "latitude":latitude,
            "uid":uid
        }
        //var url="http://172.19.12.232:8888/DailyLog/addDailyLog"
        var url="http://"+remoteIpPort+"/attendance-service/DailyLog/addDailyLog"
        console.log("提交工作日志URL:"+url)
        console.log("提交工作日志入参:"+JSON.stringify(datajson))
        isAtt = true
        busying.running = true
        operatehttp.post(url,function(code, data){
            console.log("提交工作日志回参code:"+code)
            console.log("提交工作日志回参data:"+data)
            isAtt = false
            busying.running = false
            if(code==200||code==0){
                messagebox.text = "提交工作日志成功"
                messagebox.visible = true
                //开启跳出该界面定时器
                finishTimer.start()
            }
            else if(code == 500){
                var obj = JSON.parse(data)
                console.log("提交工作日志发生错误，错误码:"+code)
                messagebox.text = "提交工作日志出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                console.log("提交工作日志发生错误，错误码:"+code)
                messagebox.text = "提交工作日志失败，请检查网络 错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //编辑日志信息
    function editLogInfo(){
        var datajson={
            "id": logId,
            "logText":JSL.trimAll(workSpecification.text),
            "uid":uid
        }
        //var url="http://172.19.12.232:8888/DailyLog/editDailyLog"
        var url="http://"+remoteIpPort+"/attendance-service/DailyLog/editDailyLog"
        console.log("编辑工作日志URL:"+url)
        console.log("编辑工作日志入参:"+JSON.stringify(datajson))
        isAtt = true
        busying.running = true
        operatehttp.post(url,function(code, data){
            console.log("编辑工作日志回参code:"+code)
            console.log("编辑工作日志回参data:"+data)
            isAtt = false
            busying.running = false
            if(code==200||code==0){
                emit:logSaveOk()     
                messagebox.text = "修改工作日志成功"
                messagebox.visible = true
                //开启跳出该界面定时器
                finishTimer.start()
            }
            else if(code == 500){
                var obj = JSON.parse(data)
                messagebox.text = "修改工作日志出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "修改工作日志失败，请检查网络 错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //等待一秒钟后跳出该界面
    Timer{
        id:finishTimer
        interval: 1000;
        repeat: false;
        onTriggered: {
            emit:finishTask()
            stackView.pop()
        }
    }
}
