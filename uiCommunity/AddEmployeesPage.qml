import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/collectJson/js/ThreeRealJson.js" as ThreeRealJson

//添加从业人员---社区采集中使用

AddEmployeesPageForm {
    property var    relatedsList:[]
    property string relationship:''

    Component.onCompleted: {
        infoModel.clear()
        if(PAGEDATA != undefined){//传过来的是个数组
            var obj=JSON.parse(PAGEDATA)
            for(var i=0; i<obj.length; i++){
                //用档案编号查询人员具体信息
                getPersonInfo(obj[i].optargetId, obj[i].relationship)
            }
        }
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            addPersonInfoBtn.enabled = false
            enabledDel = false
        }
    }
    addPersonInfoBtn.onClicked: {
       emit: addBtnClicked(PAGENAME)
    }

    Connections{
        target: mainQml
        onInitInfoMsg:{
            if(casecadeName == 'AddEmployeesPage'){
                infoModel.clear()
                var obj = JSON.parse(initInfo)
                if(obj != null){
                    for(var i=0; i<obj.length; i++){
                        var objData = JSON.parse(obj[i].Data)//再转一次
                        infoModel.append({IMG:getPhotoPathSignal(objData.idcardInfo.photo),
                                          ROW1:objData.idcardInfo.name,
                                          ROW2:objData.idcardInfo.sex,
                                          ROW3:objData.idcardInfo.idcard,
                                          relationJson:JSON.stringify(obj[i])})
                    }
                }
            }
        }
        onFillInfoMsg:{
            if(wholeFunctionName == "ThreeRealUnitPersionPage"){
                for(var i=0; i<infoModel.count; i++){
                    var    pageDataJsonObject = ThreeRealJson.getBuildingRelateds()
                    var obj = JSON.parse(infoModel.get(i).relationJson)
                    pageDataJsonObject.optargetId = obj.OptargetId
                    relatedsList.push(pageDataJsonObject)
                }
                PAGEDATA = JSON.stringify(relatedsList)
            }
        }
    }
    //取照片
    function getPhotoPath(photoPathList){
        if(typeof(photoPathList)=="undefined"){
            return 'qrc:/images/images/renyuan.png'
        }
        var tempPhotoPath = ''
        if(photoPathList.length > 0 && photoPathList[0] != ''){
            if(qmlData.isContains(photoPathList[0], 'http')){ //网络路径
                tempPhotoPath = photoPathList[0]
            }else{
                tempPhotoPath = 'file:///' + photoPathList[0]
            }
        }else{
            tempPhotoPath = 'qrc:/images/images/renyuan.png'
        }

        return tempPhotoPath
    }

    function getPhotoPathSignal(photoPath){
        var tempPhotoPath = ''
        if(photoPath != ''){
            if(qmlData.isContains(photoPath, 'http')){ //网络路径
                tempPhotoPath = photoPath
            }else{
                tempPhotoPath = 'file:///' + photoPath
            }
        }else{
            tempPhotoPath = 'qrc:/images/images/none_people.png'
        }

        return tempPhotoPath
    }

    //取通讯方式号码
    function getContactWayNumber(contactWayList){
        var tempPhoneNumber = ''
        for(var j=0; j<contactWayList.length; j++){
            if(contactWayList[j].code == '00'){//通讯类型为手机
                tempPhoneNumber = contactWayList[j].number
                break
            }
        }
        return tempPhoneNumber
    }
    //通过档案编号查询人员信息
    function getPersonInfo(docId, relationship){
        var url='http://'+goIpPort+"/findArchives/"+docId
        operatehttp.get(url, function(code, data){
            if(code === 200){
                var obj = JSON.parse(data)
                var objData = JSON.parse(obj[0].Data)//再转一次
                infoModel.append({IMG:getPhotoPathSignal(objData.idcardInfo.photo),
                                  ROW1:objData.idcardInfo.name,
                                  ROW2:objData.idcardInfo.sex,
                                  ROW3:objData.idcardInfo.idcard,
                                  relationJson:JSON.stringify(obj[0])})
            }else{
                console.log('根据档案编号查询人员信息失败:'+code)
            }
        })
    }
}
