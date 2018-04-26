import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL

WorkLogDigitPageForm {
    //工作日志统计界面
    property bool startorEnd: true    //判断开始还是结束日期
    property bool startorEndTime: true    //判断开始还是结束时间
    property var photoList: []    //照片base64数组
    property int entryMode: 0    //从哪进入 1.考勤打卡
    property int entryPageMode:0 //模式增删改查
    //JSL.cutStr(obj.result.list[i].addTime,0,10)==后台接口传回当天时间？true:false  60行

    Component.onCompleted: {
        finish.visible = false
        //1、清除日志model
        reportModel.clear()
        //清除日期信息并获取有效月份
        boxMonthsModel.clear()
        getSystemUseTime()
    }

    back.onClicked: {
        emit:finishTask()
    }

    //时间下拉框内容改变
    boxMonths.onCurrentTextChanged: {
        //重新加载报备
        if(boxMonths.currentIndex != -1){
            //重新按照日期月份加载日志
            reportModel.clear()
            queryLogInfo(boxMonthsModel.get(boxMonths.currentIndex).code)
        }
    }

    Connections{
        target: mainQml
        onLogSaveOk:{
            //修改日志结束 重新加载日志列表
            reportModel.clear()
            queryLogInfo(boxMonthsModel.get(boxMonths.currentIndex).code)
        }
    }

    //查询日志信息
    function queryLogInfo(month){
        noLog.visible=false
        var datajson={
            "currentPage": 1,
            "currentResult": 0,
            "entityOrField": true,
            "pageStr": "string",
            "showCount": 999,
            "totalPage": 0,
            "totalResult": 0,
            "pd": {
                "idCard": policeIdCard,
                "uid":uid,
                "month":month//"201711"//可以不传，不传默认当前月
            }
        }
        //var url="http://172.19.12.232:8888/DailyLog/queryDailyLog"
        var url="http://"+remoteIpPort+"/attendance-service/DailyLog/queryDailyLog"
        busying.running = true
        console.log("查询工作日志URL"+url)
        console.log("查询工作日志入参"+JSON.stringify(datajson))
        operatehttp.post(url,function(code, data){
            console.log("查询工作日志回参code"+code)
            console.log("查询工作日志回参data"+data)
            busying.running = false
            if(code==200||code==0){
                var obj = JSON.parse(data)
                if(obj.result.list.length==0){
                    reportModel.clear()
                    noLog.visible=true
                }
                else{
                    //data加载
                    for(var i=0;i<obj.result.list.length;i++){
                        reportModel.append({WorkLogTime:obj.result.list[i].addTime,//true是当天false不是
                                            BtnVisble  :obj.result.list[i].isCurrentDay,
                                            WorkLogText:obj.result.list[i].logText,
                                            Id         :obj.result.list[i].id
                                           })
                    }
                }
            }
            else if(code==500){
                obj = JSON.parse(data)
                console.log("查询工作日志接口发生错误，错误码:"+code)
                messagebox.text = "查询工作日志出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                console.log("查询工作日志接口发生错误，错误码:"+code)
                messagebox.text = "查询工作日志失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //获取有效月份并显示
    function getSystemUseTime(){
            //var url ="http://172.19.12.232:8888/stat/getSystemUseTime"
            var url="http://"+remoteIpPort+"/attendance-service/stat/getSystemUseTime"
            console.log("获取有效月份URL："+url)
            busying.running = true

            operatehttp.get(url,function(code, data){
                console.log("获取有效月份回参code："+code)
                console.log("获取有效月份回参data："+data)
                busying.running = false
                if(code == 200){
                    var obj = JSON.parse(data)
                    //计算起止日期之间的所有月份
                    var useTime = JSL.getMonthBetween(obj.result.beginDate, obj.result.currentDate)
                    //添加到下拉列表中
                    var j= useTime.length-1
                    for(var i=j; i>=0; i--){
                        boxMonthsModel.append({text:useTime[i].text,code:useTime[i].code})
                    }
                    //默认选择当前月
                    boxMonths.currentIndex = 0
                    boxMonths.currentText = useTime[j].text
                }
                else if(code == 500){
                    obj = JSON.parse(data)
                    console.log("获取有效月份接口发生错误，错误码:"+code)
                    messagebox.text = "获取有效月份出错，错误原因:"+obj.reason.text
                    messagebox.visible = true
                }
                else{
                    console.log("获取有效月份接口发生错误，错误码:"+code)
                    messagebox.text = "获取有效月份失败，请检查网络，错误码:"+code
                    messagebox.visible = true
                }
            },token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
        }
}
