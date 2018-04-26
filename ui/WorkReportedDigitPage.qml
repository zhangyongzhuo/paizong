import QtQuick 2.4
import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
import "qrc:/controls/ui"

WorkReportedDigitPageForm {
    //工作报备界面
    property bool startorEnd: true    //判断开始还是结束日期
    property bool startorEndTime: true    //判断开始还是结束时间
    property var photoList: []    //照片base64数组
    property int entryMode: 0    //从哪进入 1.考勤打卡
    property int entryPageMode:0 //模式增删改查

    Component.onCompleted: {
        finish.visible = false
        reportModel.clear()
        //queryReportExamine()
        //getTypeExamineInfo()
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
            reportModel.clear()
            queryReportExamine(boxMonthsModel.get(boxMonths.currentIndex).code)
        }
    }

    reportType.onCurrentTextChanged: {
        //重新加载报备
        reportModel.clear()
        queryReportExamine(boxMonthsModel.get(boxMonths.currentIndex).code)
    }
    Connections{
        //撤销审批信号
        onRevokeReport:{
            revoke(id,index)
        }
    }

    //查询报备信息
    function queryReportExamine(month){
        noReport.visible=false
        var datajson={
            "currentPage": 1,
            "currentResult": 0,
            "entityOrField": true,
            "pageStr": "string",
            "showCount": 999,
            "totalPage": 0,
            "totalResult": 0,
            "pd": {
                "month"    : month,
                "idCard"   : policeIdCard,
                "auditType":reportTypeModel.get(reportType.currentIndex).code,
                "uid"      :uid
            }
        }
        //var url="http://172.19.12.232:8888/jobpreparation/queryReportExamine"
        var url="http://"+remoteIpPort+"/attendance-service/jobpreparation/queryReportExamine"
        console.log("查询工作报备URL"+url)
        console.log("查询工作报备入参"+JSON.stringify(datajson))
        operatehttp.post(url,function(code, data){
            console.log("查询工作报备回参code"+code)
            console.log("查询工作报备回参data"+data)
            if(code==200||code==0){
                var obj = JSON.parse(data)
                if(obj.result.list.length==0){
                    reportModel.clear()
                    noReport.visible=true
                }
                else{
                    //data加载
                    reportModel.clear()
                    for(var i=0;i<obj.result.list.length;i++){
                        reportModel.append({PreparationText:obj.result.list[i].reportTypeName,
                                            StartTimeStr   :obj.result.list[i].startTime,
                                            EndTimeStr     :obj.result.list[i].endTime,
                                            TimeLong       :obj.result.list[i].timeLong,
                                            PlaceStr       :obj.result.list[i].destination,
                                            Reason         :obj.result.list[i].reportedReasons,
                                            ApproverPer    :obj.result.list[i].auditName,
                                            ApproverOpi    :obj.result.list[i].auditOpinion==null?"":obj.result.list[i].auditOpinion,
                                            Id             :obj.result.list[i].id,
                                            ExamineApproval:obj.result.list[i].auditType,
                                            reportJson     :JSON.stringify(obj.result.list[i].photoPath)})
                    }
               }

           }
            else if(code == 500){
                obj = JSON.parse(data)
                messagebox.text = "查询工作报备日志出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
           else{
               messagebox.text = "查询工作报备失败，请检查网络 错误码:"+code
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

    function revoke(id,index){
        //撤消操作  请求接口  接口请求成功 界面删除该条报备
        var datajson={
            id:id
        }
        //var url="http://172.19.12.232:8888/jobpreparation/revoke" //http://ip:host/jobpreparation/revoke
        var url="http://"+remoteIpPort+"/attendance-service/jobpreparation/revoke"
        console.log("撤消报备操作URL："+url)
        console.log("撤消报备操作参数："+JSON.stringify(datajson))
        busying.running = true

        operatehttp.post(url,function(code, data){
            console.log("撤消报备操作回参code："+code)
            console.log("撤消报备操作回参data："+data)
            busying.running = false
            if(code == 200){
                reportModel.remove(index)
                messagebox.text = "撤销报备操作成功"
                messagebox.visible = true
            }
            else if(code == 500){
                var obj = JSON.parse(data)
                messagebox.text = "撤销报备出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "撤消报备失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
         },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }
}

