import QtQuick 2.4
import "qrc:/collectJson/js/ThreeRealRoom.js"  as ThreeRealJson

OwnerInfoPageForm {
    property var pageDataJsonObject:ThreeRealJson.getFwjbxxb()
    property int cardIndex: 0         //证件种类默认inxdex
//证件种类模糊查找
//    property string idTypeJson: ""  //
//    property string idTypeCode: ""  //
//    property var idTypeList: []     //
//    property var idTypeOriginalList: []

    Connections{
        target: mainQml
//        //获取焦点
        onBoxAreaOpend:{
            if(page_name!=PAGENAME){
                 getFocusComboBox.focus = true
            }
        }
        onComponentRecovery:{
            getFocus.focus = true
        }
	}
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json
    Component.onCompleted:{

        var CYZJDM_Url = 'http://'+goIpPort+'/sy/syTypeDict/KX_D_CYZJDM'          //(常用证件)
        operatehttp.get(CYZJDM_Url, function(code, data){
            if(code == 200){
                if(data != ""){
                    var obj = JSON.parse(data)
                    if (obj.length > 0){
                        idType.model.clear()
                        var selected=0
                        for(var i=0;i<obj.length;i++){
                            //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
                            //idType.model.append({text:obj[i].ct, code:obj[i].dm})
                            if(obj[i].dm=="111"||obj[i].dm=="112"||obj[i].dm=="335"||obj[i].dm=="414"||obj[i].dm=="784"||obj[i].dm=="511"||obj[i].dm=="512"||obj[i].dm=="552"||obj[i].dm=="114"||obj[i].dm=="115"||obj[i].dm=="123"){
                               idType.model.append({text:obj[i].ct, code:obj[i].dm})
                                if(obj[i].dm=="111"){
                                    //默认不自动填充
                                    idType.currentIndex = selected
                                    idType.currentText = obj[i].ct
                                    cardIndex=selected
                                }
                                selected++
                            }
//                            if (obj[i].zdbh == "KX_D_CYZJDM"){
//                                var temp = {}
//                                temp.text = obj[i].ct
//                                temp.code = obj[i].dm
//                                idTypeOriginalList.push(temp)
//                                if(obj[i].dm=="111"){
//                                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm,obj[i].ct)
//                                    idType.text = obj[i].ct
//                                    idTypeCode = obj[i].dm
//                                }
//                            }
                        }
                        //常用证件
//                        idTypeList=idTypeOriginalList
//                        idChangeData.json=JSON.stringify(idTypeList)
//                        idTypeJson=idChangeData.json
                    }
                }
            }else{
                console.log('查询实有房屋_房主信息失败')
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


    //小键盘调用************************

    idType.onCurrentTextChanged: {
        if(isOwner){
            if(idType.currentIndex!=-1){
                emit:backOwerRelationChanged(idType.model.get(idType.currentIndex).code,"idType")
            }
        }
    }

    //证件号码A
//    idNumber.onCursorVisibleChanged:{
//        if(idNumber.cursorVisible){
//            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
//                qmlData.startVkeyBoard()
//            }
//        }else{
//            getFocus.focus = true
//        }
//    }

//    idNumber.onTextChanged: {
//        if(isOwner)
//            emit:backOwerRelationChanged(idNumber.text,"idNumber")
//    }

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
    owerName.onTextChanged: {
         if(isOwner)
            emit:backOwerRelationChanged(owerName.text,"owerName")
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
    phoneNumber.onTextChanged: {
        if(isOwner)
            emit:backOwerRelationChanged(phoneNumber.text,"phoneNumber")
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
    foreignSur.onTextChanged: {
       if(isOwner)
            emit:backOwerRelationChanged(foreignSur.text,"foreignSur")
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
    foreignName.onTextChanged: {
       if(isOwner)
            emit:backOwerRelationChanged(foreignName.text,"foreignName")
    }
    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            fillInfo()
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            //console.log("============="+PAGEDATA)
        }
//        onSendPageUabled:{
//           cadeEnabled=status
//           //status?colorR=  "#FFFFFF":colorR= "#F2F2F4"
//        }

        onInitInfoMsg:{
            if(casecadeName == "OwnerInfoPage") //瀑布流界面发送来的二代证扫描信息
            {
                //如果选中的不是居民身份证 则切换成居民身份证
                if(idType.currentText != "居民身份证")
                {
                    for(var i=0;i<idType.model.count;i++){
                        if(idType.model.get(i).code=="111"){
                            idType.currentIndex = i
                            idType.currentText = idType.model.get(i).text
                        }
                    }
                }

                idNumber.text = initInfo.idcard
                owerName.text = initInfo.name
            }
//            else if(casecadeName == "BaseInfoPage"){ // 基础信息模块传递回来的 是否出租房屋信息
//                if(initInfo == "否"){ //不是出租房屋 房主证件种类不默认选则
//                    clearAll()
////                    idType.currentIndex = -1
////                    idType.currentText = ""
//                }
//                else if(initInfo == "是"){//是出租房屋 房主证件种类默认选则"居民身份证"
//                    idType.currentIndex =cardIndex
//                    idType.currentText =idType.model.get(cardIndex).text
//                }
//            }
        }
        onOwerRelationChanged:{
            fillInfo()
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            emit:backOwerRelationChanged(PAGEDATA,"all")
        }

        //点空白区域 所有下拉框回收
        onComponentRecovery:{
            getFocusComboBox.focus = true
        }

        onFinishToEveryControl:{//清空所有
            clearAll()
        }
    }
    function fillInfo(){
        if(idType.currentIndex!=-1)
        pageDataJsonObject.fz_cyzjdm = idType.model.get(idType.currentIndex).code//房主证件种类
        pageDataJsonObject.fz_zjhm =idNumber.text  //房主证件号码
        pageDataJsonObject.fz_xm =owerName.text  //房主姓名
        pageDataJsonObject.fz_lxdh =phoneNumber.text  //房主联系电话
        pageDataJsonObject.fz_wwx =foreignSur.text  //房主外文姓
        pageDataJsonObject.fz_wwm =foreignName.text  //房主外文名
    }

    function clearAll(){
        //房主证件种类
        idType.currentIndex = cardIndex
        idType.currentText = idType.model.get(cardIndex).text
        //pageDataJsonObject.fz_cyzjdm = idTypeCode
        idNumber.text=""  //房主证件号码
        owerName.text=""  //房主姓名
        phoneNumber.text=""  //房主联系电话
        foreignSur.text=""  //房主外文姓
        foreignName.text=""  //房主外文名
        owerName.cursorVisible=false
        foreignSur.cursorVisible=false
        foreignName.cursorVisible=false
    }
}

