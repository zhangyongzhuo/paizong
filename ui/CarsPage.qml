import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

//车辆信息采集模块---维稳核查山东版、洛阳版、卡口盘查、巡逻盘查中使用

CarsPageForm {
    property var pageDataJsonObject:PublicDataJson.getCarJson()
    property string colorCode:""
    property string colorToText:""
    property var plateType: []
    property var plateAllData: []
    property var carBodyColor: []
    signal carTypeChanged(string carType)
    Component.onCompleted: {
        flagModel.clear()

        //瀑布流传递过来的初始化值
        if(PAGEDATA != undefined){
            console.log("AQT车瀑布流传递过来的初始化值"+PAGEDATA)
            pageDataJsonObject    = JSON.parse(PAGEDATA)
            licensePlateType.currentText  = pageDataJsonObject.licensePlateType
            carColor.text          = pageDataJsonObject.color
            model.text                    = pageDataJsonObject.model
            brand.text                    = pageDataJsonObject.brand
            vinCode.text                  = pageDataJsonObject.vinCode
            owner.text                    = pageDataJsonObject.owner
            ownerTel.text                 = pageDataJsonObject.ownerTel
            engineNumber.text             = pageDataJsonObject.engineNumber
            remarks.text                  = pageDataJsonObject.remark
        }        

        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            page.enabled = false
            onLineCheckBtn.visible = false
            licensePlateNo.text = pageDataJsonObject.licensePlateNo
        }
        else{
            //车牌类型
            var plateTypeUrl = 'http://'+goIpPort+'/v3/newTypeDict/139'
            operatehttp.get(plateTypeUrl, function(code, data){
                if(code == 200){
                    plateTypeData.clear()
                    var obj = JSON.parse(data)
                    for(var i=0;i<obj.length;i++){
                        plateTypeData.append({text:obj[i].name, code:obj[i].code})
                        if(pageDataJsonObject.licensePlateType!=""){
                             if(obj[i].typeValue==pageDataJsonObject.licensePlateType){
                                 licensePlateType.currentIndex=i
                                 licensePlateType.currentText=pageDataJsonObject.licensePlateType
                                 if(PAGEDATA != undefined){
                                      licensePlateNo.text = pageDataJsonObject.licensePlateNo
                                 }
                             }
                        }else{
                            if(obj[i].name=="小型汽车"){
                                licensePlateType.currentIndex=i
                                licensePlateType.currentText="小型汽车"
                                if(PAGEDATA != undefined){
                                     licensePlateNo.text = pageDataJsonObject.licensePlateNo
                                }
                            }
                        }
                    }
                }else{
                    console.log('车牌类型查询失败:'+code)
                }
            })

            //车身颜色
            var colorUrl = 'http://'+goIpPort+'/typeDict/12'
            operatehttp.get(colorUrl, function(code, data){
                if(code == 200){
                    carBodyColor = JSON.parse(data)
                }else{
                    console.log('查询车身颜色失败')
                }
            })
        }
    }

    licensePlateNo.onCursorVisibleChanged: {
        console.log('licensePlateNo.cursorVisible: '+licensePlateNo.cursorVisible)
        if(licensePlateNo.cursorVisible){
            keyboard.visible = true
            keyboard.keyboard.visible = true
        }else{
            keyboard.visible = false
            keyboard.keyboard.visible = false
            getFocus.focus = true
        }
    }

    keyboard.close.onClicked: {
        getFocus.focus = true
    }

    licensePlateType.onCurrentTextChanged: {
        if(JSL.isVehicleNumber(licensePlateNo.text)){//是正确的车牌号 发送消息
            if(PAGEMODE!=QmlData.VISIT_TYPE_SEE){
                // fillInfo()
            }
            pageDataJsonObject.licensePlateNo = licensePlateNo.text
             if(PAGEMODE !== QmlData.VISIT_TYPE_SEE){
                 pageDataJsonObject.licensePlateType =licensePlateType.currentText
                 pageDataJsonObject.licensePlateTypeCode =plateTypeData.get(licensePlateType.currentIndex).code
             }
            queryConditionFillFinished(pageDataJsonObject, "CarPage","")
        }else{
            onLineCheckBtn.visible=false
        }
//        emit: carTypeChanged(licensePlateType.currentText)
    }

//    onCarTypeChanged:{
//        for(var k=0; k<plateAllData.length; k++){
//            if(carType==plateAllData[k].CLLX){//类型匹配
//                var carBodyColorTemp = ''
////                for(var m=0; m<carBodyColor.length; m++){
////                    if(plateAllData[k].CSYS==carBodyColor[m].typeValue){//找到对应颜色Code
////                        carBodyColorTemp = carBodyColor[m].typeValueBase
////                        break
////                    }
////                }
//                carColor.text          = plateAllData[k].CSYS===null ? '' :plateAllData[k].CSYS
//                vinCode.text           = plateAllData[k].CLSBDH===null ? '' :plateAllData[k].CLSBDH
//                model.text             = plateAllData[k].CLXH===null ? '' :plateAllData[k].CLXH
//                brand.text             = plateAllData[k].CLPP1===null ? '' :plateAllData[k].CLPP1
//                owner.text             = plateAllData[k].JDCSYR===null ? '' :plateAllData[k].JDCSYR
//                ownerTel.text          = plateAllData[k].LXFS===null ? '' : plateAllData[k].LXFS
//                engineNumber.text      = plateAllData[k].FDJH===null ? '' :plateAllData[k].FDJH
//                //remarks.text           = plateAllData[k].JDCZT
//            }
//        }
//    }
    Connections{
        target: mainQml
        onSendtocar:{
            if(pageName == PAGENAME){
                if(JSL.isVehicleNumber(licensePlateNo.text)){
                    emit:backtocar(licensePlateNo.text, PAGENAME)
                }else{
                    emit:backtocar("", PAGENAME)
                }
            }
        }

        onCarBaseInfoCheckFinish:{
                    //清空原有数据
                    plateAllData = []
                    //plateType = []
                    //plateTypeData.clear()
                    //licensePlateType.currentText = ''
                    carColor.text          = ''
                    vinCode.text           = ''
                    model.text             = ''
                    brand.text             = ''
                    owner.text             = ''
                    ownerTel.text          = ''
                    engineNumber.text      = ''
                    //解析收到数据

                    var carBaseInfo = JSON.parse(carInfo)
                    if (carBaseInfo.result.infos != null){
                        if(carBaseInfo.result.infos[0].CSYS != undefined){
                           carColor.text          = carBaseInfo.result.infos[0].CSYS===null ? '' : carBaseInfo.result.infos[0].CSYS
                        }
                        if(carBaseInfo.result.infos[0].CLSBDH != undefined){
                            vinCode.text           = carBaseInfo.result.infos[0].CLSBDH===null ? '' : carBaseInfo.result.infos[0].CLSBDH
                        }
                        if(carBaseInfo.result.infos[0].CLXH != undefined){
                            model.text             = carBaseInfo.result.infos[0].CLXH===null ? '' : carBaseInfo.result.infos[0].CLXH
                        }
                        if(carBaseInfo.result.infos[0].CLPP1 != undefined){
                            brand.text             = carBaseInfo.result.infos[0].CLPP1===null ? '' : carBaseInfo.result.infos[0].CLPP1
                        }
                        if(carBaseInfo.result.infos[0].JDCSYR != undefined){
                            owner.text             = carBaseInfo.result.infos[0].JDCSYR===null ? '' : carBaseInfo.result.infos[0].JDCSYR
                        }
                        if(carBaseInfo.result.infos[0].LXFS != undefined){
                            ownerTel.text          = carBaseInfo.result.infos[0].LXFS===null ? '' : carBaseInfo.result.infos[0].LXFS
                        }
                        if(carBaseInfo.result.infos[0].FDJH != undefined){
                            engineNumber.text      = carBaseInfo.result.infos[0].FDJH===null ? '' : carBaseInfo.result.infos[0].FDJH
                        }
                    }
                    if (carBaseInfo.result.tags != null){
                        if(carBaseInfo.result.tags[0].infos[0].CSYS != undefined){
                           carColor.text          = carBaseInfo.result.tags[0].infos[0].CSYS===null ? '' : carBaseInfo.result.tags[0].infos[0].CSYS
                        }
                        if(carBaseInfo.result.tags[0].infos[0].CLSBDH != undefined){
                            vinCode.text           = carBaseInfo.result.tags[0].infos[0].CLSBDH===null ? '' : carBaseInfo.result.tags[0].infos[0].CLSBDH
                        }
                        if(carBaseInfo.result.tags[0].infos[0].CLXH != undefined){
                            model.text             = carBaseInfo.result.tags[0].infos[0].CLXH===null ? '' : carBaseInfo.result.tags[0].infos[0].CLXH
                        }
                        if(carBaseInfo.result.tags[0].infos[0].CLPP1 != undefined){
                            brand.text             = carBaseInfo.result.tags[0].infos[0].CLPP1===null ? '' : carBaseInfo.result.tags[0].infos[0].CLPP1
                        }
                        if(carBaseInfo.result.tags[0].infos[0].JDCSYR != undefined){
                            owner.text             = carBaseInfo.result.tags[0].infos[0].JDCSYR===null ? '' : carBaseInfo.result.tags[0].infos[0].JDCSYR
                        }
                        if(carBaseInfo.result.tags[0].infos[0].LXFS != undefined){
                            ownerTel.text          = carBaseInfo.result.tags[0].infos[0].LXFS===null ? '' : carBaseInfo.result.tags[0].infos[0].LXFS
                        }
                        if(carBaseInfo.result.tags[0].infos[0].FDJH != undefined){
                            engineNumber.text      = carBaseInfo.result.tags[0].infos[0].FDJH===null ? '' : carBaseInfo.result.tags[0].infos[0].FDJH
                        }
                    }
        }

        onBoxAreaOpend:{
            if(page_name!="CarsPage"){
                getFocusComboBox.focus = true
            }
        }       
        onComponentRecovery:{
            getFocusComboBox.focus = true
        }
        onPlateNumberTextChange:{
            licensePlateNo.text += text
        }

        onPlateNumberTextDel:{
            licensePlateNo.text = licensePlateNo.text.substring(0, licensePlateNo.text.length-1)
        }

        onPlateNumberDentificationFinish:{   //车牌号识别完成
            licensePlateNo.text = plateNumber
        }

        onFillInfoMsg:{//信息填充消息响应事件
            pageDataJsonObject.licensePlateType =licensePlateType.currentText
            //pageDataJsonObject.licensePlateTypeCode =plateTypeData.get(licensePlateType.currentIndex).code
            pageDataJsonObject.color = carColor.text
            pageDataJsonObject.model = model.text
            pageDataJsonObject.brand = brand.text
            pageDataJsonObject.vinCode = vinCode.text
            pageDataJsonObject.owner = owner.text
            pageDataJsonObject.ownerTel = ownerTel.text
            pageDataJsonObject.licensePlateNo = licensePlateNo.text
            pageDataJsonObject.engineNumber = engineNumber.text
            pageDataJsonObject.remark = remarks.text
            pageDataJsonObject.colorCode= colorCode
            if(licensePlateType.currentIndex!=-1){
                if(typeof(plateTypeData.get(licensePlateType.currentIndex).code!=undefined)){
                    pageDataJsonObject.licensePlateTypeCode=plateTypeData.get(licensePlateType.currentIndex).code
                }else{
                    pageDataJsonObject.licensePlateTypeCode = 2
                }
            }
            PAGEDATA = JSON.stringify(pageDataJsonObject)
        }
//标签没有时返回的什么样
    onShowQueryResult:{//显示查询结果消息响应事件 将瀑布流传过来的查询结果以标签形式显示到界面
            if(casecadeName == "CarPage"){
                if(isClearRet){
                    flagModel.clear()
                }
                if(queryResult.result.tags != null){//
                    for(var i=0; i<queryResult.result.tags.length; i++){
                        var color = ''
                        if(queryResult.result.tags[i].hasOwnProperty("property")){
                            if(queryResult.result.tags[i].property=='111001'){//坏
                                color = '#F8A053'
                                emit: checkException('CarPage', true)
                            }else{
                                color = 'green'
                                emit: checkException('CarPage', false)
                            }
                        }else{//好
                            if(queryResult.result.tags[i].text=='通过'){
                                color = 'green'
                                emit: checkException('CarPage', false)
                            }else{
                                color = '#F8A053'
                                emit: checkException('CarPage', true)
                            }
                        }
                        flagModel.append({FLAGNAME:queryResult.result.tags[i].text, FLAGCOLOR: color})
                    }
                }
            }
        }
        onCarInfoCheckResult:{
            licensePlateType.currentText = typeof(result.hpzl)!="undefined" ? result.hpzl : ""
            remarks.text = typeof(result.info)!="undefined" ? result.info : ""
            engineNumber.text = typeof(result.fdjh)!="undefined" ? result.fdjh : ""
            model.text = typeof(result.cllx)!="undefined" ? result.cllx : ""
            vinCode.text = typeof(result.cjh)!="undefined" ? result.cjh : ""
            licensePlateNo.text = typeof(result.hphm)!="undefined" ? result.hphm : ""
        }

        onShowCarOnlineBtn:{//显示在线核查按钮
            onLineCheckBtn.visible=true
            checkText=name
        }
        //收到将查询回的车辆信息赋值
        onCarInfoAssignment:{
            carColor.text          = ''
            vinCode.text                  = ''
            model.text                    = ''
            brand.text                    = ''
            owner.text                    = ''
            ownerTel.text                 = ''
            engineNumber.text             = ''
            var obj=JSON.parse(carInfo)
            if(type=="QueryBDQJDC"){
                colorCode=obj.result.CSYS
            }else{
                colorCode=obj.result.Color
            }
            var colorUrl = 'http://'+goIpPort+'/typeDict/12'
            operatehttp.get(colorUrl, function(code, data){
                if(code == 200){
                    var objc = JSON.parse(data)
                    colorToText=JSL.colorTrans(colorCode,objc)
                    console.log('转换过的车的颜色'+colorToText)
                    if(type=="QueryBDQJDC"){
                        carColor.text          = colorToText//obj.result.CSYS
                        vinCode.text                  = obj.result.CLSBDH
                        model.text                    = obj.result.CLLX
                        brand.text                    = obj.result.CLPP
                        owner.text                    = obj.result.SYR
                        ownerTel.text                 = ''
                        engineNumber.text             = obj.result.FDJH
                    }else{
                        carColor.text          = colorToText//obj.result.Color
                        vinCode.text                  = ''
                        model.text                    = obj.result.Clxh
                        brand.text                    = obj.result.ChBrand
                        owner.text                    = obj.result.Owner
                        ownerTel.text                 = ''
                        engineNumber.text             = obj.result.EngineModel
                    }
                    console.log(colorToText)
                }else{
                    console.log('查询颜色失败')
                }
            })
        }
        onClearAllData:{
            carColor.text          = ''
            vinCode.text                  = ''
            model.text                    = ''
            brand.text                    = ''
            owner.text                    = ''
            ownerTel.text                 = ''
            engineNumber.text             = ''
        }

    }

    licensePlateNo.onTextChanged: {
        if(JSL.isVehicleNumber(licensePlateNo.text)){//是正确的车牌号 发送消息
            pageDataJsonObject.licensePlateNo = licensePlateNo.text
            if(PAGEMODE!=QmlData.VISIT_TYPE_SEE){
                pageDataJsonObject.licensePlateType =licensePlateType.currentText
                pageDataJsonObject.licensePlateTypeCode =plateTypeData.get(licensePlateType.currentIndex).code
                // fillInfo()
            }            
            queryConditionFillFinished(pageDataJsonObject, "CarPage","")
        }else{
            onLineCheckBtn.visible=false
        }
    }

    carNumberShotBtn.onClicked: {
        stackView.push("qrc:/singleFunction/ui/CarIdentificationPage.qml")
    }

    onLineCheckBtn.onClicked: {
        emit: carInfoOnlineCheck(licensePlateNo.text,plateTypeData.get(licensePlateType.currentIndex).code)
    }    
}
