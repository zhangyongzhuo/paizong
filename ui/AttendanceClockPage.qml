import QtQuick 2.5
import QtMultimedia 5.5
import QtQml.Models 2.1
import QtQuick.Controls 1.2
import com.hylink.fmcp.ctrl 2.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL

AttendanceClockPageForm {
    property Camera camera: null
    property int entryPageMode:0

    property var attendanceClockObj:{//服务器返回的考勤信息对象
        "attType": "",
        "workHours": 0,
        "officeHours": "",
        "systemTime": "",
        "signinStateText": "",
        "signoutStateText": "",
        "signoutStateCode": "",
        "gunder": "",
        "offHours": "",
        "clockRange": [],
        "signinStateCode": "",
    }
    property var clockRange:[]  //服务器返回的辖区范围
    property string attType: "" //打卡类型 初始为"" 服务器返回值

    property string myDate:""

    property int myHours: 0
    property int myMinutes: 0
    property int mySeconds: 0

    property string strHours:   "0"
    property string strMinutes: "0"
    property string strSeconds: "0"

    property bool   isAtt: false


    Component.onCompleted: {
        finish.visible = false
        //获取统计数据
//            getDataCount()

        //查询考勤打卡基础信息
        attendanceClock("")

        cameraLoader.initCamera = operateconfigfile.getCameraInitNum()
    }

    cameraLoader.onItemLoaded: {
        camera = cam
        camera.deviceId = QtMultimedia.availableCameras[cameraLoader.initCamera].deviceId
    }

    back.onClicked: {
        if(isAtt){
            messagebox.text = "正在上传打卡信息，请稍候"
            messagebox.visible = true
        }
    }

    Connections{
        target: camera.imageCapture
        //拍照信息处理
        onImageSaved: {
            attendanceClock(qmlData.transformImage2Base64(path), true)
        }
    }

    //打卡按钮
    clockBtn.onClicked: {

        if(clockRange == 1 ){
            //检查今日目录是否已经创建了
            builDocumentKaoqin()
            camera.imageCapture.captureToLocation(documentDir)
            return
        }
        else if(clockRange == 0){
            messagebox.text = "正在定位，请稍候打卡"
            messagebox.visible = true
            return
        }
        else if(clockRange == -1 ){
            windowTitle="未在辖区范围内，请填写工作报备！"
            popWindow.visible = true
            return
        }
        else if(clockRange == -2 ){
            windowTitle="未获取到考勤范围：请填写工作报备！"
            popWindow.visible = true
            return
        }
    }

    //确定更新打卡按钮
    isUpdataBtn.onClicked: {
        //打卡按钮显示
        clockBtn.visible = true
        //更新打卡按钮隐藏
        signoutStateVisible = false
    }

    isReportedBtn.onClicked: {
        //关定时器
        camera.stop()
        myDateTimer.running = false
        clockRangeTimer.running = false
        stackView.push({item:"qrc:/wholeFunction/ui/WorkReportedPage.qml",
                  properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,    //编辑模式
                              entryMode:1}})
    }

    //时间自动增长
    Timer{
        id:myDateTimer
        interval: 1000;
        repeat: true;
        onTriggered: {
            mySeconds++
            if(mySeconds >= 60){
                mySeconds = 0
                myMinutes++
            }
            if(myMinutes >= 60){
                myMinutes = 0
                myHours++
            }
            if(myHours >= 24){
                myHours = 0
            }

            strHours = myHours<10 ? "0"+myHours : myHours
            strMinutes = myMinutes<10 ? "0"+myMinutes : myMinutes
            strSeconds = mySeconds<10 ? "0"+mySeconds : mySeconds

            clockTime = strHours+":"+strMinutes+":"+strSeconds
        }
    }

    //获取是否在辖区范围内
    Timer{
        id:clockRangeTimer
        interval: 15000;
        repeat: true;
        onTriggered: {
            clockRangeTimerOut()
        }
    }

    //计算是否在辖区范围内
    function clockRangeTimerOut(){
        clockRange = isPointInClockRange(attendanceClockObj.clockRange)

        if(clockRange == 1){
            clockRangeText = "已进入辖区考勤范围"
            clockRangeIcon = "qrc:/images/images/fwn.png"
        }
        else if(clockRange == -1){
            clockRangeText = "未在辖区考勤范围内：请填写工作报备"
            clockRangeIcon = "qrc:/images/images/fww.png"
        }
        else if(clockRange == -2){
            clockRangeText = "请检查是否在后台设置了考勤范围"
            clockRangeIcon = "qrc:/images/images/fww.png"
        }
    }

    //显示打卡信息
    function showAttendanceClock(){

        signinTime  = attendanceClockObj.officeHours         //上班时间
        signoutTime = attendanceClockObj.offHours            //下班时间
        var timeObj = JSL.getSystemTime(attendanceClockObj.systemTime)
        //显示照片水印
        pictureTime = timeObj.dateString
        myHours     = timeObj.hours
        myMinutes   = timeObj.minutes
        mySeconds   = timeObj.seconds
        //启动定时器显示系统时间
        myDateTimer.running = true

        if(attendanceClockObj.signinStateCode == '401100'){//上班未签到
             signinIcon = "qrc:/images/images/1.png"
        }
        else{
            clockText = "拍照签退"
            signinTime = attendanceClockObj.signinTime     //上班打卡时间
            signinStateVisible = true                      //签到状态显示
            signinStateText = attendanceClockObj.signinStateText//签到状态文字 正常 迟到 早退 缺卡
            if(attendanceClockObj.signinStateCode == '401101'){ //上班正常
                signinIcon = "qrc:/images/images/zc.png"   //签到图标
                signinState = true                         //签到状态
            }
            else{                                               //上班异常
                signinIcon = "qrc:/images/images/qk.png"   //签到图标
                signinState = false                        //签到状态
            }
        }

        if(attendanceClockObj.signoutStateCode == '401100'){//下班未签到
             signoutIcon = "qrc:/images/images/1.png"
        }
        else{
            signoutTime = attendanceClockObj.signoutTime   //下班打卡时间
            signoutStateVisible = true                     //签到状态显示
            signoutStateText = attendanceClockObj.signoutStateText//签到状态文字 正常 迟到 早退 缺卡

            //签到按钮不可用并且显示工时
            clockBtn.visible = false
            workHoursVisible=true
            workHours = attendanceClockObj.workHours

            if(attendanceClockObj.signoutStateCode == '401101'){   //下班正常
                signoutIcon = "qrc:/images/images/zc.png"   //签到图标
                signoutState = true                          //签到状态
            }
            else{                                           //下班异常
                signoutIcon = "qrc:/images/images/qk.png"   //签到图标
                signoutState = false                        //签到状态
            }
        }
    }

    //获取打卡信息
    function attendanceClock(image){
        var datajson={
            "idCard": policeIdCard,
            "gunder": policeUnitCode,
            "uid":uid,
            "longitude":longitude,
            "latitude":latitude,
            "image":image,
            "attType":attType
        }

        //var url ="http://172.19.12.232:8888/ate/beginAttendance"
        var url="http://"+remoteIpPort+"/attendance-service/ate/beginAttendance"
        console.log("获取考勤信息URL："+url)
        console.log("获取考勤信息参数："+JSON.stringify(datajson))
        isAtt = true
        busying.running = true

        operatehttp.post(url,function(code, data){
            console.log("获取考勤信息code："+code)
            console.log("获取考勤信息data："+data)
            isAtt = false
            busying.running = false

            if(code == 200|| code == 0){
                var obj = JSON.parse(data)
                attendanceClockObj = obj.result
                //记录服务器返回的考勤类型
                attType = attendanceClockObj.attType
                //启动定时器 判断当前是否在辖区内
                clockRangeTimerOut()
                clockRangeTimer.running = true
                //显示考勤基础信息
                showAttendanceClock()
            }
            else if(code == 500){
                obj = JSON.parse(data)
                console.log("获取考勤信息接口发生错误，错误码:"+code)
                messagebox.text = "获取考勤信息出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                console.log("获取考勤信息接口发生错误，错误码:"+code)
                messagebox.text = "获取考勤信息失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }

        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())

    }

}
