import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL

//大庆考核系统软件
MainPageForm {
    property int currentFunctionType: -1 //左侧功能类型
    property int currentDataType: -1     //当前数据类型

    property bool firstAttendanceClock:true //首次选中考勤打卡界面
    property int isAtt:0              //0为默认值未获取到标准地址，1为获取标准地址失败，2为获取标准地址成功

    Component.onCompleted: {

        orgBtn.text = operateconfigfile.getOrgName() //填充配置文件中保存的管辖区域名称

        //获取程序标题
        mainPageTitle = operateconfigfile.getShowTextMainPageTitle()//设置主页标题

        //开启GPS获取定时器
        getGpsTimer.start()

        funBtnModel.clear()
        var funList = [3,4,2]//从hlk文件中读取的功能列表，数字代表意义参照FUNCTION_TYPE结构体

        for(var i=0; i<funList.length; i++){
            switch(funList[i]){
            case QmlData.FUNCTION_TYPE_INFORMATION_ACQUISITION://信息采集
                funBtnModel.append({BTN_ID:QmlData.FUNCTION_TYPE_INFORMATION_ACQUISITION,
                                       BTN_TEXT:"入户核查",
                                       BTN_IMG_NORMAL:"qrc:/images/images/home_rhhc_1.png",
                                       BTN_IMG_CHECKED:"qrc:/images/images/home_rhhc_2.png"})
                break
            case QmlData.FUNCTION_TYPE_ATTENDANCE_CLOCK://考勤打卡
                builDocumentKaoqin()
                funBtnModel.append({BTN_ID:QmlData.FUNCTION_TYPE_ATTENDANCE_CLOCK,
                                       BTN_TEXT:"考勤打卡",
                                       BTN_IMG_NORMAL:"qrc:/images/images/home_kq_1.png",
                                       BTN_IMG_CHECKED:"qrc:/images/images/home_kq.png"})
                break
            case QmlData.FUNCTION_TYPE_SYSTEMSET:
                funBtnModel.append({BTN_ID:QmlData.FUNCTION_TYPE_SYSTEMSET,
                                       BTN_TEXT:"系统设置",
                                       BTN_IMG_NORMAL:"qrc:/images/images/home_xtsz_1.png",
                                       BTN_IMG_CHECKED:"qrc:/images/images/home_xtsz_2.png"})
                break
            case QmlData.FUNCTION_TYPE_POINTCARD:
                funBtnModel.append({BTN_ID:QmlData.FUNCTION_TYPE_POINTCARD,
                                       BTN_TEXT:"巡逻盘查",
                                       BTN_IMG_NORMAL:"qrc:/images/images/home_xlpc_1.png",
                                       BTN_IMG_CHECKED:"qrc:/images/images/home_xlpc_2.png"})
                break
            }
        }

        //初始化默认选中功能按钮
        funBtnModel.setProperty(0, "BTN_CHECKED", true)
        //初始化默认显示功能区域
        showFun(funBtnModel.get(0).BTN_ID)
    }

    onCurrentFunctionTypeChanged: {
        switch(currentFunctionType){
        case QmlData.FUNCTION_TYPE_ATTENDANCE_CLOCK: //考勤打卡

            if(firstAttendanceClock){
                //获取考勤统计数量
                getDataCountAttendance()
                //获取工作时间
                getWorkTimer.start()

                firstAttendanceClock = !firstAttendanceClock
            }

            break
        case QmlData.FUNCTION_TYPE_SYSTEMSET://系统设置

            break
        case QmlData.FUNCTION_TYPE_INFORMATION_ACQUISITION://信息采集
            getDataCount(QmlData.INTO_TYPE_THREEREAL_ROOM)
            getDataCount(QmlData.INTO_TYPE_THREEREAL_UNIT)
            getDataCount(QmlData.INTO_TYPE_THREEREAL_PERSION)
            break
        case QmlData.FUNCTION_TYPE_POINTCARD://维稳盘查
            getDataCount(QmlData.INTO_TYPE_POINTCARD_PERSION)
            getDataCount(QmlData.INTO_TYPE_POINTCARD_CAR)
            break
        }
    }

    //控制功能显示隐藏
    function ctrlFunctionVisible(){
        switch(currentFunctionType){
        case QmlData.FUNCTION_TYPE_ATTENDANCE_CLOCK: //考勤打卡
            attendanceClockArea.visible = true
            systemSetArea.visible = false
            infoCollectArea.visible = false
            pointcardArea.visible = false
            break
        case QmlData.FUNCTION_TYPE_SYSTEMSET://系统设置
            systemSetArea.visible = true
            attendanceClockArea.visible = false
            infoCollectArea.visible = false
            pointcardArea.visible = false
            break
        case QmlData.FUNCTION_TYPE_INFORMATION_ACQUISITION://信息采集
            infoCollectArea.visible = true
            systemSetArea.visible = false
            attendanceClockArea.visible = false
            pointcardArea.visible = false
             break
        case QmlData.FUNCTION_TYPE_POINTCARD://维稳盘查
            pointcardArea.visible = true
            infoCollectArea.visible = false
            systemSetArea.visible = false
            attendanceClockArea.visible = false

            break
        }
    }

    function showNocantJumpReason(){
        messagebox.text = "暂无数据"
        messagebox.visible = true
    }

    //操作区域按钮点击事件
    //本周考勤工时
    attendanceClockDigitBtn.onClicked: {
        stackView.push("qrc:/wholeFunction/ui/AttendanceClockDigitPage.qml")
    }   
    //考勤打卡
    attendanceClockBtn.onClicked: {
        stackView.push({item:"qrc:/wholeFunction/ui/AttendanceClockPage.qml",
                  properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE}})    //编辑模式--即打卡模式

    }
    //本周工作报备次数
    workReportedDigitBtn.onClicked: {
        stackView.push({item:"qrc:/wholeFunction/ui/WorkReportedDigitPage.qml",
                  properties:{entryPageMode:QmlData.VISIT_TYPE_SEE}})
    }
    //工作报备
    workReportedBtn.onClicked: {
        stackView.push({item:"qrc:/wholeFunction/ui/WorkReportedPage.qml",
                  properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE}})
    }
    //本周日志
    workDiaryDigitBtn.onClicked: {
        stackView.push({item:"qrc:/wholeFunction/ui/WorkLogDigitPage.qml",
                  properties:{entryPageMode:QmlData.VISIT_TYPE_SEE}})
    }
    //工作日志
    workDiaryBtn.onClicked: {
        stackView.push({item:"qrc:/wholeFunction/ui/WorkLogPage.qml",
                  properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE}})
    }
    //系统设置--软件升级
    versionUpdateBtn.onClicked: {
        stackView.push("qrc:/systemSettings/ui/VersionUpdatePage.qml")
    }
    //系统设置--软件设置
    informationSettingsBtn.onClicked: {
        stackView.push("qrc:/systemSettings/ui/SystemSetEntry.qml")
    }
    // 实有房屋-统计
    historicHouseDigitBtn.onClicked: {
        stackView.push({     item:"qrc:/wholeFunction/uiCommunity/InfomationDetailsPage.qml",
                       properties:{nPageSerialNumber: QmlData.INTO_TYPE_THREEREAL_ROOM,titleText:"历史房屋"}})
    }
    //实有单位-统计
    historicUnitDigitBtn.onClicked: {
        stackView.push({     item:"qrc:/wholeFunction/uiCommunity/InfomationDetailsPage.qml",
                       properties:{nPageSerialNumber: QmlData.INTO_TYPE_THREEREAL_UNIT,titleText:"历史单位"}})
    }
    //实有人员-统计
    historicPersonDigitBtn.onClicked: {
    stackView.push({     item:"qrc:/wholeFunction/uiCommunity/InfomationDetailsPage.qml",
                   properties:{nPageSerialNumber: QmlData.INTO_TYPE_THREEREAL_PERSION,titleText:"历史人员"}})
    }
    //统计数据-统计
    historicDataDigitBtn.onClicked: {
        //暂时只展示数量 不做跳转界面
        //stackView.push({     item:"qrc:/wholeFunction/uiCommunity/InfomationDetailsPage.qml",
        //               properties:{nPageSerialNumber: QmlData.INTO_TYPE_THREEREAL_PERSION,titleText:"历史数据"}})
    }

    // 实有房屋
    historicHouseDigitBtnBtn.onClicked: {
        if(isAtt==0){
            messagebox.text = "正在获取标准地址信息，请稍候"
            messagebox.visible = true
        }else if(isAtt==1){
            popWindow.visible=true
            mainPage.enabled = false
        }else{
            builDocument()
            stackView.push({item:"qrc:/wholeFunction/uiCommunity/ThreeRealRoomPage.qml", properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                           colloctType:QmlData.INTO_TYPE_THREEREAL_ROOM}})
        }
    }

    //实有单位
    historicUnitBtn.onClicked: {
        if(isAtt==0){
            messagebox.text = "正在获取标准地址信息，请稍候"
            messagebox.visible = true
        }else if(isAtt==1){
            popWindow.visible=true
            mainPage.enabled = false
        }else{
            builDocument()
            stackView.push({item:"qrc:/wholeFunction/uiCommunity/ThreeRealUnitPage.qml", properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                           colloctType:QmlData.INTO_TYPE_THREEREAL_UNIT}})
        }
    }

    //实有人员
    historicPersonBtn.onClicked: {
        if(isAtt==0){
            messagebox.text = "正在获取标准地址信息，请稍候"
            messagebox.visible = true
        }else if(isAtt==1){
            popWindow.visible=true
            mainPage.enabled = false
            //popWindow弹框提示是否重新获取标准地址
            //新写一个获取标准地址函数
        }else{
            builDocument()
            stackView.push({item:"qrc:/wholeFunction/uiCommunity/ThreeRealPersonPage.qml", properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                               colloctType:QmlData.INTO_TYPE_THREEREAL_PERSION}})
        }
    }
    //从业人员
    employeeBtn.onClicked: {
        stackView.push("qrc:/wholeFunction/uiCommunity/EmployeePage.qml")
    }



    //统计数据
    historicDataBtn.onClicked: {
        //stackView.push("qrc:/wholeFunction/uiCommunity/StatisticalDataPage.qml")

//        var tokens = token
//        if(tokens=='')tokens='123'

//        var url = "http://"
//        +operateconfigfile.getRemoteIP()
//        +":"
//        +operateconfigfile.getRemotePort()
//        +"/zxhc/?sfzh="
//        +idcard
//        +"&name="
//        +name
//        +"&jysfzh="
//        +policeIdCard
//        +"&jyxm="
//        +policeName
//        +"&jybmbh="
//        +policeUnitCode
//        +"&target="
//        +"person"
//        +"&token="
//        +tokens

        var url = "http://"
        +operateconfigfile.getRemoteIP()
        +":"
        +operateconfigfile.getRemotePort()
        +"/sqjw/"

        console.log("统计汇总url:"+url)

        stackView.push({item: "qrc:/controls/ui/HLK_ShowHtml.qml",properties:{pageTitle: "统计汇总", checkURL: url}})
    }

    personInquirieskdDigitBtn.onClicked: {
        stackView.push({item: "qrc:/wholeFunction/uiCommunity/InfomationDetailsPage.qml",
                                 properties:{nPageSerialNumber: QmlData.INTO_TYPE_POINTCARD_PERSION, nPageNumberType: currentFunctionType,titleText:"人员历史盘查"}})


    }

    personInquirieskdBtn.onClicked: {
           builDocument()
           stackView.push({item:"qrc:/wholeFunction/ui/PointCheckingPersonPage.qml", properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                                   colloctType:QmlData.INTO_TYPE_POINTCARD_PERSION}})


    }

    carInquirieskdDigitBtn.onClicked: {
                           stackView.push({item: "qrc:/wholeFunction/uiCommunity/InfomationDetailsPage.qml",
                                                     properties:{nPageSerialNumber: QmlData.INTO_TYPE_POINTCARD_CAR, nPageNumberType: currentFunctionType,titleText:"车辆历史盘查"}})
    }

    carInquirieskdBtn.onClicked: {
            builDocument()
            stackView.push({item:"qrc:/wholeFunction/ui/PointCheckingCarPage.qml", properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                                   colloctType:QmlData.INTO_TYPE_POINTCARD_CAR}})

    }


    //退出按钮点击事件
    exitBtn.onClicked: {
        popWindowExit.visible = true
        mainPage.enabled = false
    }

    isExitBtn.onClicked: {
        monitorProcess.stopProcessIdentification()
        Qt.quit()
    }

    noExitBtn.onClicked: {
        popWindowExit.visible = false
        mainPage.enabled = true
    }

    //切换用户按钮点击事件
    changeUserBtn.onClicked: {
        popWindowChangeUser.visible = true
        mainPage.enabled = false
    }

    isChangeUser.onClicked: {
        stackView.pop()
    }

    noChangeUser.onClicked: {
        popWindowChangeUser.visible = false
        mainPage.enabled = true
    }

    Connections{
        target: mainQml
        onFinishTask:{//由其他界面返回到次界面 重新查询统计信息
            dataCountChanged()
        }
    }

    onFunBtnClicked:{
        showFun(funBtnID)
    }

    //显示功能
    function showFun(funID){
        currentFunctionType = funID
        ctrlFunctionVisible()
    }

    Timer{
        id: getGpsTimer
        interval: 30000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            //实时显示GPS信息
            var url = 'http://'+operateconfigfile.getGPSIP()+':'+operateconfigfile.getGPSPort();
            operatehttp.get(url, function(code, data){
                if(code == 200){
                    //isShowLongitudeAndLatitude = true
                    var obj = JSON.parse(data)
                    if(obj.isPosSuccess==1)//数据有效
                    {
                        getGpsTimer.interval = 60000;
                        longitude = obj.longitude;
                        latitude = obj.latitude;
                    }
                }
                else{
                    //isShowLongitudeAndLatitude = false
                }
            })
        }
    }
    Timer{
        id: getWorkTimer //获取工作时间
        interval: 60000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            //获取工作时间 获取到正确的关闭定时器
            getWorkTime()
        }
    }
    //获取工作时间
    function getWorkTime(){
        var datajson={
            //"idCard":policeIdCard
        }
        //var url="http://172.19.12.232:8888/ate/getAttendanceRule"
        var url="http://"+remoteIpPort+"/attendance-service/ate/getAttendanceRule"
        console.log("获取工作时间URL："+url)
        console.log("获取工作时间入参："+JSON.stringify(datajson))
        //busying.running = true
        operatehttp.post(url,function(code, data){
            console.log("获取工作时间回参code："+code)
            console.log("获取工作时间回参data："+data)
            //busying.running=false
            if(code==200||code==0){
                getWorkTimer.stop()
                var obj = JSON.parse(data)
                overStart=obj.result.onDutyTime
                overEnd= obj.result.offDutyTime
            }
            else if(code == 500){
                obj = JSON.parse(data)
                messagebox.text = "获取工作时间出错，错误原因:"+obj.reason
                messagebox.visible = true
            }
            else{
                messagebox.text = "获取工作时间失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //获取统计信息
    function getDataCountAttendance(){
        var datajson={
            "idCard": policeIdCard,
            "uid":uid
        }
        //var url="http://172.19.12.232:8888"+"/stat/getHomeStatistic"
        var url ="http://"+goIpPort+"/attendance-service/stat/getHomeStatistic"
        console.log("获取统计信息URL："+url)
        console.log("获取统计信息入参："+JSON.stringify(datajson))

        busying.running = true

        operatehttp.post(url,function(code, data){
            console.log("获取统计信息回参code："+code)
            console.log("获取统计信息回参data："+data)
            busying.running = false
            if(code == 200 || code == 0){
                var obj = JSON.parse(data)
                attendanceClockDigitBtn.maxText = obj.result.inAreaTime
                workReportedDigitBtn.maxText = obj.result.reportCount
                workDiaryDigitBtn.maxText = obj.result.logCount
            }
            else if(code == 500){
                obj = JSON.parse(data)
                console.log("获取统计信息接口发生错误，错误码:"+code+"错误原因:"+obj.reason)
                messagebox.text = "获取统计信息出错，错误原因:"+obj.reason.text
                messagebox.visible = true
                firstAttendanceClock = !firstAttendanceClock
            }
            else{
                console.log("获取统计信息接口发生错误，错误码:"+code)
                messagebox.text = "获取统计信息失败，请检查网络，错误码:"+code
                messagebox.visible = true
                firstAttendanceClock = !firstAttendanceClock
            }

        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    function getIndexByName(model, code){
        for(var i=0; i<model.count; i++){
            if(model.get(i).orgcode === code){
                return i
            }
        }
        return -1
    }

    //管辖区域发生变化时 去请求地址信息 不变化不请求
    orgBtn.onTextChanged: {
       getAddr()
    }
    //获取标准地址函数 //url需要重新修改，此处从go服务获取
    function getAddr() {
        var url ="http://"+goIpPort+"/sy/jurisdictionArea/"+operateconfigfile.getOrgCode()
        //var url ="http://"+"172.19.12.180:8091"+"/sy/jurisdictionArea/210102350001"
        console.log("获取地址信息URL："+url)
        busyingAddr.running = true
        isAtt=0

        var addrlist = []
        var ishaved=false

        operatehttp.get(url,function(code, data){
            console.log("获取地址信息回参code："+code)
            console.log("获取地址信息回参data："+data)

            busyingAddr.running = false
            if(code == 200 || code == 0){
                 isAtt=2
                 var obj = JSON.parse(data)

            }
            else if(code == 500){
                isAtt=1
                obj = JSON.parse(data)
                //console.log("获取地址信息接口发生错误，错误码:"+code+"错误原因:"+obj.reason)
                //messagebox.text = "获取地址信息出错，错误原因:"+obj.reason.text
                messagebox.text = "获取地址信息出错"
                messagebox.visible = true

            }
            else{
                isAtt=1
                console.log("获取地址信息接口发生错误，错误码:"+code)
                messagebox.text = "获取地址信息失败，请检查网络，错误码:"+code
                messagebox.visible = true

            }

        })
    }
    //数据数量改变
    function dataCountChanged(){
        switch(currentFunctionType){
        case QmlData.FUNCTION_TYPE_AQT://大庆考勤
            getDataCountAttendance ()
            break
        case QmlData.FUNCTION_TYPE_INFORMATION_ACQUISITION://三实
            getDataCount(QmlData.INTO_TYPE_THREEREAL_ROOM)
            getDataCount(QmlData.INTO_TYPE_THREEREAL_UNIT)
            getDataCount(QmlData.INTO_TYPE_THREEREAL_PERSION)
            break
        case QmlData.FUNCTION_TYPE_POINTCARD://维稳
            getDataCount(QmlData.INTO_TYPE_POINTCARD_PERSION)
            getDataCount(QmlData.INTO_TYPE_POINTCARD_CAR)
            break
        case QmlData.FUNCTION_TYPE_SYSTEMSET://系统设置
            break
        }
    }
    //从go服务端获取本地数据项数量
   function getDataCount(type){
       var url ="http://"+goIpPort+"/countLY/"+policeIdCard+"/"+type+"/"+""+"/1"
       console.log("从go服务端获取今天的所有数量"+url)
       operatehttp.get(url,function(code, data){
           console.log("取本地数据项数量code:"+code)
           console.log("取本地数据项数量data:"+data)
           var obj = JSON.parse(data)
           if(code == 200){
               switch(type){
               case QmlData.INTO_TYPE_THREEREAL_UNIT://三实 - 实有单位
                   historicUnitDigitBtn.maxText = obj.Cunt
                   break
               case QmlData.INTO_TYPE_THREEREAL_ROOM://三实 - 实有房屋
                   historicHouseDigitBtn.maxText = obj.Cunt
                   break
               case QmlData.INTO_TYPE_THREEREAL_PERSION: //三实 - 实有人员
                   historicPersonDigitBtn.maxText = obj.Cunt
                   break
               case QmlData.INTO_TYPE_POINTCARD_PERSION://维稳盘查人
                   personInquirieskdDigitBtn.maxText = obj.Cunt
                   break
               case QmlData.INTO_TYPE_POINTCARD_CAR://维稳盘查车
                  carInquirieskdDigitBtn.maxText = obj.Cunt
                   break
               }
           }
        })
   }
}
