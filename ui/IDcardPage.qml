import QtQuick 2.4
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

//模块对外响应信息填充消息，接收到该消息后将界面中所有的字段赋转成Json字符串赋值给PAGEDATA
////信息填充消息:               fillInfoMsg("")
//模块对外提供查询条件填充完成消息 queryConditionFillFinished(var queryCondition, string casecadeName,int idcardMode)//查询条件填充完成（身份证界面为身份证号，车辆界面为车牌号，房屋界面为地址）
//模块对外响应显示查询结果消息    showQueryResult(var queryResult, string casecadeName)//显示查询结果

IDcardPageForm {
    property var pageDataJsonObject:PublicDataJson.getIdcardJson()
    property string onlineCheckUrl: ""
    property string proIdcard: ""
    property int onlineCheckMode: -1
    property int idcardMode: 0        //身份证变化的方式 是扫描还是手输 扫描1  ocr识别2  无证无号也走0 默认手输为0

    Audio{
        id: readCardSound
        source: "qrc:/sounds/sounds/readCard.wav"
    }

  Component.onCompleted: {

        //如果设置了无证无号访问网址，则改变控件高度 并显示按钮
        if(undocumentUrl==""){
            defaultHeight=178
            collectonVisble=false
        }
        else{
            defaultHeight=230
            collectonVisble=true
        }

        flagModel.clear()
        //瀑布流传递过来的初始化值
        if(PAGEDATA != undefined){
            //console.log("瀑布流传递过来的初始化值"+PAGEDATA)
            pageDataJsonObject    = JSON.parse(PAGEDATA)
            cardInfo_name.text    = pageDataJsonObject.name
            cardInfo_sex.text     = pageDataJsonObject.sex
            cardInfo_nation.text  = pageDataJsonObject.nation
            cardInfo_birth.text   = pageDataJsonObject.birth
            cardInfo_address.text = pageDataJsonObject.address

            if(pageDataJsonObject.photo == "" || pageDataJsonObject.photo == undefined){
                faceImg.source =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
            }
            else if(qmlData.isContains(pageDataJsonObject.photo, 'http')){
                faceImg.source = pageDataJsonObject.photo
            }
            else{
                faceImg.source = "file:///"+pageDataJsonObject.photo
            }

            cardInfo_idcard.text  = pageDataJsonObject.idcard
        }
        if(PAGETYPE_SD == "SD"){
            cardInfo_birth.hint = ''
            cardInfo_idcard.enabled = false
            readIdcard.stopIdcardIdentification()
        }
        //修改及查看模式下状态下身份证基础信息不允许改变
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE || PAGEMODE == QmlData.VISIT_TYPE_MODIFY){
            cardInfo_birth.hint = ''
            cadeEnabled = false
            readIdcard.stopIdcardIdentification()
        }
        else{
            if(PAGELAST=="PointCheckingPersonPage"){
                //console.log("读取身份证保存的位置"+ qmlData.makeRootDir()+"/../app-data/CollectData"+"/read.bmp")
                readIdcard.startIdcardIdentification( qmlData.makeRootDir()+"/../app-data/CollectData"+"/read.bmp")
            }else{
                readIdcard.startIdcardIdentification(documentDir+"/read.bmp")
            }
       }
    }

    //信息填充消息响应事件
    Connections{
        target: mainQml

        //信息填充消息响应事件
        onFillInfoMsg:{
            fillInfo()
            PAGEDATA = JSON.stringify(pageDataJsonObject)
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

        onClearAllData:{
            if(pagename!="IDcardPage"){
                //cardInfo_sex.text    =""
                cardInfo_name.text   =""
                cardInfo_nation.text=""
                //cardInfo_birth.text =""
                cardInfo_address.text=""
                faceImg.source= ""
            }
        }

        onIdcardDentificationFinish:{ //二代证OCR识别结束
            idcardMode=2
            cardInfo_idcard.text = ''
            faceImg.source = ''
            //}
            faceImg.source        = cardInfo.photo
            cardInfo_name.text    = cardInfo.name
            cardInfo_sex.text     = cardInfo.sex
            cardInfo_nation.text  = cardInfo.nation
            cardInfo_birth.text   = cardInfo.birth
            cardInfo_address.text = cardInfo.address
            cardInfo_idcard.text  = cardInfo.idcard
        }
        onUndocumentFinish:{
           idcardMode=0
           cardInfo_idcard.text  = card
//           cardInfo_name.text    = name
//           if(photo!=""){
//               faceImg.source = photo
//           }else{
//               faceImg.source =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
//           }
//           var obj=JSON.parse(initInfo)
//           if(obj.result != null){

//               cardInfo_sex.text    = obj.result[0].XB

//               cardInfo_nation.text  = obj.result[0].MZ
//               cardInfo_birth.text   = obj.result[0].CSRQ
//               if(obj.result[0].ZZXZ != undefined){
//                   cardInfo_address.text = obj.result[0].ZZXZ
//               }
//           }
        }

        onInitInfoMsg:{
            if(casecadeName == "IDcardPage"){
               //cardInfo_sex.text    =""
                cardInfo_name.text   =""
                cardInfo_nation.text=""
               //cardInfo_birth.text =""
                cardInfo_address.text=""
                faceImg.source= ""
                faceImg.source =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                var obj=JSON.parse(initInfo)
                console.log("手动输入身份证号查询返回到人的基础信息"+initInfo)
                if(obj.result.infos != null)
                {
                    if(obj.result.infos.length > 0)
                    {
                        //cardInfo_sex.text    = obj.result[0].XB
                        cardInfo_name.text = obj.result.infos[0].XM
                        cardInfo_nation.text = obj.result.infos[0].MZ
                        //cardInfo_birth.text   = obj.result[0].CSRQ
                        if(obj.result.infos[0].ZZXZ != undefined){
                            cardInfo_address.text = obj.result.infos[0].ZZXZ
                        }
                        if(obj.result.infos[0].XP!=undefined){
                             if(obj.result.infos[0].XP!=""){
                                console.log("手动输入身份证号查回照片"+ "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                            +"/img/"+qmlData.splitStr(obj.result.infos[0].XP,"/",4))
                                faceImg.source= ""
                                faceImg.source= "http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()
                                        +"/img/"+qmlData.splitStr(obj.result.infos[0].XP,"/",4)
                             }else{
                                 faceImg.source= ""
                                 faceImg.source =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                             }
                        }else{
                            faceImg.source= ""
                            faceImg.source =isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
                        }
                    }
                }
            }
        }

        onIdcardInfoCheckResult:{
            var temp
            if(typeof(result.photo)!="undefined" && result.photo!=null){
                faceImg.source = "file:///"+qmlData.transformBase642Image(result.photo, documentDir+"/face_net.jpg")
            }else{
                faceImg.source = isX6 ? "qrc:/images/imagesX6/sfz.png":"qrc:/images/images/sfzn.png"
            }
            cardInfo_name.text    = (typeof(result.xm)!="undefined" && result.xm!=null) ? result.xm : ""
            cardInfo_sex.text     = (typeof(result.xb)!="undefined" && result.xb!=null) ? result.xb : ""
            cardInfo_nation.text  = (typeof(result.mz)!="undefined" && result.mz!=null) ? result.mz : ""
            cardInfo_birth.text   = (typeof(result.csrq)!="undefined" && result.csrq!=null) ? result.csrq : ""
            cardInfo_address.text = (typeof(result.jg)!="undefined" && result.jg!=null) ? result.jg : ""
            //cardInfo_idcard.text  = typeof(result.sfzhm)!="undefined" ? result.sfzhm : ""
        }

        onShowPersonOnlineBtn:{//显示在线核查按钮
            onLineCheckBtn.visible=true
            checkText=name
        }
        onSendtocar:{
            if(pageName == PAGENAME){
                if(JSL.isCardNo(cardInfo_idcard.text)){
                    emit:backtocar(cardInfo_idcard.text, PAGENAME)
                }else{
                    emit:backtocar("", PAGENAME)
                }
            }
        }

        onDigiTextChange: {
            if(cardInfo_idcard.cursorVisible){
                cardInfo_idcard.text += text
            }
        }
        onDigiTextDel: {
            if(cardInfo_idcard.cursorVisible){
                cardInfo_idcard.text = cardInfo_idcard.text.substring(0, cardInfo_idcard.text.length-1)
            }
        }
    }
    onLineCheckBtn.onClicked: {
        emit: sendCheckSig(cardInfo_idcard.text, cardInfo_name.text)
    }

    idcardCollectonBtn.onClicked: {
        getFocus.focus = true
        stackView.push("qrc:/singleFunction/ui/IDCardIdentificationPage.qml")
    }

    cardInfo_birth.onCursorVisibleChanged: {
        if(cardInfo_birth.cursorVisible == true){
            cardInfo_birth.hint=''
        }else{
            cardInfo_birth.hint='日期:1979年01月01日'
        }
    }

    //二代证扫描结束
    Connections{
        target: readIdcard
        onReadIdcardFinished: {
            if(PAGELAST=="PointCheckingPersonPage"){
                console.log("二代证扫描结束把身份证照片拷贝到各自档案编号目录")
//                console.log(qmlData.makeRootDir()+"/../app-data/CollectData"+"/read.bmp")
//                console.log(documentDir+"/read.bmp")
                qmlData.copyFileToPath(qmlData.makeRootDir()+"/../app-data/CollectData"+"/read.bmp",documentDir+"/read.bmp",true)
            }
            idcardMode=1
            readCardSound.play()
            var TemJson = JSON.parse(idcardInformation)
            cardInfo_idcard.text = ''
            cardInfo_name.text =TemJson.name
            cardInfo_sex.text = TemJson.sex
            cardInfo_birth.text = TemJson.birth
            cardInfo_nation.text = TemJson.nation
            if(cardInfo_idcard.text != TemJson.idcard){
                faceImg.source = ""
            }
            cardInfo_address.text = TemJson.address
            if(PAGELAST=="PointCheckingPersonPage"){
               faceImg.source = "file:///" +documentDir+"/read.bmp"
            }else{
               faceImg.source = "file:///" + TemJson.face
            }

            //faceImg.source = "file:///" + TemJson.face
            cardInfo_idcard.text = TemJson.idcard
        }
    }

    //监测身份证号变化，符合身份证号格式时发送消息，瀑布流会接收此消息并对此身份证号进行查询
    cardInfo_idcard.onTextChanged: {
        if(JSL.isCardNo(cardInfo_idcard.text)){//是正确的身份证号 发送消息
            if(idcardMode==0 && PAGEMODE != QmlData.VISIT_TYPE_SEE){ //手动输入身份证号
                //自动填充性别
                var sexNum = Number(cardInfo_idcard.text.substring(16, 17))
                sexNum%2 == 0 ? cardInfo_sex.text = "女" : cardInfo_sex.text = "男"
                //console.log("自动填充性别---------------"+sexNum%2)
                //自动填充生日 230104198901283122
                cardInfo_birth.text = cardInfo_idcard.text.substring(6, 10) + '年' + cardInfo_idcard.text.substring(10, 12) + '月' + cardInfo_idcard.text.substring(12, 14) + '日'
            }

            fillInfo()
            queryConditionFillFinished(pageDataJsonObject, "IDcardPage",idcardMode)
            idcardMode=0

        }else{
            onLineCheckBtn.visible = false
        }
    }

    cardInfo_idcard.onCursorVisibleChanged:{
        if(!isX6){
            cardInfo_idcard.cursorVisible ? digiBoard.visible=true : digiBoard.visible=false
        }
    }

    function fillInfo(){
        pageDataJsonObject.idcard  = cardInfo_idcard.text
        pageDataJsonObject.name    = cardInfo_name.text
        pageDataJsonObject.sex     = cardInfo_sex.text
        pageDataJsonObject.nation  = cardInfo_nation.text
        pageDataJsonObject.birth   = cardInfo_birth.text
        pageDataJsonObject.address = cardInfo_address.text

        if(qmlData.isContainKey(faceImg.source,"file:")){
            pageDataJsonObject.photo = qmlData.cutStr(faceImg.source, 8, 0)
        }
        else if(qmlData.isContainKey(faceImg.source,'http')){
            pageDataJsonObject.photo =faceImg.source.toString()
        }
        else{
            pageDataJsonObject.photo = ""
        }
    }
}
