import QtQuick 2.4
import "qrc:/collectJson/js/ThreeRealRoom.js"  as ThreeRealJson
CustodianInfoPageForm {
    property var pageDataJsonObject:ThreeRealJson.getFwjbxxb()
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json
    property int cardIndex: 0         //证件种类默认inxdex
    //证件种类模糊查找
//    property string idTypeJson: ""  //
//    property string idTypeCode: ""  //
//    property var idTypeList: []     //
//    property var idTypeOriginalList: []

    Component.onCompleted:{
        var url = 'http://'+goIpPort+'/sy/syTypeDict/[KX_D_CYZJDM,XZ_D_CZFWRYGXDM]'          //(常用证件/与房主关系)
        //console.log("url:"+url)
        operatehttp.get(url, function(code, data){
            if(code == 200){
                if(data != ""){
                    var obj = JSON.parse(data)
                    //console.log("基础信息数据"+obj.length+data)
                    idType.model.clear()
                    relationOwer.model.clear()
                    //console.log("obj.length"+obj.length)
                    for(var i=0;i<obj.length;i++){
                        //console.log("obj[i].zdbh"+i+obj[i].zdbh)
                        if (obj[i].zdbh == "KX_D_CYZJDM")//常用证件
                        {
                            idType.model.append({text:obj[i].ct, code:obj[i].dm})
                            //不默认
                            if(obj[i].dm=="111"){
//                                //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm,obj[i].ct)
//                                idType.currentIndex = i
//                                idType.currentText = obj[i].ct
                                cardIndex = i
                            }
                        }
//                        {
//                            var temp = {}
//                            temp.text = obj[i].ct
//                            temp.code = obj[i].dm
//                            idTypeOriginalList.push(temp)
//                            if(obj[i].dm=="111"){
//                                //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm,obj[i].ct)
//                                idType.text = obj[i].ct
//                                idTypeCode = obj[i].dm
//                            }
//                        }
                        if (obj[i].zdbh == "XZ_D_CZFWRYGXDM")//与房主关系
                        {
                            relationOwer.model.append({text:obj[i].ct, code:obj[i].dm})
                        }
                    }
                    relationOwer.currentIndex = -1
                    relationOwer.currentText = ""
                    //常用证件
//                    idTypeList=idTypeOriginalList
//                    idChangeData.json=JSON.stringify(idTypeList)
//                    idTypeJson=idChangeData.json
                }
            }else{
                    console.log("查询实有房屋_托管人信息数据失败："+code)
            }
        })
    }

//    idType.onCursorVisibleChanged: {
//        //console.log("========:"+policejson)
//        if(idType.cursorVisible){
//            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
//                 qmlData.startVkeyBoard()
//            }
//            if(idTypeOriginalList.length <= 0){
//                idTypeChange.visible = false
//                return;
//            }else{
//                idTypeChange.visible = true
//                idTypeChange.bHightLight = true
//            }
//        }else{
//            if(idTypeCode==""){//首先确定单位编码是否为空
//                if(idTypeList.length>0){
//                    idType.text=idTypeList[0].text
//                    //idChangeData.text=idType.text
//                    for(var j=0; j<idTypeOriginalList.length; j++){
//                        if(idType.text == idTypeOriginalList[j].text){
//                            idTypeCode = idTypeOriginalList[j].code
//                        }
//                    }
//                }else{
//                    idType.text=""
//                    //idChangeData.text=idType.text
//                }
//            }
//            idTypeChange.visible = false
//        }

//    }
//    idType.onTextChanged: {
//        //console.log("========:"+policejson)
//        //        if(policelist.length <= 0){
//        //            policeDataArea.visible = false
//        //            return;
//        //        }
//        idTypeCode=""
//        if(idType.cursorVisible == true){
//            idTypeChange.visible = true
//            idTypeChange.bHightLight = true
//        }else{
//            idTypeChange.visible = false
//        }
//        if(idType.text != ""){
//            idChangeData.json = ""
//            idTypeList = []
//            //到原始Json中查找符合項
//            if(idTypeJson == ""){
//                idTypeChange.visible = false
//            }
//            else{
//                var obj = JSON.parse(idTypeJson)
//                for (var i=0;i<obj.length;i++) {
//                    if(obj[i].text.indexOf(idType.text)>=0){
//                        idTypeList.push(obj[i])
//                    }
//                }
//                //有符合項
//                if(idTypeList.length > 0){
//                    idChangeData.json = JSON.stringify(idTypeList)
//                }
//                else{
//                    idTypeChange.visible = false
//                }
//            }
//        }
//        else{
//            if(idTypeJson != ""){
//               idChangeData.json = idTypeJson
//               idTypeList=idTypeOriginalList
//            }
//            else{
//                idTypeChange.visible = false
//            }
//        }
//        for(var j=0; j<idTypeOriginalList.length; j++){
//            if(idType.text ==idTypeOriginalList[j].text){
//                idTypeCode = idTypeOriginalList[j].code
//            }
//        }
//    }

    //小键盘调用
    idType.onCurrentTextChanged: {
        if(isOwner){
            if(idType.currentIndex!=-1){
                emit:backOwerRelationChanged(idType.model.get(idType.currentIndex).code,"idType")
            }
        }
    }
    //证件号码
    idNumber.onCursorVisibleChanged:{
        if(idNumber.cursorVisible){
            if(idType.currentText==""){
                messagebox.text = "请先选择证件种类"
                messagebox.visible = true
                getFocus.focus = true
                return
            }
            else{
                if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                    qmlData.startVkeyBoard()
                }
            }
        }else{
            getFocus.focus = true
        }
    }
    //姓名
    owerName.onCursorVisibleChanged:{
        if(owerName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //联系电话
    phoneNumber.onCursorVisibleChanged:{
        if(phoneNumber.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //外文姓
    foreignSur.onCursorVisibleChanged:{
        if(foreignSur.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //外文名
    foreignName.onCursorVisibleChanged:{
        if(foreignName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }

    relationOwer.onCurrentTextChanged:{
        if(relationOwer.currentIndex!=-1){
            console.log(relationOwer.model.get(relationOwer.currentIndex).code)
            if(relationOwer.model.get(relationOwer.currentIndex).code=="400"){
                emit:owerRelationChanged()
                isOwner=true
            }
            else{
                clearAll()
                idNumber.isEnable=true
                owerName.isEnable=true
                phoneNumber.isEnable=true
                foreignSur.isEnable=true
                foreignName.isEnable=true
                idType.isEnable=true
                isOwner=false
            }
        }
    }

    function clearAll(){
        idType.currentIndex = -1//cardIndex
        idType.currentText = ""//idType.model.get(cardIndex).text
        idNumber.text ="" //	出租人证件号码
        owerName.text=""  //出租人姓名
        phoneNumber.text =""   //	出租人联系电话
        foreignSur.text =""  //出租人外文姓
        foreignName.text=""  //出租人外文名
        owerName.cursorVisible=false
        foreignSur.cursorVisible=false
        foreignName.cursorVisible=false
    }

    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            if(idType.currentIndex!=-1)
            pageDataJsonObject.tgr_cyzjdm = idType.model.get(idType.currentIndex).code//
            pageDataJsonObject.tgr_zjhm =idNumber.text  //当tgr_cyzjdm不为空时必填	房屋托管人证件号码
            pageDataJsonObject.tgr_xm =owerName.text  //当tgr_cyzjdm不为空时必填	房屋托管人姓名
            pageDataJsonObject.tgr_lxdh =phoneNumber.text  //当tgr_cyzjdm不为空时必填	房屋托管人联系电话
            pageDataJsonObject.tgr_wwx =foreignSur.text //房屋托管人外文姓
            pageDataJsonObject.tgr_wwm =foreignName.text//房屋托管人外文名relationOwer
            if(relationOwer.currentIndex!=-1)
                pageDataJsonObject.tgr_yfzgx_rygxdm = relationOwerData.get(relationOwer.currentIndex).code//房屋托管人与房主关系>>zdbh: XZ_D_RYGXDM
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            //console.log("============="+PAGEDATA)
        }
        onSendPageUabled:{
           cadeEnabled=status
           status?colorR=  "#FFFFFF":colorR= "#F2F2F4"
            if(status){
                //idType.currentIndex =cardIndex
                //idType.currentText =idType.model.get(cardIndex).text

                idNumber.isEnable=true
                owerName.isEnable=true
                phoneNumber.isEnable=true
                foreignSur.isEnable=true
                foreignName.isEnable=true
                idType.isEnable=true
                relationOwer.isEnable=true
                isOwner=true
            }
            else{
                clearAll()
                relationOwer.currentIndex = -1
                relationOwer.currentText = ""

                idNumber.isEnable=false
                owerName.isEnable=false
                phoneNumber.isEnable=false
                foreignSur.isEnable=false
                foreignName.isEnable=false
                idType.isEnable=false
                relationOwer.isEnable=false
                isOwner=false
            }
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

        onFinishToEveryControl:{//清空所有
            clearAll()
//            idNumber.text=""  //当tgr_cyzjdm不为空时必填	房屋托管人证件号码
//            owerName.text=""   //当tgr_cyzjdm不为空时必填	房屋托管人姓名
//            phoneNumber.text=""   //当tgr_cyzjdm不为空时必填	房屋托管人联系电话
//            foreignSur.text=""  //房屋托管人外文姓
//            foreignName.text="" //房屋托管人外文名relationOwer
//            relationOwer.currentIndex = -1
//            relationOwer.currentText = ""
//            idType.currentIndex = -1 //cardIndex
//            idType.currentText = ""  //idType.model.get(cardIndex).text
//            owerName.cursorVisible=false
//            foreignSur.cursorVisible=false
//            foreignName.cursorVisible=false
        }

        onInitInfoMsg:{
            if(casecadeName == "CustodianInfoPage") //瀑布流界面发送来的二代证扫描信息
            {
                if(initInfo == "房主本人"){
                    for(var i=0;i<relationOwer.model.count;i++){
                        if(relationOwer.model.get(i).code=="400"){
                            relationOwer.currentIndex = i
                            relationOwer.currentText = relationOwer.model.get(i).text
                        }
                    }
                }
                else{
                    if(idType.currentText != "居民身份证")
                    {
                        for( i=0;i<idType.model.count;i++){
                            if(idType.model.get(i).code=="111"){
                                idType.currentIndex = i
                                idType.currentText = idType.model.get(i).text
                            }
                        }
                    }

                    idNumber.text = initInfo.idcard
                    owerName.text = initInfo.name
                }
            }
        }

        onBackOwerRelationChanged:{
            if(relationOwer.currentText == "房主本人"){
                switch(controlName){
                    case "idType"://
                        for(var i=0;i<idType.model.count;i++){
                           if(idType.model.get(i).code==dataStr){
                               console.log(i)
                               console.log(idType.model.get(i).code)
                               //console.log(obj.fz_cyzjdm)
                               idType.currentIndex =i
                               idType.currentText=idType.model.get(i).text
                           }
                        }
                        break
                    case "idNumber"://
                      idNumber.text =dataStr
                        break
                    case "owerName"://
                      owerName.text=dataStr
                        break
                    case "phoneNumber"://
                      phoneNumber.text=dataStr
                        break
                    case "foreignSur"://
                      foreignSur.text=dataStr
                        break
                    case "foreignName"://
                      foreignName.text=dataStr
                        break
                     case "all"://
                        var obj=JSON.parse(dataStr)
                        for(var i=0;i<idType.model.count;i++){
                           if(idType.model.get(i).code==obj.fz_cyzjdm){
                               console.log(i)
                               console.log(idType.model.get(i).code)
                               console.log(obj.fz_cyzjdm)
                               idType.currentIndex =i
                               idType.currentText=idType.model.get(i).text
                           }
                        }
                        idNumber.text =obj.fz_zjhm //	出租人证件号码
                        owerName.text=obj.fz_xm  //出租人姓名
                        phoneNumber.text =obj.fz_lxdh  //	出租人联系电话
                        foreignSur.text =obj.fz_wwx  //出租人外文姓
                        foreignName.text=obj.fz_wwm  //出租人外文名
                        idNumber.isEnable=false
                        owerName.isEnable=false
                        phoneNumber.isEnable=false
                        foreignSur.isEnable=false
                        foreignName.isEnable=false
                        idType.isEnable=false
                        break
                    }
            }
        }
    }

 }
