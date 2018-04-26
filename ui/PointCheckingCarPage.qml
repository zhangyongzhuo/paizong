import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/PatrolInquiriesJson.js" as CLB_OBJECT
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

PointCheckingCarPageForm {
    /********************该文件为卡点盘查-车辆盘查瀑布流**************************/
    property var patrolInquiriesJson : CLB_OBJECT.getPatrolInquiriesJson()  //数据采集项模板

    property int    entryPageMode: 0        //1增加 2删除 3修改 4查看 值为枚举 qmldata中有定义
    property int    colloctType:0           //数据采集类型 值为枚举 qmldata中有定义
    property string initJson:""             //初始化Json
    property string prevLicensePlateNo: ""  //记录上一次的车牌号
    property string prevLicensePlateType: ""  //记录上一次的车牌号类型码
    property string prevIdcardTerrorism: "" //记录前一次检测盗抢车辆的车牌号
    property bool   isCheckTerrorism: false //记录是否发起过检测盗抢车辆
    property var carTypeMap: [] //车辆类型字典
    property var flagInfoJson: PublicDataJson.getFlagInfo()//标签模板
    Component.onCompleted:{
        //因为要保存点击返回时采集的数据 所以不使用默认的返回按钮处理事件
        bBackUsed = false
        //如果为查看模式进入，隐藏完成按钮并且使用默认的返回按钮
        if(entryPageMode==QmlData.VISIT_TYPE_SEE){ //查看
            patrolInquiriesJson.Data = JSON.parse(initJson)
            finish.visible = false
            bBackUsed = true
        }else if(entryPageMode==QmlData.VISIT_TYPE_MODIFY){//修改
            patrolInquiriesJson.Data = JSON.parse(initJson)
        }
        initPage()
    }

    function initPage(){
        carModel.clear()
        carModel.append({PAGENAME: "CarsPage",
                            PAGEHEIGHT:isX6 ? 520 : 320,
                            PAGENO: 0,
                            PAGETITLE:"车辆采集",
                            PAGEBOTTOMLINE:true,
                            PAGEMODE:entryPageMode,
                            PAGEDATA: JSON.stringify(patrolInquiriesJson.Data.carInfo)} )
        carModel.append({PAGENAME: "AddPersonInfoPage",
                         PAGEHEIGHT:isX6 ? 376 : 240,
                         PAGENO: 0,
                         PAGETITLE:"添加人员",
                         PAGEBOTTOMLINE:true,
                         PAGEJUMP:0,
                         PAGETYPE: colloctType,
                         PAGEMODE:entryPageMode,
                         PAGELAST:"PointCheckingCarPage",
                         PAGEDATA: JSON.stringify(patrolInquiriesJson.Data.carRelateds)})
        carModel.append( {PAGENAME: "RealisticPage", //写实模块
                            //PAGEHEIGHT:410,
                            PAGENO: 0,
                            PAGETITLE:"写实",
                            PAGETYPE:colloctType,
                            PAGEMODE:entryPageMode,
                            PAGEBOTTOMLINE:false,
                            PAGEDATA: JSON.stringify(patrolInquiriesJson.Data.paintRealInfo)})
    }

    //接收子页面发送的弹框信号 为了信号居中
    Connections{
        target: mainQml
        onCheckException:{
            if(pagename=="CarPage"){
                patrolInquiriesJson.Data.checkException = exception
                patrolInquiriesJson.CheckException = exception
            }
        }
        onMainMessageBox:{
            messagebox.text = msg
            messagebox.visible = true
        }
        onMarkLoadFinish:{
            carModel.set(1, { "PAGEHEIGHT":realHeight})
        }
        onQueryConditionFillFinished:{  //添加或修改时对此信号进行处理
            if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
                    entryPageMode==QmlData.VISIT_TYPE_MODIFY )
            {
                if(casecadeName == "CarPage"){//车辆界面传过来的查询条件消息
                    //车牌号发生变化清空原有标签结果
                    if(queryCondition.licensePlateNo != prevLicensePlateNo||queryCondition.licensePlateTypeCode!=prevLicensePlateType){
                        var temp=[]
                        emit: showQueryResult(temp, "CarPage", true)//清空原有查询结果
                        prevLicensePlateNo = queryCondition.licensePlateNo
                        prevLicensePlateType=queryCondition.licensePlateTypeCode
                    }
                    //在线核查
                  //  if(online){//在线
                        //查询车标签
                        emit:showCarOnlineBtn("在线核查")
                        //查询车辆基础信息
                        busyIndicator.running = true
                        getCarBaseInfo(queryCondition.licensePlateNo,queryCondition.licensePlateTypeCode)
//                    }else{
//                        getLocalFlag(queryCondition.licensePlateNo)
//                        emit:showCarOnlineBtn("离线核查")
//                    }
                }
            }
            else{
                if(casecadeName == "CarPage"){
                    emit: showQueryResult(patrolInquiriesJson.Data.carCompareInfo, "CarPage", false)//显示查询结果
                }
            }
        }

        onCarInfoOnlineCheck:{
//            if(online){//在线
//                //设置在线核查URL
                setOnlineCheckUrl(plateNO, plateType)
//            }else{//离线
//                stackView.push({item:"qrc:/singleFunction/ui/OfflineCheckPage.qml",properties:{checkIDCard: plateNO}})
//            }
        }
        onBacktocar:{
            if(pageName == 'CarsPage'){ //车辆采集界面发回来的
                if(text!==""){
                    popWindow.visible = true
                } else{
                    stackView.pop()
                }
            }
        }
    }



    //当点击"完成"按钮时，给子页面发送完成信号 让白流填充Json
    finish.onClicked:{
        //填充采集信息
        emit: fillInfoMsg("AddPersonInfoPage")
        fillInfoAndSave(true)
    }

    back.onClicked:{
        if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
                entryPageMode==QmlData.VISIT_TYPE_MODIFY){
            //popWindow.visible = true
            emit:sendtocar('CarsPage')
        }
    }

    function fillInfoAndSave(isFinished){
        var isSaved = true

        if(isFinished){//点击完成 此时上传状态为待上传
            patrolInquiriesJson.IsUpload = 0
        }else{
            patrolInquiriesJson.IsUpload = -1
        }

        patrolInquiriesJson.OptargetId = documentID
        patrolInquiriesJson.PoliceIdcard = policeIdCard
        patrolInquiriesJson.DataType = colloctType

        patrolInquiriesJson.Data.optargetId   = documentID
        patrolInquiriesJson.Data.dataType     = colloctType

//        //保存任务码
//        if (colloctType==QmlData.INTO_TYPE_POINTCARD_CAR){
//            patrolInquiriesJson.RelationId = JSON.stringify(JSON.stringify(checkpointTaskId))
//            patrolInquiriesJson.Data.relationId=JSON.stringify(checkpointTaskId)// taskId
//            console.log(patrolInquiriesJson.Data.relationId)
//        }else{
//            patrolInquiriesJson.RelationId = JSON.stringify(JSON.stringify(patrolTaskId))
//            patrolInquiriesJson.Data.relationId=JSON.stringify(patrolTaskId)// taskId
//        }

        fillLocationInfo(patrolInquiriesJson.Data.locationInfo)

        patrolInquiriesJson.Data.carInfo = JSON.parse(carModel.get(0).PAGEDATA)
        patrolInquiriesJson.Data.carRelateds = JSON.parse(carModel.get(1).PAGEDATA)
        patrolInquiriesJson.Data.paintRealInfo = JSON.parse(carModel.get(2).PAGEDATA)
        if(patrolInquiriesJson.Data.carInfo.licensePlateNo == ''){
            if(isFinished){
                messagebox.text = '请输入车牌号码'
                messagebox.visible = true
            }
            isSaved = false
        }else{
            if(!JSL.isVehicleNumber(patrolInquiriesJson.Data.carInfo.licensePlateNo)){
                if(isFinished){
                    messagebox.text = '车牌号码不正确'
                    messagebox.visible = true
                }
                isSaved = false
            }
        }

        if(isSaved){
            finish.enabled = false
            //存储JSON
            var url ="http://"+goIpPort+"/save"
            var uploadStr = JSON.stringify(patrolInquiriesJson)
            uploadStr = JSL.Trim(uploadStr, 'g')
            console.log("che===========:"+uploadStr)
            operatehttp.post(url, function(code, data){
                console.log("存储信息结果：", code)
                emit: finishTask()
                if (colloctType==QmlData.INTO_TYPE_POINTCARD_CAR){
                    messagebox.text = '数据保存成功'
                    messagebox.visible = true
                    var data1 = CLB_OBJECT.getPatrolInquiriesJson()
                    patrolInquiriesJson = data1

                    builDocument()

                    //1.重新加载列表
                    initPage()

                    //锚点定位到二代证采集处
                    personView.positionViewAtIndex(0, ListView.Beginning)
                }else{
                    stackView.pop()
                }
                finish.enabled = true
            },"(0)="+uploadStr)
        }else{
            if(!isFinished){ //点击返回按钮，数据不符合保存条件，则不保存数据直接跳转回上一层
                stackView.pop()
            }
        }
    }

    //获取本地标签
    function getLocalFlag(carNumber){
        var url = "http://"+goIpPort+ "/localType/"+carNumber
        operatehttp.get(url, function(code, data){
            if(code === 200){
                emit: showQueryResult([], "CarPage", true)
                console.log("获取本地车标签:"+JSON.stringify(data))
                var obj = JSON.parse(data)
                if(obj==null){
                    flagInfoJson.result[0].text = '通过'
                    flagInfoJson.result[0].property = '111002'
                    emit: showQueryResult(flagInfoJson, "CarPage", false)
                    patrolInquiriesJson.Data.carCompareInfo = flagInfoJson
                    console.log("获取本地标签数据为空")
                }else{
                    emit: showQueryResult(obj, "CarPage", false)
                    patrolInquiriesJson.Data.carCompareInfo = obj
                }
            }else{
                console.log('获取本地车标签失败：'+code)
            }
        })
    }

    function setOnlineCheckUrl(plateNO, plateTypeCode){//设置在线核查URL
        var tokens = token
        if(tokens=='')tokens='123'
        var url = "http://"
                +operateconfigfile.getRemoteIP()
                +":"
                +operateconfigfile.getRemotePort()
                +"/zxhc/?hphm="
                +qmlData.onConvert(plateNO)
                +"&hpzl="
                +plateTypeCode
                +"&jysfzh="
                +policeIdCard
                +"&jyxm="
                +policeName
                +"&jybmbh="
                +policeUnitCode
                +"&target="
                +"car"
                +"&token="
                +tokens

        console.log("在线核查车========="+url)
        if(isX6){
            stackView.push({item: "qrc:/controls/uiX6/HLK_ShowHtml.qml",properties:{checkURL: url}})
        }else{
            stackView.push({item: "qrc:/controls/ui/HLK_ShowHtml.qml",properties:{checkURL: url}})
        }
    }

    //获取车辆基础信息
        function getCarBaseInfo(licensePlateNo,type){
            var param = {
                "hphm": licensePlateNo,
                "hpzl": type,
                "jybmbh": policeUnitCode,
                "jysfzh": policeIdCard,
                "jyxm": policeName,
                "name": "",
                "sfzh": "",
                "target": "car",
                "type": "QueryJDC"
            }
            var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/local-data-service/getTagsInfo/"
            //var url="http://172.19.12.102:7100/getTagsInfo"
            console.log("获取车辆基础信息URL:"+url)
            console.log("获取车辆基础信息传入参数:"+JSON.stringify(param))
            operatehttp.post(url,function(code, data){
                if(code==200){
                    console.log("获取车辆基础信息收到数据："+data)
                    busyIndicator.running = false
                    var obj = JSON.parse(data)
                    patrolInquiriesJson.Data.carCompareInfo  = obj
                    emit: showQueryResult(obj, "CarPage", true) //显示车辆标签
                    emit: carBaseInfoCheckFinish(data) //显示车辆基本信息
                }
                else{
                    messagebox.text = "车辆基础信息查询异常，错误码："+code
                    messagebox.visible = true
                    console.log("获取车辆基础信息失败Code:"+code)
                }
            },"(0)="+JSON.stringify(param),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())

        }
}
