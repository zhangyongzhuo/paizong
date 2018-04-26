import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQml.Models 2.2
import com.hylink.fmcp.ctrl 2.0
import QtWebEngine 1.2

//import "qrc:/wholeFunction/ui"
//import "qrc:/singleFunction/ui"
import "qrc:/systemSettings/ui"
import "qrc:/base/js/common.js" as JSL
//import "qrc:/collectJson/js/ThreeRealUnit.js"  as ThreeRealUnit
import "qrc:/collectJson/js/ThreeRealPerson.js"  as ThreeRealPerson
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.5
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"

ApplicationWindow {
    id: mainQml
    width: 1280
    height: 768
    flags: Qt.Window | Qt.FramelessWindowHint
    visible: true

    property bool isX6:false
    property int realHeight: 0
    signal finishRoomTask(string id)                 //房屋调用页面点击完成按钮，返回给基础页面


    signal fillInfoMsg(string wholeFunctionName)  //信息填充消息(参数 当前为哪个瀑布流发送的该消息)
    signal initInfoMsg(var initInfo, string casecadeName)//初始化信息
    signal initCamChanged( int initCamera)
    signal multiPhotosShotFinished(var result, string receivePageName) //拍照界面拍照结束信号
    signal finishTask()                 //调用页面点击完成按钮，返回给基础页面
    signal finishToEveryControl()                 //调用页面点击完成按钮，返回给基础页面
    signal addBtnClicked(string pageName)//添加按钮被点击 参数为哪个页面点击了这个按钮

    //数字键盘文本改变
    signal digiTextChange(string text)
    signal digiPressChanged(string text)
    //数字键盘文本删除
    signal digiTextDel()

    signal boxAreaOpend(string page_name) //其他模块获取到了焦点
    signal componentRecovery()            //点空白区域被点击
    signal logSaveOk()//编辑日志保存成后发出该信号
    property string documentID:  ""     //档案ID
    property string documentDir: ""     //档案路径

    property string userName:   ""      //登录用户名 身份证号/警号
    property string policeName:   ""    //警员姓名
    property string policeIdCard: ""    //警员身份证号
    property string policeCode:  ""     //警员编号
    property string policeUnitCode: "210100"  //机构编码
    property string policeUnit: ""      //机构编码名称
    property string policePhoto:  ""    //警员头像
    property string loginpassword:""    //登錄密碼
    property string policeArea:   ""    //行政区划
    property string policeAreaCode: ""  //行政区划编码

    property string token: ""            //获取验证登录警员是否合法任务回复的密令
    property string goIpPort: ""         //读go服务IP端口
    property string remoteIpPort: ""     //读后台服务IP端口
    property string uid: ""              //设备唯一码
    property string imei: ""             //设备SIM卡号
    property double latitude:0           //纬度
    property double longitude:0          //经度

    property bool proxyEnable: false     //代理是否可用

    property bool isShowLongitudeAndLatitude: true //是否显示经纬度
    property string approverIdcard: ""     //保存到配置文件中的审批人身份证号
    property string approverLeader: ""     //审批人姓名
    property string overStart:""     //加班返回的开始时间
    property string overEnd:""    //加班返回的结束时间
    property int taskDiff:0         //PublicTaskPage  任务点击查看更多的第几项
    signal deleteTask()                 //历史盘查界面删除时

    property alias digiBoard: digiBoard
    property alias doubleMax:doubleMax
    property alias getFocus:getFocus
    property alias datePage:datePage

    property var orgList:[]  //管辖区域列表
    property string orgName: ""    //管辖区域名称
    property string orgCode: ""    //管辖区域编码
    property string stayType: ""    //实有人口业务类型

    property string undocumentUrl:""          //人像识别URL
    property string locationName: ""    //卡口地点
    property string locationId: ""    //卡口id
    property string dataCallName: ""    //调用时间控件的控件
    property string nextYear:  ""  //
    property string nextMonth:  ""  //
    property string nextDay:  ""  //

    property bool isOwner:  false  //是否是房主本人
    //property var echoObject:ThreeRealUnit.getEcho()
    property var xpObject:ThreeRealPerson.getXp()

    //人
    signal showPersonOnlineBtnOther() //显示在线核查按钮
    signal showPersonOnlineBtn(string name) //显示在线核查按钮
    signal getInfoAndTag(var jsonData,string jsonType,string card)
    signal queryConditionFillFinished(var queryCondition, string casecadeName,int idcardMode)//查询条件填充完成（身份证界面为身份证号，车辆界面为车牌号，房屋界面为地址）
    signal showQueryResult(var queryResult, string casecadeName, bool isClearRet)//显示查询结果
    signal idcardDentificationFinish(var cardInfo)              //身份证识别完成
    signal sendCheckSig(string IDCard, string Name) //发送核查信号(可能为在线核查也可能为离线核查)
    signal sendPageUabled(bool status) //发送给页面告知该页面是否可用信号
    signal sendUnitName(bool status,string name) //添加单位别名时确定和取消发送的信号
    signal otherPlus() //添加单位别名时确定和取消发送给poptext的信号告知其清空输入框
    signal addressTogether(string name) //户籍地址和户籍地址描述保持一致

    signal faceRecognitionOperation()
    signal backtocar(string text, string pageName)
    signal checkException(string pagename, bool exception)
    signal currentTaskFinish(var page_name)          //当前任务完成
    //返回时做判断相关信号
    signal sendtocar(string pageName)
    signal idcardInfoCheckResult(var result)//身份证信息核查结果
    //无证无号完成时
    signal undocumentFinish(string name,string card,string photo)
    //清空写实和基础信息数据
    signal clearAllData(string pagename)


    signal carInfoOnlineCheck(string plateNO, string plateType)//车辆信息在线核查
    signal markLoadFinish(string text)//标签加载完发送信号给瀑布流
    signal mainMessageBox(var page_name, var msg)               //消息框
    signal carInfoAssignment(var carInfo, string type)
    signal showCarOnlineBtn(string name) //显示在线核查按钮
    signal carInfoCheckResult(var result) //车辆信息核查结果
    signal plateNumberDentificationFinish(string plateNumber)   //车牌号识别完成
    signal plateNumberTextDel()                         //车牌键盘文本删除
    signal plateNumberTextChange(string text)           //车牌键盘文本改变
    signal carBaseInfoCheckFinish(var carInfo)
    signal palteNumberClose()                           //车牌键盘关闭
    signal sendBackLoadData(string backData,string receivePageName)//山东进入瀑布流带会员有采集数据
    signal sendToCallPage(string dataStr,string name)   //时间控件选择ok后发送回各个控件的
    signal owerRelationChanged()//与房主关系改变发送信号
    signal backOwerRelationChanged(string dataStr,string controlName)//房主模块返回
    signal unitEnable(bool  status)//发送到实有单位控制该界面是否可用
    //signal backOwerRelationSingnalChanged(string dataStr,string controlName)//房主模块返回


    function builDocumentKaoqin(){ //考勤系统使用以天为单位
        var currentDate = new Date()
        var yearCurrent = currentDate.getFullYear()
        var monthCurrent = currentDate.getMonth()+1
        var dayCurrent = currentDate.getDate()
        if(dayCurrent<10){
           documentID=JSL.getDate(yearCurrent + '-' + monthCurrent +'-'+'0'+dayCurrent)
        }else{
           documentID=JSL.getDate(yearCurrent + '-' + monthCurrent +'-'+dayCurrent)
        }
        documentDir = qmlData.makeOptargetIdDir(documentID)
        console.log("----documentID:"+documentID)
    }

    function builDocument(){ //创建档案编号及对应文件夹 社区警务及维稳核查使用 以当前时间为单位
        documentID = qmlData.makeOptargetId()
        documentDir = qmlData.makeOptargetIdDir(documentID)
    }

    QmlData{
        id:qmlData
    }

    OperateHttp{
        id:operatehttp
    }

    OperateConfigFile{
        id:operateconfigfile
    }
    ReadIdcard{
        id:readIdcard
    }
    OcrIdcardOrBlurDetect{
        id:ocrdectect
    }
    CompareOrDetectFace{
        id:compareface
    }

    MonitorProcess{
        id:monitorProcess
    }

    StackView{
        id: stackView
        anchors.fill: parent
        Component.onCompleted: {

            showNormal()
            //stackView.push("qrc:/base/ui/LoginPage.qml")
            //stackView.push('qrc:/base/ui/MainPage.qml')
            //stackView.push('qrc:/wholeFunction/uiCommunity/ThreeRealRoomPage.qml')
            stackView.push('qrc:/wholeFunction/uiCommunity/EmployeePage.qml')

            monitorProcess.getProcessStatus("VkeyBoard.exe")
        }

        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }

    onInitCamChanged:{
        console.log("onInitCamChanged:"+operateconfigfile.setCameraInitNum(initCamera))

    }

    //数字键盘
    HLK_DigitalKeyboard{
        id: digiBoard
        visible: false
        x: 1280 - digiBoard.width
        y: 768 - digiBoard.height - 40
    }

    //双击放大
    HLK_DoubleMax{
        id: doubleMax
        imgPath: ""
        maxVisble: false
        bgVisble: false
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 38
        anchors.horizontalCenter: parent.horizontalCenter
    }

    //获取焦点
    HLK_TextEdit {
        id: getFocus
        visible: false
    }

    HLK_PopupText{
        id: popText
        visible: false
        anchors.fill: parent
        Row {
            spacing: 50
            anchors.horizontalCenter: parent.horizontalCenter
            y:420
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 20
            HLK_Button {
                width: 130
                button_text: "确定"
                onClicked: {
                    emit:sendUnitName(true,popText.popupWindowTitle)
                }
            }
            HLK_Button {
                width: 130
                button_text: "取消"
                onClicked: {
                    emit:sendUnitName(false,"")
                    popText.popupWindowTitle=""
                }
            }
        }
    }

    //日期控件
    HLK_DatePage {
           id: datePage
           anchors.fill: parent
           visible:false
           //month:month+1
           onReturnPage:{
               if(ok){
                   var str
                   if(day<10){
                        if(month<10){
                            str=year+"-"+0+month+"-"+0+day
                        }else{
                            str=year+"-"+month+"-"+0+day
                        }
                   }else{
                        if(month<10){
                            str=year+"-"+0+month+"-"+day
                        }else{
                            str=year+"-"+month+"-"+day
                        }
                   }
                   switch(dataCallName){
                         case "stayDate"://信息采集
                           emit:sendToCallPage(str,"stayDate")
                           break
                         case "signTime"://责任书签订时间
                           emit:sendToCallPage(str,"signTime")
                           break
                         case "liveStartRentDate"://起租日期
                           emit:sendToCallPage(str,"liveStartRentDate")
                             break
                         case "liveOffHireDate"://拟停租日期
                           emit:sendToCallPage(str,"liveOffHireDate")
                             break
                         case "birth"://生日
                           emit:sendToCallPage(str,"birth")
                             break
                         case "rent"://出租日期
                           emit:sendToCallPage(str,"rent")
                             break
                         case "startRentDate"://起租日期
                           emit:sendToCallPage(str,"startRentDate")
                             break
                         case "offHireDate"://拟停租日期
                           emit:sendToCallPage(str,"offHireDate")
                             break
                         case "liveAwayTime"://寄住开始时间
                           emit:sendToCallPage(str,"liveAwayTime")
                             break
                         case "leaveTime"://预计离开时间
                           emit:sendToCallPage(str,"leaveTime")
                             break
                   }
                   datePage.visible=false
                   getFocus.focus = true
                   nextYear=year
                   nextMonth=month
                   nextDay=day
               }else{
                   datePage.visible=false
                   getFocus.focus = true
               }
           }
       }

    Connections{//
        target: monitorProcess
        onMonitorProcessfinished: {
            if(status==1){
                getFocus.focus = true
            }
        }
    }

    function tellProxyInfoToGo(){
        var url ="http://"+goIpPort+"/proxy"
        var proxyJson = {
            "isUseProxy": operateconfigfile.getProxyHttpsEnable(),
            "proxyIP": operateconfigfile.getProxyHttpsIP(),
            "proxyPort": operateconfigfile.getProxyHttpsPort(),
            "username": operateconfigfile.getProxyUsreName(),
            "password": operateconfigfile.getProxyPassword(),
            "serverIP": operateconfigfile.getRemoteIP(),
            "serverPort": operateconfigfile.getRemotePort()
        }
        operatehttp.post(url,function(code, data){
            if(code==200){
                console.log("向Go告知代理信息成功")
            }else{
                messagebox.text = "连接Go服务失败，请确认Go服务是否正在运行"
                messagebox.visible = true
                messagebox.nIntervalTime = 5000
                console.log("向Go告知代理信息失败："+code)
            }
        },"(0)="+JSON.stringify(proxyJson))
    }


    //计算是否在考勤范围内
    function isPointInClockRange(clockRange){

        if(clockRange == '' || clockRange == null || clockRange == 'null' || clockRange.length <=0){
            return -2
        }

        var x = longitude
        var y = latitude
        var inside = 0
        console.log("------实际x:"+x+"------实际y:"+y)

        for(var index=0; index < clockRange.length; index++){
            var arrTemp = JSON.parse(clockRange[index])
            for(var templength=0; templength<arrTemp.length; templength++){
                var arr = arrTemp[templength]
                for(var i = 0, j = arr.length - 1; i < arr.length; j = i++) {
                    var jsonI = arr[i];
                    var jsonJ = arr[j];
                    var xi = jsonI[0], yi = jsonI[1];
                    var xj = jsonJ[0], yj = jsonJ[1];
                    var intersect = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
                    if (intersect) {
                        //console.log("------范围x:"+xi+"------范围y:"+yi)
                        //console.log("------实际x:"+x+"------实际y:"+y)
                        return 1;
                    }
                }
            }
        }

        return -1;
    }
    function fillLocationInfo(locationInfo){
        locationInfo.checkTime = JSL.getNowFormatDateValue()
        locationInfo.cid  = uid
        locationInfo.imei = imei
        locationInfo.latitude  = latitude
        locationInfo.longitude = longitude
        locationInfo.locationName   = locationName
        locationInfo.locationId     = locationId
        locationInfo.policeArea     = policeArea
        locationInfo.policeCode     = policeCode
        locationInfo.policeIdcard   = policeIdCard
        locationInfo.policeName     = policeName
        locationInfo.policeUnitCode = policeUnitCode

        locationInfo.policeUnit = policeUnit
        locationInfo.policeAreaCode = policeAreaCode
    }
}
