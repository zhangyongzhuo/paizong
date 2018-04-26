import QtQuick 2.5
import QtMultimedia 5.5
import QtQml.Models 2.1
import QtQuick.Controls 1.2
import com.hylink.fmcp.ctrl 2.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL

AttendanceClockDigitPageForm {

    Component.onCompleted: {
        finish.visible = false

        //清除日期信息并获取有效月份
        boxMonthsModel.clear()
        getSystemUseTime()
    }

    back.onClicked: {
        emit:finishTask()
    }

    //时间下拉框内容改变
    boxMonths.onCurrentTextChanged: {
        //获取这个月的考勤信息
        if(boxMonths.currentIndex != -1){
            //获取当前月统计数据
            getPoliceStatistic(boxMonthsModel.get(boxMonths.currentIndex).code)
            //获取日历信息
            getMonthsStatisticsData(boxMonthsModel.get(boxMonths.currentIndex).code)
        }
    }


    Connections{
        //选中的天数发生变化信号
        onCurrentDayChanged:{           
            if(dayBusying.running){
                messagebox.text = "正在获取详细统计信息，请稍候"
                messagebox.visible = true
                return
            }
            else if(revokeBusying.running){
                messagebox.text = "正在撤销报备信息，请稍候"
                messagebox.visible = true
                return
            }

            //查询选中天详细考勤信息
            var day = JSL.repelaceChar(text,"-","")
            getDayStatisticsData(day)
        }

        //撤销审批信号
        onRevokeReport:{
            revoke(id,index)
        }
    }

    //获取有效月份并显示
    function getSystemUseTime(){
        //var url ="http://172.19.12.232:8888/stat/getSystemUseTime"
        var url="http://"+remoteIpPort+"/attendance-service/stat/getSystemUseTime"
        console.log("获取有效月份URL："+url)

        timeBusying.running = true
        operatehttp.get(url,function(code, data){
            console.log("获取有效月份回参code："+code)
            console.log("获取有效月份回参data："+data)
            timeBusying.running = false
            if(code == 200 || code == 0){
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
                messagebox.text = "获取有效月份出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "获取有效月份失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
        },token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //获取日历数据
    function getMonthsStatisticsData(month){
        var datajson={
            "idCard": policeIdCard,
            "gunder": policeUnitCode,
            "uid":uid,
            "month":month
        }
        //var url ="http://172.19.12.232:8888/stat/getMonthStatisticsData"
        var url="http://"+remoteIpPort+"/attendance-service/stat/getMonthStatisticsData"
        console.log("获取日历URL："+url)
        console.log("获取日历入参："+JSON.stringify(datajson))

        monthBusying.running = true
        operatehttp.post(url,function(code, data){
            console.log("日历接口回参code"+code)
            console.log("日历接口回参data"+data)
            monthBusying.running = false
            if(code == 200|| code == 0){
                var obj = JSON.parse(data)                
                //显示到控件中
                showMonthStatisticsData(obj.result)
            }
            else if(code == 500){
                obj = JSON.parse(data)
                messagebox.text = "获取日历信息出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "获取日历信息失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }
    //显示日历数据
    function showMonthStatisticsData(monthObj){
        articleModel.clear()
        var currentDay = JSL.getSystemDay(monthObj[0].date)
        var stste=true
        var ststeVisible=true
        //占空位 计算每个月1号是星期几 如果为周六 则周一到周五用空位补齐
        for(var i=1; i<currentDay; i++){
            articleModel.append({ISBLACK:false,TEXT:'',BCVISIBLE:false,STATE:true,STATEVISIBLE:false, CHECK:false})
        }
        //填日期
        for(var j=0; j<monthObj.length; j++){
            if(monthObj[j].stateCode == '00'){     //初始状态 不显示日期下的小圆点
                stste=true
                ststeVisible=false
            }
            else if(monthObj[j].stateCode == '01'){//正常状态 日期下的小圆点为蓝色
                stste=true
                ststeVisible=true
            }
            else if(monthObj[j].stateCode == '02'){//异常状态 日期下的小圆点为橙色
                stste=false
                ststeVisible=true
            }

            articleModel.append({ISBLACK:Boolean(monthObj[j].isWorked), //是否出勤 决定了字体颜色是黑色还是灰色
                                 TEXT:monthObj[j].text,        //日期     决定了日历上显示的字
                                 BCVISIBLE:Boolean(monthObj[j].isCurrentDay),//是否是当天 决定了是否显示底色（浅蓝色）
                                 STATE:stste,                  //状态     决定了日期下的小黄点为什么颜色
                                 STATEVISIBLE:ststeVisible,    //        决定了日期下的小黄点是否显示 初始状态不显示小黄点
                                 CHECK:Boolean(monthObj[j].isCurrentDay), //是否是当天 决定了是否默认选中
                                 DATE:monthObj[j].date
                                })
        }
    }

    //获取某天详细数据
    function getDayStatisticsData(day){
        var datajson={
            "idCard": policeIdCard,
            "gunder": policeUnitCode,
            "uid":uid,
            "day":day
        }
        //var url ="http://172.19.12.232:8888/stat/getDayStatisticsData"
        var url="http://"+remoteIpPort+"/attendance-service/stat/getDayStatisticsData"
        console.log("获取某天详细数据URL："+url)
        console.log("获取某天详细数据入参："+JSON.stringify(datajson))

        dayBusying.running = true
        operatehttp.post(url,function(code, data){
            console.log("获取某天详细数据回参code："+code)
            console.log("获取某天详细数据回参data："+data)
            dayBusying.running = false
            if(code == 200|| code == 0){
                var obj = JSON.parse(data)
                //将返回数据显示到控件中
                showDayStatisticsData(obj.result)
            }
            else if(code == 500){
                obj = JSON.parse(data)
                messagebox.text = "获取当天统计出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "获取当天统计失败，请检查网络，错误码:"+code
                messagebox.visible = true               
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //显示某天详细统计数据
    function showDayStatisticsData(dayObj){

        //判断有无考勤数据
        if(dayObj.signinStateCode != null){//有考勤记录
            noHaveAttVisible = false

            if(dayObj.signinImage == null){
                dayObj.signinImage=""
            }
            if(dayObj.signoutImage == null){
                dayObj.signoutImage=""
            }
            signinStateText    = dayObj.signinStateText //签到状态文字
            switch(dayObj.signinStateCode){
            case "401100": //上班未签到
                signinTime  = "无"           //上班时间
                signinImageVisible = false   //签到照片不可见
                signinState        = false   //签到状态 不正常
                break
            case "401101": //上班签到正常
                signinTime  = JSL.subStringFromTo(dayObj.signinTime,0,5)  //上班时间
                signinImageVisible = true           //签到照片可见
                signinImage = dayObj.signinImage    //签到照片
                signinState        = true           //签到状态 正常
                break
            case "401102": //上班签到迟到
                signinTime  = JSL.subStringFromTo(dayObj.signinTime,0,5)  //上班时间
                signinImageVisible = true           //签到照片可见
                signinImage = dayObj.signinImage    //签到照片
                signinState        = false          //签到状态 不正常
                break
            }

            signoutStateText    = dayObj.signoutStateText //签到状态文字
            switch(dayObj.signoutStateCode){
            case "401100": //下班未签到
                signoutTime  = "无"           //下班时间
                signoutImageVisible = false   //签退照片不可见
                signoutState        = false   //签退状态 不正常
                break
            case "401101": //下班签到正常
                signoutTime  = JSL.subStringFromTo(dayObj.signoutTime,0,5)  //下班时间
                signoutImageVisible = true           //签退照片可见
                signoutImage = dayObj.signoutImage    //签退到照片
                signoutState        = true           //签退状态 正常
                break
            case "401103": //下班签到早退
                signoutTime  = JSL.subStringFromTo(dayObj.signoutTime,0,5)  //下班时间
                signoutImageVisible = true           //签退照片可见
                signoutImage = dayObj.signoutImage    //签退照片
                signoutState        = false          //签退状态 不正常
                break
            }
        }
        else{  //无考勤记录
            noHaveAttVisible = true
        }

        //判断有无报备数据
        reportModel.clear()
        if(dayObj.workReportInfo.length > 0){//有报备
            noHaveRepVisible = false
            for(var i=0; i<dayObj.workReportInfo.length; i++){
                var ApproverOpi = dayObj.workReportInfo[i].auditOpinion
                if(ApproverOpi == null || ApproverOpi == ""){
                    ApproverOpi = "无"
                }

                reportModel.append({PreparationText:dayObj.workReportInfo[i].reportTypeName,
                                    StartTimeStr   :dayObj.workReportInfo[i].startTime,
                                    EndTimeStr     :dayObj.workReportInfo[i].endTime,
                                    TimeLong       :dayObj.workReportInfo[i].timeLong,
                                    PlaceStr       :dayObj.workReportInfo[i].destination,
                                    Reason         :dayObj.workReportInfo[i].reportedReasons,
                                    ApproverPer    :dayObj.workReportInfo[i].auditName,
                                    ApproverOpi    :ApproverOpi,
                                    Id             :dayObj.workReportInfo[i].id,
                                    ExamineApproval:dayObj.workReportInfo[i].auditType,
                                    reportJson     :JSON.stringify(dayObj.workReportInfo[i].photoPath)})
            }
        }
        else{//无报备
            noHaveRepVisible=true
        }
    }

    //显示月总统计数据
    function showPoliceStatistic(statisticsObj){
        if(statisticsObj.length == 0){//暂无统计数据
            work         =  "0"        //出勤(天)
            rest         =  "0"        //调休(天)
            attendance   =  "0"        //考勤(小时)
            jurisdiction =  "0"        //辖区(小时)
            beOut        =  "0"        //外出（小时）
            overtime     =  "0"        //加班（小时）
            askLeave     =  "0"        //请假（小时）
            late         =  "0"        //迟到（次）
            leaveEarly   =  "0"        //早退（次）
            absent       =  "0"        //旷工（次）
        }
        else{
            work         =  statisticsObj[0].cqts        //出勤(天)
            rest         =  statisticsObj[0].txts        //调休(天)
            attendance   =  statisticsObj[0].kqsc        //考勤(小时)
            jurisdiction =  statisticsObj[0].xqnsc       //辖区(小时)
            beOut        =  statisticsObj[0].wcsc        //外出（小时）
            overtime     =  statisticsObj[0].jbsc        //加班（小时）
            askLeave     =  statisticsObj[0].qjsc        //请假（小时）
            late         =  statisticsObj[0].cdcs        //迟到（次）
            leaveEarly   =  statisticsObj[0].ztcs        //早退（次）
            absent       =  statisticsObj[0].kgcs        //旷工（次）
        }
    }

    //获取月总统计数据
    function getPoliceStatistic(month){
        var datajson={
            "pd": {
                "idCard": policeIdCard,
                "uid":uid,
                "month":month//可以不传，不传默认当前月
            }
        }
        //var url ="http://172.19.12.232:8888/stat/getPoliceStatistic"
        var url="http://"+remoteIpPort+"/attendance-service/stat/getPoliceStatistic"
        console.log("获取月总统计数据URL："+url)
        console.log("获取月总统计数据入参："+JSON.stringify(datajson))
        statisticBusying.running = true

        operatehttp.post(url,function(code, data){
            console.log("获取月总统计数据回参code："+code)
            console.log("获取月总统计数据回参data："+data)
            statisticBusying.running = false
            if(code == 200|| code == 0){
                var obj = JSON.parse(data)
                //将返回数据显示到控件中
                showPoliceStatistic(obj.result.list)
            }
            else if(code == 500){
                obj = JSON.parse(data)
                messagebox.text = "获取月总统计数据出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "获取月总统计数据失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    function revoke(id,index){
        //撤消操作  请求接口  接口请求成功 界面删除该条报备
        var datajson={
            id:id
        }
        //var url="http://172.19.12.232:8888/jobpreparation/revoke"
        var url="http://"+remoteIpPort+"/attendance-service/jobpreparation/revoke"
        console.log("撤消报备操作URL："+url)
        console.log("撤消报备操作参数："+JSON.stringify(datajson))
        revokeBusying.running = true

        operatehttp.post(url,function(code, data){
            console.log("撤消报备操作回参code："+code)
            console.log("撤消报备操作回参data："+data)
            revokeBusying.running = false
            if(code == 200){
                var obj = JSON.parse(data)
                reportModel.remove(index)
                if(reportModel.count == 0){ //没有考勤记录
                    noHaveRepVisible = true
                }
                messagebox.text = "撤销报备操作成功"
                messagebox.visible = true
            }
            else if(code == 500){
                obj = JSON.parse(data)
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
