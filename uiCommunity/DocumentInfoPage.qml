import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealPerson.js"  as ThreeRealPerson
import QtMultimedia 5.4


//实有人员模块---证件信息

DocumentInfoPageForm {
    property var pageDataJsonObject:ThreeRealPerson.getJbxx()
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json
    property int idcardMode: 0        //身份证变化的方式 是扫描还是手输 扫描1  ocr识别2  无证无号也走0 默认手输为0
    property int cardIndex: 0         //证件种类默认inxdex
    Audio{
        id: readCardSound
        source: "qrc:/sounds/sounds/readCard.wav"
    }
    Component.onCompleted:{
        flagModel.clear()
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            if(PAGEDATA != undefined){//传过来的是个数组
                var obj=JSON.parse(PAGEDATA)
                cardNo.text=obj.zjhm
                name.text=obj.xm
                birth.text=obj.csrq
                address.text=obj.hjd_dzms
            }
        }
        var url = 'http://'+goIpPort+'/sy/syTypeDict/[KX_D_CYZJDM,GB_D_XBDM,GB_D_MZDM]'          //(常用证件/性别/民族)
           //console.log("url:"+url)
           operatehttp.get(url, function(code, data){
            if(code == 200){
                if(data != ""){
                    var obj = JSON.parse(data)
                    //console.log("基础信息数据"+obj.length+data)
                    idType.model.clear()//常用证件
                    sex.model.clear()//性别
                    nation.model.clear()//民族
                    //console.log("obj.length"+obj.length)
                    for(var i=0;i<obj.length;i++){
                        //console.log("obj[i].zdbh"+i+obj[i].zdbh)
                        if (obj[i].zdbh == "KX_D_CYZJDM")//常用证件
                        {
                            idType.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(obj[i].dm=="111"){
                                 idType.currentIndex = i
                                 idType.currentText = obj[i].ct
                                 cardIndex=i
                             }
                        }
                        if (obj[i].zdbh == "GB_D_XBDM")//性别
                        {
                            sex.model.append({text:obj[i].ct, code:obj[i].dm})
                        }
                        if (obj[i].zdbh == "GB_D_MZDM")//民族
                        {
                            nation.model.append({text:obj[i].ct, code:obj[i].dm})
//                            if(obj[i].dm=="1"){
//                                nation.currentIndex = i
//                                nation.currentText = obj[i].ct
//                            }
                        }
                    }
                    sex.currentIndex =-1
                    sex.currentText = ""
                    nation.currentIndex =-1
                    nation.currentText = ""
                }
            }else{

                console.log("查询实有人员_证件信息数据失败："+code)
            }
        })
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE || PAGEMODE == QmlData.VISIT_TYPE_MODIFY){
            birth.hint = ''
            cadeEnabled = false
            readIdcard.stopIdcardIdentification()
        }
        else{
            readIdcard.startIdcardIdentification(documentDir+"/read.bmp")
       }
    }
    //二代证采集-ocr识别
    idcardCollection.onClicked: {
        var isAtt=false
        for(var i=0;i<idType.model.count ;i++){
            if(idType.currentText==idType.model.get(i).text){
                console.log("------------")
                console.log(idType.currentText)
                console.log(idType.model.get(i).text)
                console.log(idType.model.get(i).code)
                if(idType.model.get(i).code=="111"){//证件种类为身份证时跳转到ocr识别界面
                    isAtt=true
                }
            }
        }
        if(isAtt){
            getFocus.focus = true
            stackView.push("qrc:/singleFunction/ui/IDCardIdentificationPage.qml")
        }else{
            messagebox.text = '证件种类请切换到身份证再进行二代证采集'
            messagebox.visible = true
        }
    }
    //点击在线核查按钮
    onLineCheckBtn.onClicked: {
        emit: sendCheckSig(cardNo.text, name.text)
    }

    //监测身份证号变化，符合身份证号格式时发送消息，瀑布流会接收此消息并对此身份证号进行查询
    cardNo.onTextChanged: {
        if(idType.currentText=="居民身份证"){
            if(JSL.isCardNo(cardNo.text)){//是正确的身份证号 发送消息
                if(idcardMode==0 && PAGEMODE != QmlData.VISIT_TYPE_SEE){ //手动输入身份证号
                    //自动填充性别
                    var sexNum = Number(cardNo.text.substring(16, 17))
                    var sexT=""
                    sexNum%2 == 0 ? sexT = "女" : sexT = "男"
                    for(var i=0;i<sex.model.count ;i++){
                        if(sexT==sex.model.get(i).text){
                            sex.currentIndex = i
                            sex.currentText =sexT
                        }
                    }
                    birth.text = cardNo.text.substring(6, 10) + '年' + cardNo.text.substring(10, 12) + '月' + cardNo.text.substring(12, 14) + '日'
                }

                fillInfo()
                queryConditionFillFinished(pageDataJsonObject, "IDcardPage",idcardMode)
                idcardMode=0

            }else{
                onLineCheckBtn.visible = false
            }
        }
    }

    address.onTextChanged: {
        emit:addressTogether(address.text)//证件户籍地址和基本信息户籍地址描述保持一致
    }
    //小键盘调用************************
    //证件号码
    cardNo.onCursorVisibleChanged:{
        if(cardNo.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }

    //姓名
    name.onCursorVisibleChanged:{
        if(name.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }

    //住址
    address.onCursorVisibleChanged:{
        if(address.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    /***************************日期控件调用*****************************/
    birth.onCursorVisibleChanged:{
        if(birth.cursorVisible){
            datePage.visible=true
            dataCallName="birth"
        }
    }

    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            fillInfo()
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            if(qmlData.isContainKey(idcardImg.source,"file:")){
                xpObject.photo = qmlData.cutStr(idcardImg.source, 8, 0)
            }
            else if(qmlData.isContainKey(idcardImg.source,'http')){
                xpObject.photo =idcardImg.source.toString()
            }
            else{
                xpObject.photo = ""
            }
        }
        onIdcardDentificationFinish:{ //二代证OCR识别结束
            if(idType.currentText=="居民身份证"){//证件种类为身份证时跳转到ocr识别界面
                idcardMode=2
                cardNo.text = ''
                idcardImg.source = ''
                sex.currentIndex = -1
                sex.currentText =""
                nation.currentIndex = -1
                nation.currentText =""
                idcardImg.source= cardInfo.photo
                name.text    = cardInfo.name
                //性别、民族为下拉框需要判断
                for(var i=0;i<sex.model.count ;i++){
                    if(cardInfo.sex==sex.model.get(i).text){
                        sex.currentIndex = i
                        sex.currentText = cardInfo.sex
                    }
                }
                var len=""
                for(var i=0;i<nation.model.count ;i++){
                    len=nation.model.get(i).text
                    console.log(qmlData.cutStr(nation.model.get(i).text,0,len.length-1))
                    if(cardInfo.nation== qmlData.cutStr(nation.model.get(i).text,0,len.length-1)){
                        nation.currentIndex = i
                        nation.currentText = nation.model.get(i).text
                    }
                }
                birth.text   = cardInfo.birth
                address.text = cardInfo.address
                cardNo.text  = cardInfo.idcard
                name.cursorVisible=false
            }
         }
        //显示查询结果消息响应事件 将瀑布流传过来的查询结果以标签形式显示到界面
        onShowQueryResult:{
        //queryResult 显示内容 casecadeName 接受消息的页面名称 isClearRet 是否清除原有数据
            if(casecadeName == "IDcardPage"){
                if(isClearRet){
                    flagModel.clear()
                }
                if(queryResult.result != null){
                    var color = ''
                    if(queryResult.result.tags.length!=0){
                        var count = 0
                        for(var i=0; i<queryResult.result.tags.length; i++){
                            if(queryResult.result.tags[i].property=='111001'){
                                color = '#F8A053'
                                count++
                            }else{
                                color = 'green'
                            }
                            flagModel.append({FLAGNAME:queryResult.result.tags[i].text, FLAGCOLOR: color})
                        }
                        if (count>0){
                            emit: checkException('IDcardPage', true)
                        }else{
                            emit: checkException('IDcardPage', false)
                        }
                    }
                    else{
                        color = 'green'
                        emit: checkException('IDcardPage', false)
                        flagModel.append({FLAGNAME:"通过", FLAGCOLOR: color})
                    }
                }
            }
        }
        onShowPersonOnlineBtnOther:{//显示在线核查按钮
            onLineCheckBtn.visible=true
        }
        onInitInfoMsg:{
            if(casecadeName == "IDcardPage"){
                name.text   =""
                nation.currentIndex =-1
                address.text=""
                idcardImg.source= ""
                idcardImg.source ="qrc:/images/images/none_people.png"
                var obj=JSON.parse(initInfo)
                console.log("手动输入身份证号查询返回到人的基础信息"+initInfo)
                if(obj.result.infos != null)
                {
                    if(obj.result.infos.length > 0)
                    {
                        //cardInfo_sex.text    = obj.result[0].XB
                        name.text = obj.result.infos[0].XM
                        for(var i=0;i<nation.model.count ;i++){
                            if(obj.result.infos[0].MZ==nation.model.get(i).text){
                                nation.currentIndex = i
                                nation.currentText = obj.result.infos[0].MZ
                            }
                        }
                        if(obj.result.infos[0].ZZXZ != undefined){
                            address.text = obj.result.infos[0].ZZXZ
                        }
                        if(obj.result.infos[0].XP!=undefined){
                             if(obj.result.infos[0].XP!=""){
                                console.log("手动输入身份证号查回照片"+ "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                            +"/img/"+qmlData.splitStr(obj.result.infos[0].XP,"/",4))
                                idcardImg.source= ""
                                idcardImg.source= "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                        +"/img/"+qmlData.splitStr(obj.result.infos[0].XP,"/",4)
                             }else{
                                 idcardImg.source= ""
                                 idcardImg.source ="qrc:/images/images/none_people.png"
                             }
                        }else{
                            idcardImg.source= ""
                            idcardImg.source ="qrc:/images/images/none_people.png"
                        }
                    }
                }
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
        onSendToCallPage:{
            switch(name){
                case "birth"://信息采集
                  birth.text=qmlData.splitStr(dataStr,"-",0)+"年"+qmlData.splitStr(dataStr,"-",1)+"月"+qmlData.splitStr(dataStr,"-",2)+"日"
                    break
            }
        }

        onFinishToEveryControl:{//清空所有           
            cardNo.text=""
            name.text=""
            birth.text=""
            address.text=""
            name.cursorVisible=false
            address.cursorVisible=false
            flagModel.clear()
            idcardImg.source="qrc:/images/images/none_people.png"
            sex.currentIndex = -1
            sex.currentText = ""
            nation.currentIndex = -1
            nation.currentText = ""
            idType.currentIndex =cardIndex
            idType.currentText =idType.model.get(cardIndex).text
        }
    }
    //二代证扫描结束
    Connections{
        target: readIdcard
        onReadIdcardFinished: {
            if(idType.currentText=="居民身份证"){//证件种类为身份证时
                idcardMode=1
                readCardSound.play()
                console.log(idcardInformation)
                var TemJson = JSON.parse(idcardInformation)
                cardNo.text = ''
                name.text =TemJson.name
                birth.text = TemJson.birth
                //性别、民族为下拉框需要判断
                for(var i=0;i<sex.model.count ;i++){
                    if(TemJson.sex==sex.model.get(i).text){
                        sex.currentIndex = i
                        sex.currentText = TemJson.sex
                    }
                }
                var len=""
                for(var i=0;i<nation.model.count ;i++){
                    len=nation.model.get(i).text
                    console.log(qmlData.cutStr(nation.model.get(i).text,0,len.length-1))
                    if(TemJson.nation== qmlData.cutStr(nation.model.get(i).text,0,len.length-1)){
                        nation.currentIndex = i
                        nation.currentText = nation.model.get(i).text
                    }
                }
                if(cardNo.text != TemJson.idcard){
                    idcardImg.source = ""
                }
                address.text = TemJson.address
                idcardImg.source = "file:///" + TemJson.face
                cardNo.text = TemJson.idcard
            }else{
                messagebox.text = '证件种类请切换到身份证再进行二代证采集'
                messagebox.visible = true
            }
        }

    }

    function fillInfo(){
        //证件种类
        if(idType.currentIndex!=-1)
            pageDataJsonObject.cyzjdm =idType.model.get(idType.currentIndex).code
        //证件号码
        pageDataJsonObject.zjhm =cardNo.text
        //姓名
        pageDataJsonObject.xm =name.text
        //性别
        if(sex.currentIndex!=-1)
            pageDataJsonObject.xbdm =sex.model.get(sex.currentIndex).code
        //出生日期
        if(birth.text!=""){
            if(birth.text.indexOf("年")){
                pageDataJsonObject.csrq = qmlData.cutStr(birth.text,0,4)+"-"+qmlData.cutStr(birth.text,5,2)+"-"+qmlData.cutStr(birth.text,8,2)
            }else{
                pageDataJsonObject.csrq =birth.text
            }
        }
        //民族
        if(nation.currentIndex!=-1)
            pageDataJsonObject.mzdm =nation.model.get(nation.currentIndex).code

        //户籍地址描述
        pageDataJsonObject.hjd_dzms =address.text
    }
}
