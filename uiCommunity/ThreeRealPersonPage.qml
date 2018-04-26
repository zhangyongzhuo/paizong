import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealPerson.js"  as PERSON_JSON
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

ThreeRealPersonPageForm {
    property var threeRealJson : PERSON_JSON.getJsonObject()  //数据采集项模板
    property int    colloctType:0           //数据采集类型 值为枚举 qmldata中有定义
    property int    entryPageMode: 0        //1增加 2删除 3修改 4查看 值为枚举 qmldata中有定义
    //property string initJson:""             //初始化Json
    //property bool   isSaveInfo:true         //点击返回按钮时是否要保存信息（主要用于添加车辆关系人时进入 点击返回时不应该保存信息）

    property string prevIdcard: ""          //记录前一次的身份证号
    //property bool isAGFaceExist: false //是否有人脸比对license 有就显示该模块
    property string newIdcardString: ""    //记录最新一次的身份证信息字符串

    //property string prevIdcardTerrorism: "" //记录前一次检测涉恐背景的身份证号
    //property bool   isCheckTerrorism: false //记录是否发起过检测涉恐背景
    //property string entryPage:""           //上一个页面名字
    //property var flagInfoJson: PublicDataJson.getFlagInfo()//标签模板
    //property string carDocumentID: "" //进入模式为车辆相关人时，存储车辆的档案编号
    //property string carRelationship:""//进入模式为车辆相关人时，存储与车辆的关系
    property int    idMode
    function getIndexByName(model, name){
        for(var i=0; i<model.count; i++){
            if(model.get(i).value===name){
                return i
            }
        }
        return -1
    }
//    Component.onCompleted:{
//        //因为要保存点击返回时采集的数据 所以不使用默认的返回按钮处理事件
//        bBackUsed = false
//        //如果为查看模式进入，隐藏完成按钮并且使用默认的返回按钮
//        if(entryPageMode==QmlData.VISIT_TYPE_SEE){ //查看
//            threeRealJson.Data = JSON.parse(initJson)
//            finish.visible = false
//            bBackUsed = true
//        }else if(entryPageMode==QmlData.VISIT_TYPE_MODIFY){//修改
//            threeRealJson.Data = JSON.parse(initJson)
//        }

//        if(qmlData.isFileExist("AGFace.ini")){
//            isAGFaceExist = true
//        }

//        initPage()
//    }

    Component.onCompleted:{
        //因为要保存点击返回时采集的数据 所以不使用默认的返回按钮处理事件
        bBackUsed = false
        personModel.clear()
        personModel.append({PAGENAME: "DocumentInfoPage",     //证件信息
                             PAGEHEIGHT:360,
                             PAGENO: 0,
                             PAGETITLE:"证件信息",
                             PAGETOPLINE: false,
                             PAGEBOTTOMLINE:false,
                               enable: true,
                             PAGEDATA: ''})
        personModel.append({PAGENAME: "BaseInfoPersonPage",     //基本信息
                             PAGEHEIGHT:650,
                             PAGENO: 0,
                             PAGETITLE:"基本信息",
                             PAGETOPLINE: false,
                             PAGEBOTTOMLINE:false,
                               enable: false,
                             PAGEDATA: ''})
        personModel.append({PAGENAME: "TemporaryPersonPage",     //暂/寄住人口信息
                             PAGEHEIGHT: 1010,
                             PAGENO: 0,
                             PAGETITLE:"暂住人口信息",
                             PAGETOPLINE: false,
                             PAGEBOTTOMLINE:false,
                               enable: false,
                             PAGEDATA: ''})

        personModel.append({PAGENAME: "BottomInfoPage", //底部占位模块
                               PAGEHEIGHT:220,
                               PAGENO: 0,
                               PAGELOCAL: false,
                               PAGETITLE:"占位模块",
                               PAGEBOTTOMLINE:false,
                               PAGETYPE: 11,
                               enable: false,
                               PAGEDATA: ''})

    }

    //接收子页面发送的弹框信号 为了信号居中
    Connections{
        target: mainQml
        onQueryConditionFillFinished:{  //添加或修改时对此信号进行处理
            idMode = idcardMode
            if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
                    entryPageMode==QmlData.VISIT_TYPE_MODIFY ){
                if(casecadeName == "IDcardPage"){//身份证界面传过来的查询条件消息
                    //身份证号发生变化清空原有标签结果
                    if(queryCondition.idcard != prevIdcard){
                        var temp=[]
                        emit: showQueryResult(temp, "IDcardPage", true)//清空原有查询结果
                        prevIdcard = queryCondition.zjhm
                    }
                    //在线核查
                    busyIndicator.running = true
                    emit:showPersonOnlineBtnOther()
                    newIdcardString=queryCondition.zjhm
                    getBaseAndTagInfo(queryCondition.zjhm)//查询人员及标签信息
                }
            }
//            else if(entryPageMode==QmlData.VISIT_TYPE_SEE){
//                emit: showQueryResult(threeRealJson.Data.idcardCompareInfo, "IDcardPage", false)//显示查询结果
//            }
        }
        onGetInfoAndTag:{
             if(jsonType == "person"){
                 if(idMode==0){
                     if(newIdcardString==card){
                        emit: initInfoMsg(jsonData, "IDcardPage")//手动录入身份证号填充其他信息
                     }
                 }
                 var obj = JSON.parse(jsonData)
                 if(newIdcardString==card){
                   emit: showQueryResult(obj, "IDcardPage", true)//根据查询结果显示标签
                 }
             }
         }
        onSendCheckSig:{
            //设置在线核查URL
            setOnlineCheckUrl(IDCard, Name)
        }
    }

    //当点击"完成"按钮时，给子页面发送完成信号 让白流填充Json
    finish.onClicked:{
        getFocus.focus = true
        //填充采集信息
        emit: fillInfoMsg("ThreeRealPersonPage")
        fillInfoAndSave(true)
    }

    back.onClicked:{
        getFocus.focus = true
        if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
                entryPageMode==QmlData.VISIT_TYPE_MODIFY){
            popWindow.visible = true
        }
    }
    popWindow.onVisibleChanged: {
        if(popWindow.visible){
            persionPage.enabled = false
            back.enabled = false
            finish.enabled = false
        }
        else{
            persionPage.enabled = true
            back.enabled = true
            finish.enabled =true
        }
    }

    function fillInfoAndSave(isFinished){

        var isSaved = true

        if(isFinished){//点击完成 此时上传状态为待上传
            threeRealJson.IsUpload = 0
        }else{
            threeRealJson.IsUpload = -1
        }
        threeRealJson.OptargetId = documentID
        threeRealJson.PoliceIdcard = policeIdCard
        threeRealJson.DataType = colloctType
        threeRealJson.Data.userid=userName//登陆用户
        threeRealJson.Data.orgjb=operateconfigfile.getOrgJb()//登陆用户所属组织机构级别
        threeRealJson.Data.orgid=operateconfigfile.getOrgId()//登陆用户所属组织机构ID
        threeRealJson.Data.menuname="实有人口管理"//登陆用户所含菜单权限

        threeRealJson.Data.jbxx=JSON.parse(personModel.get(1).PAGEDATA)

        threeRealJson.Data.jbxx.syrkywlxdm = stayType

        threeRealJson.Data.jbxx.cyzjdm = JSON.parse(personModel.get(0).PAGEDATA).cyzjdm
        threeRealJson.Data.jbxx.zjhm = JSON.parse(personModel.get(0).PAGEDATA).zjhm
        threeRealJson.Data.jbxx.xm = JSON.parse(personModel.get(0).PAGEDATA).xm
        threeRealJson.Data.jbxx.xbdm = JSON.parse(personModel.get(0).PAGEDATA).xbdm
        threeRealJson.Data.jbxx.csrq = JSON.parse(personModel.get(0).PAGEDATA).csrq
        threeRealJson.Data.jbxx.mzdm = JSON.parse(personModel.get(0).PAGEDATA).mzdm
        threeRealJson.Data.jbxx.hjd_dzms = JSON.parse(personModel.get(0).PAGEDATA).hjd_dzms



//        threeRealJson.Data.jbxx.lxdh = JSON.parse(personModel.get(1).PAGEDATA).lxdh
//        threeRealJson.Data.jbxx.csdgjhdqdm = JSON.parse(personModel.get(1).PAGEDATA).csdgjhdqdm
//        threeRealJson.Data.jbxx.csdssxdm = JSON.parse(personModel.get(1).PAGEDATA).csdssxdm
//        threeRealJson.Data.jbxx.jggjdqdm = JSON.parse(personModel.get(1).PAGEDATA).jggjdqdm
//        threeRealJson.Data.jbxx.jgssxdm = JSON.parse(personModel.get(1).PAGEDATA).jgssxdm
//        threeRealJson.Data.jbxx.cym = JSON.parse(personModel.get(1).PAGEDATA).cym
//        threeRealJson.Data.jbxx.xldm = JSON.parse(personModel.get(1).PAGEDATA).xldm
//        threeRealJson.Data.jbxx.hyzkdm = JSON.parse(personModel.get(1).PAGEDATA).hyzkdm
//        threeRealJson.Data.jbxx.zzmmdm = JSON.parse(personModel.get(1).PAGEDATA).zzmmdm
//        threeRealJson.Data.jbxx.zjxydm = JSON.parse(personModel.get(1).PAGEDATA).zjxydm
//        threeRealJson.Data.jbxx.byzkdm = JSON.parse(personModel.get(1).PAGEDATA).byzkdm
//        threeRealJson.Data.jbxx.xxdm = JSON.parse(personModel.get(1).PAGEDATA).xxdm
//        threeRealJson.Data.jbxx.zylbdm = JSON.parse(personModel.get(1).PAGEDATA).zylbdm
//        threeRealJson.Data.jbxx.zy = JSON.parse(personModel.get(1).PAGEDATA).zy
//        threeRealJson.Data.jbxx.gzdw = JSON.parse(personModel.get(1).PAGEDATA).gzdw
//        threeRealJson.Data.jbxx.hjd_dzms = JSON.parse(personModel.get(1).PAGEDATA).hjd_dzms
        if(stayType=="3"){
            threeRealJson.Data.ldrk = JSON.parse(personModel.get(2).PAGEDATA)
            threeRealJson.Data.jzrk=PERSON_JSON.getJzrk()
        }
        if(stayType=="2"){
            threeRealJson.Data.jzrk = JSON.parse(personModel.get(2).PAGEDATA)
            threeRealJson.Data.ldrk=PERSON_JSON.getLdrk()
        }
        threeRealJson.Data.xp=xpObject

        //////////////////以上接受完数据，进行去除空格的操作////
        var uploadStr = JSON.stringify(threeRealJson)
        uploadStr = JSL.Trim(uploadStr, 'g')
        threeRealJson = JSON.parse(uploadStr)
        /////////////////////////////////////////
        //证件信息
         if (threeRealJson.Data.jbxx.xm  == ''||threeRealJson.Data.jbxx.xbdm==""||threeRealJson.Data.jbxx.csrq==""||threeRealJson.Data.jbxx.zjhm==""||threeRealJson.Data.jbxx.hjd_dzms==""){
             messagebox.text = '请填写证件信息必填项'
             messagebox.visible = true
             return
         }
         if(threeRealJson.Data.jbxx.cyzjdm=="111"){
                 if(!JSL.isCardNo(threeRealJson.Data.jbxx.zjhm )){
                     if(isFinished){
                         messagebox.text = '身份证号不正确'
                         messagebox.visible = true
                         return
                     }
                 }
         }
         //基本信息
         if(threeRealJson.Data.jbxx.lxdh  == ''){
             messagebox.text = '请填写基本信息必填项'
             messagebox.visible = true
             return
         }
         if(!JSL.checkMobile(threeRealJson.Data.jbxx.lxdh)){
             messagebox.text = "基本信息联系电话格式不正确"
             messagebox.visible = true
             return
         }
        //暂住/寄住信息
         if(stayType=="3"){
             //居住地 暂住是由zjzsydm 来自地行政区划lzd_xzqhdm 来自地描述lzd_dzxz 与房主关系chzr_yfzgx_rygxdm
              if(threeRealJson.Data.ldrk.jzd_dzid  == ''||threeRealJson.Data.ldrk.jzd_mlpdm==""||threeRealJson.Data.ldrk.zjzsydm==""||threeRealJson.Data.ldrk.lzd_xzqhdm==""||threeRealJson.Data.ldrk.lzd_dzxz==""||threeRealJson.Data.ldrk.chzr_yfzgx_rygxdm==""||threeRealJson.Data.ldrk.zjzcsfldm==""){
                  messagebox.text = '请补充完整暂住人口必填项'
                  messagebox.visible = true
                  return
              }
             if(threeRealJson.Data.ldrk.zjzcsfldm=="30"){
                  if(threeRealJson.Data.ldrk.fwczqkdm  == ''||threeRealJson.Data.ldrk.qzrq  == ''||threeRealJson.Data.ldrk.nzrq  == ''){
                      messagebox.text = '请补充完整暂住人口必填项'
                      messagebox.visible = true
                      return
                  }
             }
         }
         if(stayType=="2"){
             //居住地 寄住类别 寄住开始时间
              if(threeRealJson.Data.jzrk.jzd_dzid  == ''||threeRealJson.Data.jzrk.jzd_mlpdm==""||threeRealJson.Data.jzrk.jzlbdm==""||threeRealJson.Data.jzrk.jz_ksrq01==""||threeRealJson.Data.jzrk.zjzcsfldm==""){
                  messagebox.text = '请补充完整寄住人口必填项'
                  messagebox.visible = true
                  return
              }
             if(threeRealJson.Data.jzrk.zjzcsfldm=="30"){//房屋承租情况 起租日期  停止日期
                  if(threeRealJson.Data.jzrk.fwczqkdm  == ''||threeRealJson.Data.jzrk.qzrq  == ''||threeRealJson.Data.jzrk.nzrq  == ''){
                      messagebox.text = '请补充完整寄住人口必填项'
                      messagebox.visible = true
                      return
                  }
             }
         }

        if(isSaved){
            //存储JSON
            var url ="http://"+goIpPort+"/save"

            console.log("存储的总信息："+uploadStr)
            operatehttp.post(url, function(code, data){
                console.log("存储信息结果：", code)
 				if(code==200){
                    messagebox.text = '数据保存成功'
                    messagebox.visible = true
                    emit: finishToEveryControl()
                    builDocument()
                    //锚点定位
                    basic_ui.positionViewAtIndex(0, ListView.Beginning)
                    //readIdcard.stopIdcardIdentification()
                }
                    //stackView.pop()
             },"(0)="+uploadStr)

        }else{
            if(!isFinished){ //点击返回按钮，数据不符合保存条件，则不保存数据直接跳转回上一层
                //readIdcard.stopIdcardIdentification()
                //stackView.pop()
            }
        }
    }

    function getBaseAndTagInfo(card){
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

                console.log("查询基础人员信息和标签code:"+code)
                console.log("查询基础人员信息和标签data:"+data)

                busyIndicator.running = false
                if(code==200||code==0){
                    var obj = JSON.parse(data)
                    threeRealJson.Data.idcardCompareInfo = obj
                    if(newIdcardString==card){//判断是不是最新一次请求
                        emit: getInfoAndTag(data, "person",card)
                    }
                }
                else{
                    console.log(code+"基础人员信息和标签查询失败")
                }
            },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
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
        stackView.push({item: "qrc:/controls/ui/HLK_ShowHtml.qml",properties:{checkURL: url}})

    }
}
