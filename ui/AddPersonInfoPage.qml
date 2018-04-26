import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/PatrolInquiriesJson.js" as CLB_OBJECT

//添加车辆相关人界面----维稳核查车中使用

AddPersonInfoPageForm {
    property var    carRelateds:[]    //人车关系数组
    property string preDocumentID:""  //记录最开始进来时的档案编号，因为添加车辆人员需要创建新的档案编号
    property string preDocumentDir:"" //记录最开始进来时的档案编号目录，因为添加车辆人员需要创建新的档案编号
    property string relationship:""   //记录选择的人车关系

    property string relationCarId:''           //同车人ID--安庆使用
    property int commonIndex: -1 //当前数据类型

    Component.onCompleted: {
        infoModel.clear()
        preDocumentID = documentID
        preDocumentDir = documentDir
        if(PAGEDATA != undefined){//传过来的是个数组
            var obj=JSON.parse(PAGEDATA)
            for(var i=0; i<obj.length; i++){
                //用档案编号查询人员具体信息
                getPersonInfo(obj[i].optargetId, obj[i].relationship)
            }
        }
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            addPersonInfoBtn.enabled=false
            isvisible=false
            isEnabled = false
        }

        //安庆版本 同车在同行人处应该有展示
        relationCarId = qmlData.makeOptargetId()
    }

    addPersonInfoBtn.onClicked: {
        getFocus.focus = true
        popWindow.visible = true
    }

    passenger.onClicked: {
        relationship = '乘客'
        pushPage()
    }

    driver.onClicked: {
        relationship = '驾驶员'
        if(findIsHaveChecked(relationship)){
            popWindowAlert.popupWindowTitle = "已添加过【"+relationship+"】，是否继续添加？"
            popWindowAlert.visible = true
            driver.checked=false
        }else{
            pushPage()
        }
    }

    function pushPage(){
        driver.checked = false
        passenger.checked = false
        popWindow.visible = false
        popWindowAlert.visible = false
        builDocument()

        switch(PAGETYPE){
        case QmlData.INTO_TYPE_AQT_CAR:
            stackView.push({item:"qrc:/wholeFunction/ui/AQTPersionPage.qml",
                            properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                                        colloctType:QmlData.INTO_TYPE_AQT_PERSION,
                                        isSaveInfo:false}})
            break;
        case QmlData.INTO_TYPE_CAR:
              stackView.push({item:"qrc:/wholeFunction/ui/MaintenanceCheckingPersionPage.qml",
                              properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                                          colloctType:QmlData.INTO_TYPE_PERSON,
                                          entryPage:"AddPersonInfoPage",
                                          isSaveInfo:false,
                                          carDocumentID:preDocumentID,
                                          carRelationship:relationship}})
            break;
         case QmlData.INTO_TYPE_POINTCARD_CAR:
//            if(PAGELAST=="PointCheckingCarPage"){
                 stackView.push({item:"qrc:/wholeFunction/ui/PointCheckingPersonPage.qml",
                                 properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                                             colloctType:QmlData.INTO_TYPE_POINTCARD_PERSION,
                                             entryPage:"AddPersonInfoPage",
                                             isSaveInfo:false,
                                             carDocumentID:preDocumentID,
                                             carRelationship:relationship}})
//             }else{
//                 stackView.push({item:"qrc:/wholeFunction/ui/MaintenanceCheckingPersionPage.qml",
//                                 properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
//                                             colloctType:QmlData.INTO_TYPE_POINTCARD_PERSION,
//                                             entryPage:"AddPersonInfoPage",
//                                             isSaveInfo:false}})
//             }

            break;
         case QmlData.INTO_TYPE_CAR_RICH://巡逻盘查--庆安版

             stackView.push({item:"qrc:/wholeFunction/ui/PatrolRichPersionPage.qml",
                             properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
                                         colloctType:QmlData.INTO_TYPE_PERSON_RICH,
                                         entryPage:"AddPersonInfoPage",
                                         isSaveInfo:false,
                                         relationCarId:relationCarId}})
            break;
        }


    }

    //判断曾经是否选择过此项关系
    function findIsHaveChecked(relationName){
        for(var i=0; i<infoModel.count; i++){
            if(relationName == infoModel.get(i).ROW2){ //以前选择过
                return true
            }
        }
        return false
    }

    //添加过驾驶员或者乘客并决定继续添加该橘色
    isAddBtn.onClicked: {
        pushPage()
    }
    noAddBtn.onClicked: {
        popWindowAlert.visible = false
    }
    onDeletePersonClicked:{
        console.log(index)
        commonIndex=index
        addPersonInfoRec.enabled =false
        popWindowDelete.visible = true
    }

    Connections{
        target: mainQml

        onFillInfoMsg:{//信息填充消息响应事件
            if(wholeFunctionName=="AddPersonInfoPage"||wholeFunctionName=="AQTCarPage"){
                carRelateds=[]
                documentID = preDocumentID
                documentDir = preDocumentDir
                for(var i=0; i<infoModel.count; i++){
                    var carRelatedsItem = CLB_OBJECT.getCarRelateds()//人车关系数组元素
                    carRelatedsItem.relationship = infoModel.get(i).ROW2
                    carRelatedsItem.optargetId = infoModel.get(i).relationJson
                    carRelateds.push(carRelatedsItem)
                }
                PAGEDATA = JSON.stringify(carRelateds)
            }
        }

        onFinishTask:{//人员信息添加完成           
            //go提供通过档案编号查询档案信息的接口
            getPersonInfo(documentID, relationship)

            //置为车辆档案编号
            documentID = preDocumentID
            documentDir = preDocumentDir
        }
        onClearAllData:{
            infoModel.clear()
        }
    }

    //通过档案编号查询人员信息
    function getPersonInfo(docId, relationship){
        var url='http://'+goIpPort+"/findArchives/"+docId
        operatehttp.get(url, function(code, data){
            if(code === 200){
                var obj = JSON.parse(data)
                var objData = JSON.parse(obj[0].Data)//再转一次
                infoModel.append({IMG:getPhotoPathSignal(objData.idcardInfo.photo),
                                  ROW1:getName(objData.idcardInfo.name),
                                  ROW2:relationship,
                                  ROW3:objData.idcardInfo.idcard,
                                  relationJson:docId})

            }else{
                console.log('根据档案编号查询人员信息失败:'+code)
            }
        })
    }

    //取照片
    function getPhotoPath(photoPathList){
        if(typeof(photoPathList)=="undefined"){
            return isX6 ? 'qrc:/images/imagesX6/txrxx.png': 'qrc:/images/images/renyuan.png'
        }
        var tempPhotoPath = ''
        if(photoPathList.length > 0 && photoPathList[0] != ''){
            if(qmlData.isContains(photoPathList[0], 'http')){ //网络路径
                tempPhotoPath = photoPathList[0]
            }else{
                tempPhotoPath = 'file:///' + photoPathList[0]
            }
        }else{
            tempPhotoPath = isX6 ? 'qrc:/images/imagesX6/txrxx.png': 'qrc:/images/images/renyuan.png'
        }

        return tempPhotoPath
    }

    function getPhotoPathSignal(photoPath){
        var tempPhotoPath = ''
        if(photoPath!= ''){
            if(qmlData.isContains(photoPath, 'http')){ //网络路径
                tempPhotoPath = photoPath
            }else{
                tempPhotoPath = 'file:///' + photoPath
            }
        }else{
             tempPhotoPath =isX6 ? 'qrc:/images/imagesX6/txrxx.png': 'qrc:/images/images/renyuan.png'
        }

        return tempPhotoPath
    }


    //取名字
    function getName(name){
        if(JSL.strRealLength(name) > 16){
            if(JSL.isChinese(name)){
                return JSL.subStringFromTo(name, 0, 8)+'...'
            }
            else{
                return JSL.subStringFromTo(name, 0, 16)+'...'
            }

        }else{
            return name
        }
    }
}
