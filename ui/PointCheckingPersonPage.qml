import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/PatrolInquiriesJson.js" as CLB_OBJECT
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

PointCheckingPersonPageForm {
    /********************该文件为卡点盘查-人员盘查瀑布流**************************/
    property var patrolInquiriesJson : CLB_OBJECT.getPatrolInquiriesJson()  //数据采集项模板

    property int    entryPageMode: 0        //1增加 2删除 3修改 4查看 值为枚举 qmldata中有定义
    property int    colloctType:0           //数据采集类型 值为枚举 qmldata中有定义
    property string initJson:""             //初始化Json
    property bool   isSaveInfo:true         //点击返回按钮时是否要保存信息（主要用于添加车辆关系人时进入 点击返回时不应该保存信息）
    property string entryPage:""           //上一个页面名字
    property int    idMode


    property string prevIdcard: ""          //记录前一次的身份证号
    property string newIdcardString: ""    //记录最新一次的身份证信息字符串
    property var    prevIdcardInfo:PublicDataJson.getIdcardJson() //记录前一次的身份证信息
    property string prevIdcardString: ""    //记录前一次的身份证信息字符串

    property string prevIdcardTerrorism: "" //记录前一次检测涉恐背景的身份证号
    property bool   isCheckTerrorism: false //记录是否发起过检测涉恐背景
    property var flagInfoJson: PublicDataJson.getFlagInfo()//标签模板
   // property bool   fromFinish: false //是否是从完成进入保存
    property string preDocumentID:""  //记录上次的档案编号
    property string preDocumentDir:""  //记录上次的档案文件夹路径

    property string carDocumentID: "" //进入模式为车辆相关人时，存储车辆的档案编号
    property string carRelationship:""//进入模式为车辆相关人时，存储与车辆的关系

    property bool isAGFaceExist: false //是否有人脸比对license 有就显示该模块

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

        if(qmlData.isFileExist("AGFace.ini")){
            isAGFaceExist = true
        }

        initPage()
    }

    function initPage(){
        personModel.clear()
        personModel.append({PAGENAME: "IDcardPage",     //二代证采集
                            PAGEHEIGHT:  isX6 ? (undocumentUrl==""?500:610) : (undocumentUrl==""?278:330),
                            PAGENO: 0,
                            PAGETITLE:"二代证采集",
                            PAGETOPLINE: false,
                            PAGEMODE:entryPageMode,
                            PAGELAST:"PointCheckingPersonPage",
                            PAGEDATA: JSON.stringify(patrolInquiriesJson.Data.idcardInfo)})

        if(isAGFaceExist){
            personModel.append({
                            PAGENAME: "PassportComparisonPage", //人脸-身份证比对
                            PAGEHEIGHT: 240,
                            PAGENO: 0,
                            PAGETITLE:"人证比对",
                            PAGEMODE:entryPageMode,
                            PAGEDATA: JSON.stringify(patrolInquiriesJson.Data.faceInfo)})
        }

        personModel.append( {PAGENAME: "RealisticPage", //写实模块
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
            if(pagename=="IDcardPage"){
                patrolInquiriesJson.Data.checkException = exception
                patrolInquiriesJson.CheckException = exception
            }
        }

//        onMainMessageBox:{
//            messagebox.text = msg
//            messagebox.visible = true
//        }
        onBacktocar:{
            if(pageName == 'IDcardPage'){ //二代证采集模块发回来的
                if(text!==""){
                    popWindow.visible = true
                } else{
                    readIdcard.stopIdcardIdentification()
                    stackView.pop()                    
                }
            }
        }
        onSendCheckSig:{
//            if(online){//在线
                //设置在线核查URL
                setOnlineCheckUrl(IDCard, Name)
//            }else{//离线
//                stackView.push({item:"qrc:/singleFunction/ui/OfflineCheckPage.qml",properties:{checkIDCard: IDCard}})
//            }
        }

        onQueryConditionFillFinished:{  //添加或修改时对此信号进行处理
            idMode = idcardMode
            if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
               entryPageMode==QmlData.VISIT_TYPE_MODIFY ){
                if(casecadeName == "IDcardPage"){//身份证界面传过来的查询条件消息                    
                    if (entryPage!="AddPersonInfoPage"){
                        if(prevIdcardString!==""){
                            if(JSON.parse(prevIdcardString).idcard != "")
                            { //之前采集过人
                                patrolInquiriesJson.Data.idcardInfo = JSON.parse(prevIdcardString)
                                emit: fillInfoMsg("")
                                console.log()

                                fillInfoAndSave(true,false,preDocumentID)

                                //清空写实和标签数据
                                var temp=[]
                                emit: showQueryResult(temp, "IDcardPage", true)//清空原有查询结果
                                if(idcardMode==0){
                                    emit: clearAllData("")
                                }else{
                                    emit: clearAllData("IDcardPage")
                                }

                            }
                        }
                        prevIdcard = queryCondition.idcard

                        //保存身份证信息
                        prevIdcardInfo = queryCondition
                        if(idcardMode==0){
                            prevIdcardInfo.name    = ""
                            //prevIdcardInfo.sex     = ""
                            prevIdcardInfo.nation  = ""
                            //prevIdcardInfo.birth   = ""
                            prevIdcardInfo.address = ""
                            prevIdcardInfo.photo=""

                        }
                        prevIdcardString=JSON.stringify(prevIdcardInfo)
                        //进来第一次时保存preDocumentID
                        if(preDocumentID==""){
                            preDocumentID  = documentID
                            preDocumentDir = documentDir
                            builDocument()
                        }
                        else{
                            preDocumentDir = documentDir
                        }
                    }
                    else{
                        //身份证号发生变化清空原有标签结果
                        if(queryCondition.idcard != prevIdcard){
                            var temp=[]
                            emit: showQueryResult(temp, "IDcardPage", true)//清空原有查询结果
                            prevIdcard = queryCondition.idcard
                        }
                    }

                    if(isAGFaceExist){
                        //通知人证比对界面显示采集到的人脸信息看
                        patrolInquiriesJson.Data.faceInfo = PublicDataJson.getFaceInfoJson()
                        patrolInquiriesJson.Data.faceInfo.cardComparePhoto = queryCondition.photo
                        patrolInquiriesJson.Data.faceInfo.tempDir = preDocumentDir
                        emit: initInfoMsg(patrolInquiriesJson.Data.faceInfo, "PassportComparisonPage")
                    }
                    //在线核查
//                    if(online){//在线
////                        //查询此人所有比对数据
////                        getComparedInfo(queryCondition.idcard, queryCondition.name)
////                        emit:showPersonOnlineBtn("在线核查")
////                        if(idcardMode==0){
////                            getBaseInfo(queryCondition.idcard, "")//名字传空
////                        }
                        //查询此人所有比对数据
                        busyIndicator.running = true
                        emit:showPersonOnlineBtn("在线核查")
                        newIdcardString=queryCondition.idcard
                        getBaseAndTagInfo(queryCondition.idcard)//查询人员及标签信息
//                    }else{
//                        getLocalFlag(queryCondition.idcard)
//                        emit:showPersonOnlineBtn("离线核查")
//                    }
                }
            }
            else if(entryPageMode==QmlData.VISIT_TYPE_SEE){
                emit: showQueryResult(patrolInquiriesJson.Data.idcardCompareInfo, "IDcardPage", false)//显示查询结果
            }
        }
        onFaceRecognitionOperation:{
            getFocus.focus = true
            if(operateconfigfile.getShowTextCityNumber()=="410000"||operateconfigfile.getShowTextCityNumber()=="120000"){
                stackView.push({item: "qrc:/singleFunction/ui/MultiPhotosShootPage.qml",
                                   properties:{photocount: 1,receivePageName:"faceRecognition"}})
            }
            else{
                var faceRecognitionUrl = operateconfigfile.getExternalLinksFaceRecognition()
                Qt.openUrlExternally(faceRecognitionUrl)
            }
        }
//         onUndocumentFinish:{
//             console.log("无证页面带回的数据")
//             console.log(name)
//             console.log(card)
//             console.log(photo)
//             var tokens = token
//             if(tokens=='')tokens='123'
//             var datajson={
//                 "hphm": "",
//                 "hpzl": "",
//                 "jybmbh": policeUnitCode,
//                 "jysfzh": policeIdCard,
//                 "jyxm": policeName,
//                 "name": name,
//                 "sfzh": card,
//                 "target": "person",
//                 "type": "getQGRKList"
//             }
//             var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/local-data-service/getData/"
//             //var url="http://"+operateconfigfile.getCardIP()+":"+operateconfigfile.getCardPort()+"/v2/deep_analysis"
//             //var url="http://10.58.45.4:8080/v2/deep_analysis"
//             console.log("开始查询基础人员信息"+url)
//             console.log("发送的datajson"+JSON.stringify(datajson))
//             operatehttp.post(url,function(code, data){
//                 if(code==200||code==0){
//                     console.log("无证无号人像识别请求人员基本信息成功"+data)
//                     emit: undocumentInfoMsg(data,name,card,photo)
//                 }
//                 else{
//                      console.log("无证无号人像识别查询基础人员信息查询失败"+code)
//                 }
//               },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())

//         }
         onGetInfoAndTag:{
             console.log("*************************************")
              if(jsonType == "person"){
                   if(idMode==0){
                      console.log("IDcardPageIDcardPageIDcardPageIDcardPageIDcardPage********************")
                      if(newIdcardString==card){
                        emit: initInfoMsg(jsonData, "IDcardPage")//手动录入身份证号填充其他信息
                      }
                  }
                  //emit: showQueryResult([], "IDcardPage", true)
                  var obj = JSON.parse(jsonData)
                  if(newIdcardString==card){
                    emit: showQueryResult(obj, "IDcardPage", true)//根据查询结果显示标签
                  }
              }
          }
    }

    //当点击"完成"按钮时，给子页面发送完成信号 让白流填充Json
    finish.onClicked:{
        getFocus.focus = true
        //填充采集信息
        //builDocument()
        emit: fillInfoMsg("")
        //fromFinish=true
        fillInfoAndSave(true,true,documentID)
    }

    back.onClicked:{
        getFocus.focus = true
        if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
           entryPageMode==QmlData.VISIT_TYPE_MODIFY){
            // popWindow.visible = true
            emit:sendtocar('IDcardPage')
            emit: finishTask()
        }
    }
//fromFinish是否是从完成进入保存
    function fillInfoAndSave(isFinished,fromFinish,document_Id){     
        var isSaved = true

        if(isFinished){//点击完成 此时上传状态为待上传
            patrolInquiriesJson.IsUpload = 0
        }else{
            patrolInquiriesJson.IsUpload = -1
        }

        patrolInquiriesJson.OptargetId = document_Id
        patrolInquiriesJson.PoliceIdcard = policeIdCard
        patrolInquiriesJson.DataType = colloctType

        patrolInquiriesJson.Data.optargetId   = document_Id
        patrolInquiriesJson.Data.dataType     = colloctType


//        patrolInquiriesJson.RelationId = JSON.stringify(JSON.stringify(patrolTaskId))
//        patrolInquiriesJson.Data.relationId=JSON.stringify(patrolTaskId)// taskId




        fillLocationInfo(patrolInquiriesJson.Data.locationInfo)
        if(fromFinish){
            patrolInquiriesJson.Data.idcardInfo = JSON.parse(personModel.get(0).PAGEDATA)
        }

        if(isAGFaceExist){ //存在人脸比对模块 则取值时get的序号会发生变化
            patrolInquiriesJson.Data.faceInfo = JSON.parse(personModel.get(1).PAGEDATA)
            patrolInquiriesJson.Data.paintRealInfo = JSON.parse(personModel.get(2).PAGEDATA)
            if(patrolInquiriesJson.Data.faceInfo.cardCompareResults == 3){ //人证比对不通过
                patrolInquiriesJson.Data.checkException = true
                patrolInquiriesJson.CheckException =  true
            }

        }
        else{
            patrolInquiriesJson.Data.paintRealInfo = JSON.parse(personModel.get(1).PAGEDATA)
        }

        if(patrolInquiriesJson.Data.idcardInfo.idcard == ''){
            if(isFinished){
                messagebox.text = '请输入身份证号'
                messagebox.visible = true
            }
            isSaved = false
        }else{
            if(!JSL.isCardNo(patrolInquiriesJson.Data.idcardInfo.idcard)){
                if(isFinished){
                    messagebox.text = '身份证号不正确'
                    messagebox.visible = true
                }
                isSaved = false
            }
        }

        if(entryPage =="AddPersonInfoPage"){
            //当由车的界面进入时， 记录人与车的关系， 以及车的档案编号
            //carDocumentID carRelationship
            var carRelatedsItem = CLB_OBJECT.getCarRelateds()//人车关系数组元素
            carRelatedsItem.relationship = carRelationship
            carRelatedsItem.optargetId = carDocumentID

            patrolInquiriesJson.Data.carRelateds.push(carRelatedsItem)
        }

        if(isSaved){
            finish.enabled = false
            //存储JSON
            var url ="http://"+goIpPort+"/save"
            var uploadStr = JSON.stringify(patrolInquiriesJson)
            uploadStr = JSL.Trim(uploadStr, 'g')
            operatehttp.post(url, function(code, data){
                if(code==200){
                    if (entryPage!="AddPersonInfoPage"){
                        messagebox.text = '数据保存成功'
                        messagebox.visible = true
                        if(!fromFinish){
                            preDocumentID  = documentID
                            preDocumentDir = documentDir
                            builDocument()
                           // stackView.pop()

                        }else{
                            emit: finishTask()
                            preDocumentID=""
                            preDocumentDir = ""
                            prevIdcardString=""

                            var data1 = CLB_OBJECT.getPatrolInquiriesJson()
                            patrolInquiriesJson = data1
                            //builDocument()
                            prevIdcardTerrorism=""
                            //1.重新加载列表
                            initPage()

                            //锚点定位到二代证采集处
                            personView.positionViewAtIndex(0, ListView.Beginning)
                        }
                    }else{
                        emit: finishTask()
                        readIdcard.stopIdcardIdentification()
                        stackView.pop()
                    }
                    finish.enabled = true
                }
            },"(0)="+uploadStr)
        }else{
            if(!isFinished){ //点击返回按钮，数据不符合保存条件，则不保存数据直接跳转回上一层
              //  stackView.pop()
            }
        }
    }

    //获取本地标签
    function getLocalFlag(idcard){
        var url = "http://"+goIpPort+ "/localType/"+idcard
        console.log("获取本地标签url"+url)
        operatehttp.get(url, function(code, data){
            if(code === 200){
                emit: showQueryResult([], "IDcardPage", true)
                console.log("获取本地人标签:"+data)
                var obj = JSON.parse(data)
                if(obj==null){
                    flagInfoJson.result[0].text = '通过'
                    flagInfoJson.result[0].property = '111002'
                    emit: showQueryResult(flagInfoJson, "IDcardPage", false)
                    patrolInquiriesJson.Data.idcardCompareInfo = flagInfoJson
                    console.log("获取本地标签数据为空")
                }else{
                    emit: showQueryResult(obj, "IDcardPage", false)
                    patrolInquiriesJson.Data.idcardCompareInfo = obj
                }

            }else{
                console.log('获取本地人标签失败：'+code)
            }
        })
    }

    function setOnlineCheckUrl(idcard,name){//设置在线核查URL
        var tokens = token
        if(tokens=='')tokens='123'

        var url = "http://"
        +operateconfigfile.getRemoteIP()
        +":"
        +operateconfigfile.getRemotePort()
        +"/zxhc/?sfzh="
        +idcard
        +"&name="
        +name
        +"&jysfzh="
        +policeIdCard
        +"&jyxm="
        +policeName
        +"&jybmbh="
        +policeUnitCode
        +"&target="
        +"person"
        +"&token="
        +tokens
        console.log("在线核查人========="+url)
        if(isX6){
            stackView.push({item: "qrc:/controls/uiX6/HLK_ShowHtml.qml",properties:{checkURL: url}})
        }else{
            stackView.push({item: "qrc:/controls/ui/HLK_ShowHtml.qml",properties:{checkURL: url}})
        }
    }

    //获取在线标签 查询此人所有比对信息
    function getComparedInfo(idcard,name){
        console.log("========= 在线查询此人所有比对信息")
        if(prevIdcardTerrorism != idcard && isCheckTerrorism != true){
            var url = "http://"
                    +operateconfigfile.getRemoteIP()
                    +":"
                    +operateconfigfile.getRemotePort()
                    +"/local-data-service/getPersonTags/?sfzh="
                    +idcard
                    +"&name="
                    +qmlData.onConvert(name)
                    +"&jysfzh="
                    +policeIdCard
                    +"&jyxm="
                    +qmlData.onConvert(policeName)
                    +"&jybmbh="
                    +policeUnitCode

            console.log("查询此人比对信息url："+url)
            busyIndicator.running = true
            operatehttp.get(url, function(code, data){
                busyIndicator.running = false
                if(code===200||code===0){
                    emit: showQueryResult([], "IDcardPage", true)//清空原有查询结果
                    console.log("人比对信息查询结果："+data)
                    var obj = JSON.parse(data)
                    console.log("人的比对结果:"+JSON.stringify(obj))
                    patrolInquiriesJson.Data.idcardCompareInfo = obj

                    //if(obj.result != null){//有数据
                        emit: showQueryResult(obj, "IDcardPage", false)                        
                    //}
//                    else{
//                        flagInfoJson.result[0].text = '通过'
//                        flagInfoJson.result[0].property = '111002'
//                        emit: showQueryResult(flagInfoJson, "IDcardPage", false)
//                        patrolInquiriesJson.Data.idcardCompareInfo = flagInfoJson
//                    }
                }else if(code === 500){
                    messagebox.text = "查询异常，错误码："+code
                    messagebox.visible = true
                    console.log("查询此人比对信息发送失败了，错原因："+data);
                }else{
                    messagebox.text = "查询异常，错误码："+code
                    messagebox.visible = true
                    console.log("查询此人比对信息发送失败了，错误码："+code);
                }
                isCheckTerrorism = false
            }, token, operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
            prevIdcardTerrorism = idcard
            isCheckTerrorism = true
        }
    }
    function getBaseInfo(card,name){
        var datajson={
            "hphm": "",
            "hpzl": "",
            "jybmbh": policeUnitCode,
            "jysfzh": policeIdCard,
            "jyxm": policeName,
            "name": name,
            "sfzh": card,
            "target": "person",
            "type": "getQGRKList"
        }
        var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/local-data-service/getData/"
        console.log("开始查询基础人员信息"+url)
        console.log("发送的datajson"+JSON.stringify(datajson))
        operatehttp.post(url,function(code, data){
            if(code==200||code==0){
                console.log("查询到的基础人员信息"+data)
                var obj=JSON.parse(data)
                //prevIdcardInfo
                if(obj.result != null){
                    if(obj.result.length!= 0){
                   // prevIdcardInfo.sex    = obj.result[0].XB
                    prevIdcardInfo.name   = obj.result[0].XM
                    prevIdcardInfo.nation = obj.result[0].MZ
                    //prevIdcardInfo.birth   = obj.result[0].CSRQ
                    if(obj.result[0].ZZXZ != undefined){
                        prevIdcardInfo.address = obj.result[0].ZZXZ
                    }
                    if(obj.result[0].XP!=undefined){
                         if(obj.result[0].XP!=null){
                            console.log("手动输入身份证号查回照片"+ "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                        +"/img/"+qmlData.splitStr(obj.result[0].XP,"/",4))
                            prevIdcardInfo.photo= "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                    +"/img/"+qmlData.splitStr(obj.result[0].XP,"/",4)
                         }else{
                               prevIdcardInfo.photo =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                         }
                    }else{
                          prevIdcardInfo.photo =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                    }
                    prevIdcardString=JSON.stringify(prevIdcardInfo)
                    }
                }
                emit: initInfoMsg(data, "IDcardPage")
            }
            else{
                console.log(code+"查询基础人员信息查询失败")
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }
    function getBaseAndTagInfo(card){
        patrolInquiriesJson.Data.idcardCompareInfo = []
            var datajson={
                "hphm": "",
                "hpzl": "",
                "jybmbh": policeUnitCode,
                "jysfzh": policeIdCard,
                "jyxm": policeName,
                "name": "",
                "sfzh": card,
                "target": "person",
                "type": "getQGRKList"
            }
            var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/local-data-service/getTagsInfo/"
          //  var url="http://172.19.12.102:7100/getTagsInfo"
            console.log("开始查询基础人员信息和标签"+url)
            console.log("发送的datajson"+JSON.stringify(datajson))
            operatehttp.post(url,function(code, data){
//                console.log("开始查询基础人员信息和标签code:"+code)
//                console.log("开始查询基础人员信息和标签data:"+data)
                if(code==200||code==0){
                    busyIndicator.running = false
                    var obj = JSON.parse(data)
					 if(idMode==0){
                   		if (obj.result.infos != null)
                        {
                            if (obj.result.infos.length > 0){
                                if(obj.result.length!= 0){
                                prevIdcardInfo.name   = obj.result.infos[0].XM
                                prevIdcardInfo.nation = obj.result.infos[0].MZ
                                if(obj.result.infos[0].ZZXZ != undefined){
                                    prevIdcardInfo.address = obj.result.infos[0].ZZXZ
                                }
                                if(obj.result.infos[0].XP!=undefined){
                                     if(obj.result.infos[0].XP!=null){
                                        console.log("手动输入身份证号查回照片"+ "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                                    +"/img/"+qmlData.splitStr(obj.result.infos[0].XP,"/",4))
                                        prevIdcardInfo.photo= "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                                +"/img/"+qmlData.splitStr(obj.result.infos[0].XP,"/",4)
                                     }else{
                                           prevIdcardInfo.photo =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                                     }
                                }else{
                                      prevIdcardInfo.photo =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                                }
                                prevIdcardString=JSON.stringify(prevIdcardInfo)
                                }
                            }
                        }
                    }
                    if (obj.result.infos != null){
                        if (obj.result.infos[0].SFZH == card || obj.result.infos[0].SFZH == undefined){
                            patrolInquiriesJson.Data.idcardCompareInfo = obj
                        }
                    }
                    if(newIdcardString==card){//判断是不是最新一次请求
                        emit: getInfoAndTag(data, "person",card)
                    }
                }
                else{
                    console.log(code+"基础人员信息和标签查询失败")
                }
            },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
        }
}
