import QtQuick 2.4

SystemSetPointPageForm {
    property bool ishavebayonet :false     //临时判断变量
    property var bayonetlist: []           //临时存放卡口数据list
    property var bayonetAllList: []        //包括单位在内的所有卡点信息list
    property string bayonetjson: ""  //原始的卡点数 据
    property bool  kdExit:false     //判断配置文件中卡点是否存在

    Component.onCompleted: {

        pointType.text =locationLevel
        jurisdictionUnit.text =locationUnit

        jingdu.text=latitude
        weidu.text=longitude

        if(online){//在线
            bayonetTypeData.clear()
            bayonetTypeData.append({text: locationName,
                                    code: locationId,
                                   level: locationLevel,
                                    unit: locationUnit})
            pointNameBox.currentIndex = 0
            getPoint()
        }else{//离线
            pointName.text = locationName
        }
    }

    //获取卡点相关信息
    function getPoint(){
         var datajson={
             "currentPage": 1,
             "currentResult": 0,
             "entityOrField": true,
             "pageStr": "string",
             "pd": {},
             "showCount": 9999,
             "totalPage": 0,
             "totalResult": 0
           }
        //正式接口
        var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/data-service/data/getCheckPointListForClient"
        //局域网接口
        //var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/data/getCheckPointListForClient"
        //写死局域网测试接口
        //var url="http://172.19.12.147:8888/data/getCheckPointListForClient"
         console.log("卡点设置界面开始获取卡点列表"+url)
         console.log("卡点设置界面发送的datajson"+JSON.stringify(datajson))
         operatehttp.post(url,function(code, data){
             if(code==200||code==0){
                 console.log("获取的所有卡点信息"+data)
                 var obj = JSON.parse(data)
                 if(obj.result.list != undefined && obj.result.list.length > 0){//有卡点信息
                     var currentName = ""
                     var currentId = -1
                     bayonetTypeData.clear()
                     pointNameBox.currentText = currentName
                     pointNameBox.currentIndex = currentId

                     for(var i=0;i<obj.result.list.length;i++){
                         bayonetTypeData.append({text: obj.result.list[i].checkpoint_name,
                                                 code: obj.result.list[i].id,
                                                level: obj.result.list[i].checkpoint_level_text,
                                                 unit: obj.result.list[i].checkpoint_unit_text})
                         if(locationId!==""){
                             if(obj.result.list[i].id == locationId){
                                 currentId = i
                                 currentName = obj.result.list[i].checkpoint_name
                                 kdExit=true
                             }
                         }
                     }
                     if(!kdExit){
                         locationName=""
                         locationId=""
                         locationLevel=""
                         locationUnit=""
                         operateconfigfile.setLocationName("")
                         operateconfigfile.setLocationId("")
                         operateconfigfile.setTypeName("")
                         operateconfigfile.setUnitName("")
                     }

                     pointNameBox.currentIndex = currentId
                     pointNameBox.currentText = obj.result.list[currentId].checkpoint_name

                 }
                 else{
                    console.log("obj.result.list == undefined || obj.result.list.length < 0")
                 }
             }
             else{
                 console.log(code+"到后台获取卡点信息查询失败")
             }
         },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
     }

    pointNameBox.onCurrentIndexChanged: {
        jurisdictionUnit.text=bayonetTypeData.get(pointNameBox.currentIndex).unit
        pointType.text=bayonetTypeData.get(pointNameBox.currentIndex).level

    }

    finish.onClicked:{

        if((online && pointNameBox.currentText == "")
         ||(!online && pointName.text == "")){
            messagebox.text = "卡点名称不可以为空"
            messagebox.visible = true
            return
        }

        locationName = online ? bayonetTypeData.get(pointNameBox.currentIndex).text : pointName.text
        locationId = online ? bayonetTypeData.get(pointNameBox.currentIndex).code : ""
        locationLevel = online ? bayonetTypeData.get(pointNameBox.currentIndex).level : ""
        locationUnit = online ? bayonetTypeData.get(pointNameBox.currentIndex).unit : ""

        operateconfigfile.setLocationName(locationName)
        operateconfigfile.setLocationId(locationId)
        operateconfigfile.setTypeName(locationLevel)
        operateconfigfile.setUnitName(locationUnit)

        if(online){
            getTaskInfo()
        }else{
            emit: finishTask()
            stackView.pop()
        }
    }

    function getTaskInfo(){
            //1、后台获取任务列表(包括任务名称，时间，任务码)，将任务码存起来
            //2、到go服务要盘查历史，也就是日常任务的数量 需要传两个参数 (日常任务码 type) 后台可以把盘查历史放在最后一项
            var datajson={
                "currentPage": 1,
                "currentResult": 0,
                "entityOrField": true,
                "pageStr": "string",
                "pd": {},
                "showCount": 9999,
                "totalPage": 0,
                "totalResult": 0
              }
            //正式接口
            var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/data-service/data/getExamineTaskListForClient"
            //局域网接口
            //var url="http://"+operateconfigfile.getRemoteIP()+":"+operateconfigfile.getRemotePort()+"/data/getExamineTaskListForClient"
            //写死局域网测试接口
            //var url="http://172.19.12.147:8888/data/getExamineTaskListForClient"

            console.log("卡点设置界面开始获取任务列表"+url)
            console.log("卡点设置界面发送的datajson"+JSON.stringify(datajson))
            operatehttp.post(url,function(code, data){
                if(code==200||code==0){
                    var obj = JSON.parse(data)
                    checkpointTaskId=[]
                    if(data!=""){
                        //console.log("卡点设置界面获取到的所有卡点任务信息"+data)
                        var obj = JSON.parse(data)
                        if(obj.result.checkpointTaskList!=undefined){
                            for(var i=0;i<obj.result.checkpointTaskList.length;i++){
                                 console.log(obj.result.checkpointTaskList[i].checkpoint_id)
                                if(locationId==obj.result.checkpointTaskList[i].checkpoint_id){
                                   checkpointTaskId.push(obj.result.checkpointTaskList[i].id)
                                }
                            }
                        }
                    }
                    checkpointTaskId.push(taskDialy)
                    //console.log("更改卡点后所有该卡点下的任务ID"+JSON.stringify(checkpointTaskId))
                    emit: finishTask()
                    stackView.pop()
                }
                else{
                    console.log(code+"卡点界面到后台获取当前任务码查询失败")
                    console.log(token)
                    emit: finishTask()
                    stackView.pop()
                }
            },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

}
