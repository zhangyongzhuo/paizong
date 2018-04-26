import QtQuick 2.4
import "qrc:/collectJson/js/ThreeRealRoom.js"  as ThreeRealJson
LessorInfoPageForm {
    property var pageDataJsonObject:ThreeRealJson.getCzfwxxb()
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json
    property int cardIndex: 0         //证件种类默认inxdex

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
                            if(obj[i].dm=="111"){
//                                idType.currentIndex = i
//                                idType.currentText = obj[i].ct
                                cardIndex=i
                            }
                        }
                        if (obj[i].zdbh == "XZ_D_CZFWRYGXDM")//与房主关系
                        {
                            relationOwer.model.append({text:obj[i].ct, code:obj[i].dm})
                        }
                    }
                    relationOwer.currentIndex = -1
                    relationOwer.currentText =""
                }
            }else{
                    console.log("查询实有房屋_出租人信息失败："+code)
            }
        })
    }

    //小键盘调用************************
    //证件号码
    idNumber.onCursorVisibleChanged:{
        if(idNumber.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
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
                idType.currentIndex = cardIndex
                idType.currentText = idType.model.get(cardIndex).text
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

    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            if( relationOwer.currentIndex!=-1)
                pageDataJsonObject.czur_yfzgx_rygxdm =relationOwer.model.get(relationOwer.currentIndex).code//当sfczfw为1时该项必填	出租人与房主关系>>zdbh: XZ_D_CZFWRYGXDM
            if(idType.currentIndex!=-1)
                pageDataJsonObject.czur_cyzjdm = idType.model.get(idType.currentIndex).code//

            pageDataJsonObject.czur_zjhm =idNumber.text  //当sfczfw为1时该项必填	出租人证件号码
            pageDataJsonObject.czur_xm =owerName.text //当sfczfw为1时该项必填	出租人姓名
            pageDataJsonObject.czur_lxdh =phoneNumber.text   //当sfczfw为1时该项必填	出租人联系电话
            pageDataJsonObject.czur_wwx =foreignSur.text  //出租人外文姓
            pageDataJsonObject.czur_wwm =foreignName.text //出租人外文名
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            //console.log("============="+PAGEDATA)
        }
        onSendPageUabled:{
            cadeEnabled=status
            status?colorR=  "#FFFFFF":colorR= "#F2F2F4"
            if(status){
                idType.currentIndex =cardIndex
                idType.currentText =idType.model.get(cardIndex).text

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
                idType.currentIndex = -1
                idType.currentText = ""

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

        onFinishToEveryControl:{//清空所有
            clearAll()
            relationOwer.currentIndex = -1
            relationOwer.currentText = ""
            idType.currentIndex = -1
            idType.currentText = ""
//            idType.currentIndex =cardIndex
//            idType.currentText =idType.model.get(cardIndex).text
//            relationOwer.currentIndex = -1
//            relationOwer.currentText = ""
//            idNumber.text ="" //	出租人证件号码
//            owerName.text=""  //出租人姓名
//            phoneNumber.text =""   //	出租人联系电话
//            foreignSur.text =""  //出租人外文姓
//            foreignName.text=""  //出租人外文名
//            owerName.cursorVisible=false
//            foreignSur.cursorVisible=false
//            foreignName.cursorVisible=false
        }



        onInitInfoMsg:{
            if(casecadeName == "LessorInfoPage") //瀑布流界面发送来的二代证扫描信息
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
                    //先录入房主信息 然后录入出租人信息 这时候判断一下录入的房主信息和出租人信息身份证号是否相同 相同则默认选择房主本人
                    //emit:owerRelationChanged()

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
    }

    function clearAll(){
        idNumber.text ="" //	出租人证件号码
        owerName.text=""  //出租人姓名
        phoneNumber.text =""   //	出租人联系电话
        foreignSur.text =""  //出租人外文姓
        foreignName.text=""  //出租人外文名
        owerName.cursorVisible=false
        foreignSur.cursorVisible=false
        foreignName.cursorVisible=false
    }

}

