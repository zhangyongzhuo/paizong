import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealJson.js" as ThreeRealJson

//添加户界面---社区采集中使用

WholeRoomPageForm {
    property var    buildingRelateds:[]    //人户关系数组
    property string relationship:""   //记录选择的人户关系
    property string preDocumentID:""  //记录最开始进来时的档案编号，因为子户人员需要创建新的档案编号
    property string preDocumentDir:"" //记录最开始进来时的档案编号目录，因为子户人员需要创建新的档案编号
    property var tempList:[]          //临时存放人户关系的
    property bool isHaveRelationship:false
    property var  model_temp
    Component.onCompleted: {
        preDocumentID = documentID
        preDocumentDir = documentDir
        wholeRoomModel.clear()
        //console.log("人户关系界面初始data"+PAGEDATA)
        if(PAGEDATA != undefined && PAGEDATA != ''){
            var obj=JSON.parse(PAGEDATA)
            for(var i=0; i<obj.length; i++){
                if(tempList.length==0){
                    tempList.push(obj[i].relationship)
                }else{
                    for(var j=0; j<tempList.length; j++){
                        if(obj[i].relationship==tempList[j]){
                            isHaveRelationship=true
                        }
                    }
                    if(isHaveRelationship){
                        isHaveRelationship=false
                    }else{
                        tempList.push(obj[i].relationship)
                    }
                }
            }

            if(tempList.length>2){
                wholeRoomView.height=810
                PAGEHEIGHT=900
            }else{
                var temp=tempList.length*270
                wholeRoomView.height=temp
                PAGEHEIGHT=temp+90
            }
            for(var k=0; k<tempList.length; k++){
                 wholeRoomModel.append( {WholeRoomJson: "" })
            }
            for(var n=0; n<obj.length; n++){
                if(obj[n].optargetId!=""){
                    getPersonInfo(obj[n].optargetId, obj[n].relationship)
                }
            }
        }
    }
    addRoom.onClicked: {
        getFocus.focus = true

       if(wholeRoomModel.count<5){
           var temp=wholeRoomModel.count*270+270
           if(wholeRoomModel.count<3){
               wholeRoomView.height=temp
               PAGEHEIGHT=temp+90
           }

           wholeRoomModel.append( {WholeRoomJson: "" })
       }else{
           messagebox.text = "最多可添加五户"
           messagebox.visible = true
       }
    }
    Connections{
        target: mainQml

        onFillInfoMsg:{//信息填充消息响应事件
            if(wholeFunctionName == "ThreeRealRoomPage"){
                buildingRelateds=[]
                documentID = preDocumentID
                documentDir = preDocumentDir
                for(var i=0; i<wholeRoomModel.count; i++){
                    if(wholeRoomModel.get(i).roomJson!=undefined){
//                        console.log(wholeRoomModel.get(i).roomJson)
                        for(var j=0; j<JSON.parse(wholeRoomModel.get(i).roomJson).length; j++){
                            var buildingRelatedsItem = ThreeRealJson.getBuildingRelateds()//人户关系数组元素
                            buildingRelatedsItem.relationship = "户"+i//JSON.parse(wholeRoomModel.get(i).roomJson)[j].ROW4
                            buildingRelatedsItem.optargetId =   JSON.parse(wholeRoomModel.get(i).roomJson)[j].ROW5
                            buildingRelateds.push(buildingRelatedsItem)
                        }
                    }else{
                        var buildingRelatedsItem = ThreeRealJson.getBuildingRelateds()//人户关系数组元素
                        buildingRelatedsItem.relationship = "户"+i//JSON.parse(wholeRoomModel.get(i).roomJson)[j].ROW4
                        buildingRelatedsItem.optargetId =   ""
                        buildingRelateds.push(buildingRelatedsItem)
                    }
                }
                PAGEDATA = JSON.stringify(buildingRelateds)
                console.log("存储的人户关系"+PAGEDATA)
            }
        }
        onFinishRoomTask:{
            getPersonInfo(id, relationship)

            //置为车辆档案编号
            documentID = preDocumentID
            documentDir = preDocumentDir
        }

//        onFinishTask:{//户人员信息添加完成
//            //go提供通过档案编号查询档案信息的接口
//            getPersonInfo(documentID, relationship)

//            //置为车辆档案编号
//            documentID = preDocumentID
//            documentDir = preDocumentDir
//        }
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


    //通过档案编号查询人员信息
    function getPersonInfo(docId, relationship){
        var url='http://'+goIpPort+"/findArchives/"+docId
        operatehttp.get(url, function(code, data){
            if(code === 200){
                var obj = JSON.parse(data)                
                var objData = JSON.parse(obj[0].Data)//再转一次
                //wholeRoomModel.get(1).model=model_t
                var json=  {
                                "IMG": getPhotoPathSignal(objData.idcardInfo.photo),
                                "ROW1": objData.idcardInfo.name,
                                "ROW2": objData.idcardInfo.sex,
                                "ROW3": objData.idcardInfo.idcard,
                                "ROW4": relationship,
                                "ROW5": docId,
                                "relationJson":JSON.stringify(obj[0])
                 }
                 var tempList=[]
                 var oldlist=[]

                if(relationship=="户0"){
                   if(wholeRoomModel.get(0).roomJson!=undefined){

                       oldlist=JSON.parse(wholeRoomModel.get(0).roomJson)
                       for(var i=0;i<oldlist.length;i++){
                           tempList.push(oldlist[i])
                       }
                       tempList.push(json)
                       wholeRoomModel.get(0).roomJson=JSON.stringify(tempList)
                   }else{
                       tempList.push(json)
                       wholeRoomModel.get(0).roomJson=JSON.stringify(tempList)
                   }
                }
                if(relationship=="户1"){
                    if(wholeRoomModel.get(1).roomJson!=undefined){
                        oldlist=JSON.parse(wholeRoomModel.get(1).roomJson)
                        for(var i=0;i<oldlist.length;i++){
                            tempList.push(oldlist[i])
                        }
                        tempList.push(json)
                        wholeRoomModel.get(1).roomJson=JSON.stringify(tempList)
                    }else{
                        tempList.push(json)
                        wholeRoomModel.get(1).roomJson=JSON.stringify(tempList)
                    }
                }
                if(relationship=="户2"){
                    if(wholeRoomModel.get(2).roomJson!=undefined){
                        oldlist=JSON.parse(wholeRoomModel.get(2).roomJson)
                        for(var i=0;i<oldlist.length;i++){
                            tempList.push(oldlist[i])
                        }
                        tempList.push(json)
                        wholeRoomModel.get(2).roomJson=JSON.stringify(tempList)
                    }else{
                        tempList.push(json)
                        wholeRoomModel.get(2).roomJson=JSON.stringify(tempList)
                    }
                }
                if(relationship=="户3"){
                    if(wholeRoomModel.get(3).roomJson!=undefined){
                        oldlist=JSON.parse(wholeRoomModel.get(3).roomJson)
                        for(var i=0;i<oldlist.length;i++){
                            tempList.push(oldlist[i])
                        }
                        tempList.push(json)
                        wholeRoomModel.get(3).roomJson=JSON.stringify(tempList)
                    }else{
                        tempList.push(json)
                        wholeRoomModel.get(3).roomJson=JSON.stringify(tempList)
                    }
                }
                if(relationship=="户4"){
                    if(wholeRoomModel.get(4).roomJson!=undefined){
                        oldlist=JSON.parse(wholeRoomModel.get(4).roomJson)
                        for(var i=0;i<oldlist.length;i++){
                            tempList.push(oldlist[i])
                        }
                        tempList.push(json)
                        wholeRoomModel.get(4).roomJson=JSON.stringify(tempList)
                    }else{
                        tempList.push(json)
                        wholeRoomModel.get(4).roomJson=JSON.stringify(tempList)
                    }
                }

            }else{
                console.log('根据档案编号查询人员信息失败:'+code)
            }
        })
    }

}
