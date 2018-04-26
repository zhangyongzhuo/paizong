import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealUnit.js"  as ThreeRealJson

//实有单位界面---基本信息使用

BaseInfoUnitPageForm {
    property var pageDataJsonObject:ThreeRealJson.getDwjbxxb()
    property string workLogText:""
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json


    //单位标准地址第一项
    property var  zzmpYsList: []   //原始数据列表
    property var  zzmpList: []     //临时数据列表
    property string zzmpJson: ""   //
    property string zzjgCode: ""   //单位标准地址第一项code
    property string pzzjgCode: ""  //前一时刻

    //单位标准地址第二项
    property var  dzxzYsList: []
    property var dzxzList: []     //
    property string  dzxzCode: ""  //
    property var  dzxzEndJson: []  //
    property string dzxzJson: ""  //


     property var unitClassList: []  //单位类别数据列表
     property var tradeClassList: []  //行业类别数据列表


    Component.onCompleted:{

        remarks.text=workLogText
        remarksNumber.text=remarks.text.length+"/"+256

        //从go服务获取不重复的栋 参数1：operateconfigfile.getOrgCode()
        var url ="http://"+goIpPort+"/sy/building/"+operateconfigfile.getOrgCode()
        //var url ="http://"+"172.19.12.180:8091"+"/sy/building/210102350001"
        console.log("从go服务获取不重复的url:"+url)
        operatehttp.get(url, function(code, data){
            console.log("从go服务获取不重复的栋code:"+code)
            //console.log("从go服务获取不重复的栋data:"+data)
            if(code==200){
                var tempObj = JSON.parse(data)
                var unitList = tempObj.dyBzdzxx

                //房屋地址第一项
                zzmpYsList = unitList //原始数据
                zzmpList = zzmpYsList   //临时数据
                unitData.json= JSON.stringify(zzmpList)
                zzmpJson=unitData.json

            }else{
                messagebox.text = '从go服务获取不重复的栋失败'+code
                messagebox.visible = true
            }
        })

        var url = 'http://'+goIpPort+'/sy/syTypeDict/[BD_D_DWLXDM,D_DW_HYLB]'          //(单位类别/行业类别)
        //console.log("url:"+url)
        operatehttp.get(url, function(code, data){
            if(code == 200){
                if(data != ""){
                    var obj = JSON.parse(data)
                    //console.log("基础信息数据"+obj.length+data)
                    //unitClass.model.clear()
                    unitClassList = []
                    //tradeClass.model.clear()
                    tradeClassList = []
                    //console.log("obj.length"+obj.length)
                    for(var i=0;i<obj.length;i++){
                        var temp = {}
                       // console.log("obj[i].zdbh"+i+obj[i].zdbh)
                        if (obj[i].zdbh == "BD_D_DWLXDM")//单位类别
                        {                            
                            temp.text = obj[i].ct
                            temp.code = obj[i].dm
                            unitClassList.push(temp)
                            //unitClass.model.append({text:obj[i].ct, code:obj[i].dm})
                        }
                        if (obj[i].zdbh == "D_DW_HYLB")//行业类别
                        {
                            temp.text = obj[i].ct
                            temp.code = obj[i].dm
                            tradeClassList.push(temp)
                            //tradeClass.model.append({text:obj[i].ct, code:obj[i].dm})
                        }
                    }
                    unitClass.yuanshiList = unitClassList
                    tradeClass.yuanshiList = tradeClassList
                }
            }else{
                    console.log("查询基础信息数据失败："+code)
            }
        })
    }

    otherBtn.onClicked: {
        anotherName.cursorVisible=false
        popText.visible=true
        emit:unitEnable(false)
    }

    //单位标准地址第一项获得焦点
    houseAddress.onCursorVisibleChanged: {
        if(houseAddress.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
            if(zzmpYsList.length <= 0){    //单位标准地址第一项 原始数据
                unitDataArea.visible = false
                return;
            }else{
                unitDataArea.visible = true
                unitDataArea.bHightLight = true
            }
        }
        else{
            //因为左侧导航栏会抢夺当前文本框焦点 所以当文本框失去焦点时 默认选中
            if(houseAddress.text != ""){
                unitData.json = ""
                zzmpList = []     //临时数据列表
                //到原始Json中查找符合項
                if(zzmpJson == ""){
                    unitDataArea.visible = false
                }
                else{
                    for (var i=0;i<zzmpYsList.length;i++) {
                        if(zzmpYsList[i].mlpxz.indexOf(houseAddress.text)>=0){
                            zzmpList.push(zzmpYsList[i])
                        }
                    }
                    //有符合項
                    if(zzmpList.length > 0){
                        unitData.json = JSON.stringify(zzmpList)
                        houseAddress.text=zzmpList[0].mlpxz
                        zzjgCode = zzmpList[0].mldzid
                        emit: changeUnitZz()
                    }
                    else{
                        unitDataArea.visible = false
                        houseAddress.text=""
                    }
                }
            }
            else{
                uintName.text = ""
                dzxzData.json = ""
                //dzxzList = []
            }

            unitDataArea.visible = false
        }
    }
    //单位标准地址第一项模糊查找
    houseAddress.onTextChanged: {
        if(houseAddress.cursorVisible == true){
            unitDataArea.visible = true
            unitDataArea.bHightLight = true
        }else{
            unitDataArea.visible = false
        }

        if(houseAddress.text != ""){
            unitData.json = ""
            zzmpList = []     //临时数据列表
            //到原始Json中查找符合項
            if(zzmpJson == ""){
                unitDataArea.visible = false
            }
            else{
                for (var i=0;i<zzmpYsList.length;i++) {
                    if(zzmpYsList[i].mlpxz.indexOf(houseAddress.text)>=0){
                        zzmpList.push(zzmpYsList[i])
                    }
                }
                //有符合項
                if(zzmpList.length > 0){
                    unitData.json = JSON.stringify(zzmpList)
                }
                else{
                    unitDataArea.visible = false
                }
            }
        }
        else{
            if(zzmpJson != ""){
               unitData.json = zzmpJson
               zzmpList=zzmpYsList
            }
            else{
                unitDataArea.visible = false
            }
        }
    }
    //单位标准地址第一项发生变化
    onChangeUnitZz:{
        //当前选中前一时刻的栋编码与目前的栋编码不同
        if(pzzjgCode != zzjgCode){
            console.log("-----------单位标准地址 变变变")
            dzxzYsList= []
            dzxzList=[]
            uintName.text = ""
            dzxzData.json = ""
            dzxzList = []
            var url ="http://"+goIpPort+"/sy/address/"+operateconfigfile.getOrgCode()+"/"+zzjgCode
            //var url ="http://"+"172.19.12.180:8091"+"/sy/address/"+operateconfigfile.getOrgCode()+"/"+zzjgJzCode
            console.log("单位标准地址二项url:"+url)
            operatehttp.get(url, function(code, data){
                console.log("单位标准地址第二项code:"+code)
                //console.log("单位标准地址第二项data:"+data)
                if(code==200){
                    var tempObj = JSON.parse(data)
                    var unitList = tempObj.dyBzdzxx
                    for(var i=0;i<unitList.length;i++){
                        var temp = {}
                        temp = unitList[i]
                        temp.hm = qmlData.splitStr(unitList[i].dzxz,unitList[i].mlpxz,1)
                        dzxzYsList.push(temp)
                    }
                    dzxzList=dzxzYsList
                    dzxzData.json =JSON.stringify(dzxzList)
                    dzxzJson=dzxzData.json

                    //查询成功后 前一时刻的code值才进行更改
                    pzzjgCode= zzjgCode
                }else{
                    messagebox.text = '从go服务获取号失败'+code
                    messagebox.visible = true
                }
            })
        }
        else{
            dzxzData.json = JSON.stringify(dzxzList)
            console.log("-----------单位标准地址 没没没变")
        }
    }

    //单位标准地址第二项光标
    uintName.onCursorVisibleChanged: {
        if(uintName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
            if(dzxzYsList.length <= 0){
                dzxzDataArea.visible = false
                return;
            }else{
                dzxzDataArea.visible = true
                dzxzDataArea.bHightLight = true
            }
        }
        else{
            //因为左侧导航栏会抢夺当前文本框焦点 所以当文本框失去焦点时 默认选中
            if(uintName.text != ""){
                dzxzData.json = ""
                dzxzList = []
                //到原始Json中查找符合項
                if(dzxzJson == ""){
                    dzxzDataArea.visible = false
                    uintName.text=""
                }
                else{
                    for (var i=0;i<dzxzYsList.length;i++) {
                        if(dzxzYsList[i].hm.indexOf(uintName.text)>=0){
                            dzxzList.push(dzxzYsList[i])
                        }
                    }
                    //有符合項
                    if(dzxzList.length > 0){
                        dzxzData.json = JSON.stringify(dzxzList)
                        uintName.text=dzxzList[0].hm
                        dzxzCode = dzxzList[0].chdzid
                        dzxzEndJson=dzxzList[0]
                    }
                    else{
                        dzxzDataArea.visible = false
                        uintName.text=""
                    }
                }
            }
            dzxzDataArea.visible = false
        }
    }

    //单位标准地址第二项模糊查找
    uintName.onTextChanged: {
        if(uintName.cursorVisible == true){
            dzxzDataArea.visible = true
            dzxzDataArea.bHightLight = true
        }else{
            dzxzDataArea.visible = false
        }
        if(uintName.text != ""){
            dzxzData.json = ""
            dzxzList = []
            //到原始Json中查找符合項
            if(dzxzJson == ""){
                dzxzDataArea.visible = false
            }
            else
            {
                for (var i=0;i<dzxzYsList.length;i++) {
                    if(dzxzYsList[i].hm.indexOf(uintName.text)>=0){
                        dzxzList.push(dzxzYsList[i])
                    }
                }
                //有符合項
                if(dzxzList.length > 0){
                    dzxzData.json = JSON.stringify(dzxzList)
                }
                else{
                    dzxzDataArea.visible = false
                }
            }
        }
        else{
            if(dzxzJson != ""){
               dzxzData.json = dzxzJson
               dzxzList=dzxzYsList
            }
            else{
                dzxzDataArea.visible = false
            }
        }
    }

    //小键盘调用
    //单位英文名称
    unitName.onCursorVisibleChanged:{
        if(unitName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //单位英文名称
    englishName.onCursorVisibleChanged:{
        if(englishName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //单位英文缩写
    englishAbbreviation.onCursorVisibleChanged:{
        if(englishAbbreviation.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //联系电话
    telephone.onCursorVisibleChanged:{
        if(telephone.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //单位网址
    url.onCursorVisibleChanged:{
        if(url.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //单位别名
    anotherName.onCursorVisibleChanged:{
        if(anotherName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //备注
    remarks.onCursorVisibleChanged:{
        if(remarks.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    unitClass.wenben.onCursorVisibleChanged: {
        if(unitClass.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    tradeClass.wenben.onCursorVisibleChanged: {
        if(tradeClass.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    faxNumber.onCursorVisibleChanged: {
        if(faxNumber.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }

    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            //if(unitName.currentIndex!=-1)
                //pageDataJsonObject.dwmc =unitName.model.get(unitName.currentIndex).code//单位名称
            pageDataJsonObject.dwmc =unitName.text
            pageDataJsonObject.dwywm =englishName.text //单位英文名
            pageDataJsonObject.dwywsx =englishAbbreviation.text  //单位英文缩写
            //order internal security technical fire
            var gll=""
            if(order.checked)//管理类型：1、治安 2、内保 3、保安 4、技防 5、消防
                gll="1"
            if(internal.checked){
                if(gll==""){
                    gll="2"
                }else{
                    gll=gll+", 2"
                }
            }

            if(security.checked){
                if(gll==""){
                    gll="3"
                }else{
                    gll=gll+", 3"
                }
            }
            if(technical.checked){
                if(gll==""){
                    gll="4"
                }else{
                    gll=gll+", 4"
                }
            }
            if(fire.checked){
                if(gll==""){
                    gll="5"
                }else{
                    gll=gll+", 5"
                }
            }
            pageDataJsonObject.gllxdm =gll
            //if(unitClass.currentIndex!=-1)
            //    pageDataJsonObject.dwlbdm = unitClass.model.get(unitClass.currentIndex).code//单位类别>>zdbh: BD_D_DWLXDM

            if(unitClass.chooseItem != undefined && unitClass.chooseItem.code != undefined){
                pageDataJsonObject.dwlbdm = unitClass.chooseItem.code
            }

            pageDataJsonObject.lxdh =telephone.text  //联系电话 11位手机号码
            if(dzxzEndJson.length!=0){
                pageDataJsonObject.dz_dwdzmlpxz =dzxzEndJson.mlpxz //单位标准地址
                pageDataJsonObject.dz_dwdzmlpdm =dzxzEndJson.mldzid  //单位标准地址：门楼牌代码对应地址接口获取的mldzid
                pageDataJsonObject.dz_dwdzdm =dzxzEndJson.chdzid  //单位标准地址：地址代码对应地址接口获取的chdzid
                pageDataJsonObject.dz_dwdzssxdm = dzxzEndJson.xzqhdm  //单位标准地址：行政区划代码对应地址接口获取的xzqhdm
                pageDataJsonObject.dz_dwdzxz =dzxzEndJson.dzxz          //单位标准地址：地址详址对应地址接口获取的dzxz
                pageDataJsonObject.dz_dwzbx = dzxzEndJson.zbx         //单位标准地址：坐标X对应地址接口获取的zbx
                pageDataJsonObject.dz_dwzby = dzxzEndJson.zby         //单位标准地址：坐标Y对应地址接口获取的zby
            }
            //if(tradeClass.currentIndex!=-1)
            //    pageDataJsonObject.hylbdm = tradeClass.model.get(tradeClass.currentIndex).code//行业类别>>zdbh: D_DW_HYLB

            if(tradeClass.chooseItem != undefined && tradeClass.chooseItem.code != undefined){
                pageDataJsonObject.hylbdm = tradeClass.chooseItem.code
            }

            if(foreignUnit.currentIndex!=-1)
                pageDataJsonObject.sfwzdwdm = foreignUnit.model.get(foreignUnit.currentIndex).code//是否外资单位>>zdbh: D_GG_SF
            if(foreignConcerning.currentIndex!=-1)
                pageDataJsonObject.sfswdwdm =foreignConcerning.model.get(foreignConcerning.currentIndex).code//是否涉外单位>>zdbh: D_GG_SF
            pageDataJsonObject.czhm =faxNumber.text  //传真号码
            pageDataJsonObject.wz =url.text  //网址
            if(orderSystem.currentIndex!=-1)
                pageDataJsonObject.sfazzaglxxxt = orderSystem.model.get(orderSystem.currentIndex).code//是否安装治安管理信息系统>>zdbh: D_GG_SF

            if(isFire.currentIndex!=-1)
                pageDataJsonObject.sfyxfjddm = isFire.model.get(isFire.currentIndex).code//是否经消防安全验收合格>>zdbh: D_GG_SF
            pageDataJsonObject.bz =remarks.text  //备注
            pageDataJsonObject.dwbm = anotherName.text //单位别名
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            //echoObject.dwlbdm= unitClass.model.get(unitClass.currentIndex).text     //单位类别
            //console.log("============="+PAGEDATA)
        }
        onSendUnitName:{
            emit:unitEnable(true)
            if(status){
                if(anotherName.text==""){
                    anotherName.text=name
                }else{
                    if(name!=""){
                        anotherName.text=anotherName.text+","+name
                    }
                }
            }
            emit:otherPlus()
            popText.visible=false
        }
        onFinishToEveryControl:{//清空所有
//            unitClass.currentIndex = -1
//            unitClass.currentText =""
            unitClass.chooseItem={}
            unitClass.wenben.text = ""
//            tradeClass.currentIndex =-1
//            tradeClass.currentText = ""
            tradeClass.chooseItem={}
            tradeClass.wenben.text = ""
            unitName.text=""
            englishName.text=""
            englishAbbreviation.text=""
            order.checked=false
            internal.checked=false
            security.checked=false
            technical.checked=false
            fire.checked=false
            telephone.text=""
            foreignUnit.currentIndex!=-1
            foreignUnit.currentText=""
            foreignConcerning.currentIndex!=-1
            foreignConcerning.currentText=""
            faxNumber.text="" //传真号码
            url.text="" //网址
            orderSystem.currentIndex!=-1
            orderSystem.currentText=""
            isFire.currentIndex!=-1
            isFire.currentText=""
            anotherName.text="" //单位别名
            remarks.text="" //备注
            unitName.cursorVisible=false
            englishName.cursorVisible=false
            englishAbbreviation.cursorVisible=false
            url.cursorVisible=false
        }

        //点空白区域 所有下拉框回收
        onComponentRecovery:{
            getFocusComboBox.focus = true
        }
        //其他模块获取到了焦点 本模块下拉框消失
        onBoxAreaOpend:{
            if(page_name!=PAGENAME){
                 getFocusComboBox.focus = true
            }
        }
    }
}
