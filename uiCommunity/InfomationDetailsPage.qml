import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL

InfomationDetailsPageForm {
    property int nPageSerialNumber: 1 //进入界面的模式
    property int nPageNumberType:1    //界面模式类型（模式为暂住，类型为户或人）
    property bool selectAll: false  //全选还是不全选 全选为true 不全选为false 初始为不全选
    property bool isDeleting: false  //是否正在删除
    property string taskCodeEvery:"" //当前任务码
    property string dataJson:""
    property int taskdiff:0
    property int yearCurrent:0
    property int monthCurrent:0
    property int dayCurrent:0
    property int hourCurrent:0
    property int minuteCurrent:0
    property bool startorEnd: true    //判断开始还是结束日期
    property bool startorEndTime: true    //判断开始还是结束时间
    //property var sendToGo:[] //当为暂住盘查户时 发送给go的档案编号数组


    Component.onCompleted: {
        var currentDate = new Date()
        yearCurrent = currentDate.getFullYear()
        monthCurrent = currentDate.getMonth()+1
        dayCurrent = currentDate.getDate()
        hourCurrent = currentDate.getHours()
        minuteCurrent = currentDate.getMinutes()
        taskDiff=taskdiff
        if(dayCurrent<10){
            if(monthCurrent<10){
                startDataTime.textLeft=yearCurrent+"-"+0+monthCurrent+"-"+0+dayCurrent
            }else{
                startDataTime.textLeft=yearCurrent+"-"+monthCurrent+"-"+0+dayCurrent
            }
        }else{
            if(monthCurrent<10){
                startDataTime.textLeft=yearCurrent+"-"+0+monthCurrent+"-"+dayCurrent
            }else{
                startDataTime.textLeft=yearCurrent+"-"+monthCurrent+"-"+dayCurrent
            }
        }
        startDataTime.textRight="00:00"
        if(dayCurrent<10){
            if(monthCurrent<10){
                endDataTime.textLeft=yearCurrent+"-"+0+monthCurrent+"-"+0+dayCurrent
            }else{
                endDataTime.textLeft=yearCurrent+"-"+monthCurrent+"-"+0+dayCurrent
            }
        }else{
             if(monthCurrent<10){
                 endDataTime.textLeft=yearCurrent+"-"+0+monthCurrent+"-"+dayCurrent
             }else{
                 endDataTime.textLeft=yearCurrent+"-"+monthCurrent+"-"+dayCurrent
             }
        }
        if(minuteCurrent<10){
            if(hourCurrent<10){
                endDataTime.textRight=0+hourCurrent+":"+0+minuteCurrent
            }else{
                endDataTime.textRight=hourCurrent+":"+0+minuteCurrent
            }
        }else{
             if(hourCurrent<10){
                endDataTime.textRight=0+hourCurrent+":"+minuteCurrent
             }else{
                endDataTime.textRight=hourCurrent+":"+minuteCurrent
             }
        }
        startDateStr=startDataTime.textLeft
        startTimeStr= startDataTime.textRight
        endDateStr=endDataTime.textLeft
        endTimeStr=endDataTime.textRight


        infoModel.clear()
        if(taskCodeEvery==""){//传进任务ID
        //        if(nPageSerialNumber==QmlData.INTO_TYPE_AQT_PERSION||nPageSerialNumber==QmlData.INTO_TYPE_AQT_CAR){
        //            export_button.visible=true
        //        }else{
        //              export_button.visible=false
        //        }
            busyIndicator.running = true
            messagebox.text = '数据正在加载，请稍候...'
            messagebox.visible = true
            //获取一天内盘查数据列表
            getDataListLy()
        }else{
            //已获取过一天内盘查数量列表，直接加载
            showInfoList(dataJson)
        }
        allStatisticNum(0)
    }

    Connections{
        target: mainQml
        onDeleteTask:{
            //改成搜索列表
            if(!JSL.isContainSpecialCharacter(searchKey)){//不包含特殊字符
                    getSearchDataList(searchKey)
            }else{
                messagebox.text = "搜索关键字不可包含特殊字符"
                messagebox.visible = true
            }
        }
    }

    onInformationDetailsItemClicked:{
        if(checkVisible){
            infoModel.get(index).ISCHECK=!infoModel.get(index).ISCHECK
            return
        }

        switch(nPageSerialNumber){

//        case QmlData.INTO_TYPE_THREEREAL_PERSION:          //三实-人员
//            stackView.push({item: "qrc:/wholeFunction/ui/ThreeRealPersonPage.qml",
//                               properties:{entryPageMode:QmlData.VISIT_TYPE_SEE,
//                                   colloctType:QmlData.INTO_TYPE_THREEREAL_PERSION,
//                                   initJson: infoModel.get(index).JSON }})
//            break
//        case QmlData.INTO_TYPE_THREEREAL_UNIT://三实 - 实有单位
//            stackView.push({item:"qrc:/wholeFunction/ui/ThreeRealUnitPage.qml",
//                      properties:{entryPageMode:QmlData.VISIT_TYPE_SEE,
//                                  colloctType:QmlData.INTO_TYPE_THREEREAL_UNIT,
//                                  initJson: infoModel.get(index).JSON}})
//            break
//        case QmlData.INTO_TYPE_THREEREAL_ROOM://三实 - 实有房屋

//            stackView.push({item:"qrc:/wholeFunction/ui/ThreeRealRoomPage.qml",
//                      properties:{entryPageMode:QmlData.VISIT_TYPE_SEE,
//                                  colloctType:QmlData.INTO_TYPE_THREEREAL_ROOM,
//                                  initJson: infoModel.get(index).JSON}})
//            break
        case QmlData.INTO_TYPE_POINTCARD_PERSION:       //卡点盘查-人
            stackView.push({item: "qrc:/wholeFunction/ui/PointCheckingPersonPage.qml",
                               properties:{entryPageMode:QmlData.VISIT_TYPE_SEE,
                                   colloctType:QmlData.INTO_TYPE_POINTCARD_PERSION,
                                   initJson: infoModel.get(index).JSON }})
            break
        case QmlData.INTO_TYPE_POINTCARD_CAR:          //卡点盘查-车
            stackView.push({item: "qrc:/wholeFunction/ui/PointCheckingCarPage.qml",
                               properties:{entryPageMode:QmlData.VISIT_TYPE_SEE,
                                   colloctType:QmlData.INTO_TYPE_POINTCARD_CAR,
                                   initJson: infoModel.get(index).JSON }})
        }
    }

    onInformationDetailsDeleteCheckedChange:{
        for(var j=0; j< infoModel.count; j++){
            if(!infoModel.get(j).ISCHECK){
                break;
            }
        }

        if(j >= infoModel.count){
            select_button.checked = true
        }else{
            select_button.checked = false
        }
    }

    searchBtn.onClicked: {//xuyaopanduan
        var searchKey = JSL.Trim(searchCondition.text, 'g')
        if(startDataTime.textLeft==''||startDataTime.textRight==''){
            messagebox.text = '搜索时请填写完整开始时间 '
            messagebox.visible = true
            return true
        }
        if(endDataTime.textLeft==''||endDataTime.textRight==''){
            messagebox.text = '搜索时请填写完整结束时间 '
            messagebox.visible = true
            return true
        }

        if(!JSL.isContainSpecialCharacter(searchKey)){//不包含特殊字符
            if(busyIndicator.running === false){
                busyIndicator.running=true
                getSearchDataList(searchKey)
            }else{
                messagebox.text = "正在进行搜索，请稍候再试"
                messagebox.visible = true
            }
        }else{
            messagebox.text = "搜索关键字不可包含特殊字符"
            messagebox.visible = true
        }
    }

    edit_button.onClicked: {
        checkVisible=true
        edit_button.visible = false
        delete_button.visible = true
        select_button.visible = true
    }

    delete_button.onClicked: {

        var count = 0
        for(var j=0; j< infoModel.count; j++){
            if(infoModel.get(j).ISCHECK){
                count++
            }
        }

        if(count>0)
        {
            popWindowDelete.popupWindowTitle="是否删除所选择的 "+count+" 条数据？"
            popWindowDelete.visible = true
            detailInfo.enabled = false
        }else{
            //checkVisible=false
            //select_button.visible = false
            //edit_button.visible = true
            //delete_button.visible = false
            messagebox.text = "请选择要删除项"
            messagebox.visible = true
        }
    }

    isDeleteBtn.onClicked: {
        isDeleting = true
        busyIndicator.running = true
        popWindowDelete.visible = false
        detailInfo.enabled = true

        var sendToGo = {
            "deleteId":[],
            "dirPath":"",
            "deleteType":""
        }

        sendToGo.dirPath = qmlData.makeRootDir()+"/../app-data/CollectData"

        if(nPageNumberType == QmlData.INTO_TYPE_SHACK_PERSION){//删除户下人
            sendToGo.deleteType = QmlData.INTO_TYPE_FLOW
        }else{
            sendToGo.deleteType = nPageSerialNumber
        }

        for(var j=0; j< infoModel.count; j++){
            if(infoModel.get(j).ISCHECK){//被选中的                                             //删除普通人和车
                 sendToGo.deleteId.push(infoModel.get(j).OptargetId)
            }
        }

        //console.log("--------删除传参："+JSON.stringify(sendToGo))

        //var url="http://"+goIpPort+"/deleteInfo/" +JSON.stringify(sendToGo)
        var url="http://"+goIpPort+"/deleteInfo"
        operatehttp.post(url, function(code, data){
            if(code == 200){
                messagebox.text = "删除成功"
                messagebox.visible = true
                var searchKey = JSL.Trim(searchCondition.text, 'g')
                if(searchKey==""){
                    getSearchDataList(searchKey)
                }else{
                    if(!JSL.isContainSpecialCharacter(searchKey)){//不包含特殊字符
                        getSearchDataList(searchKey)
                    }
                }
                allStatisticNum(1)
            }else{
                console.log("根据档案编号删除数据失败:"+code)
            }
            isDeleting = false
            busyIndicator.running = false
            checkVisible=false
            select_button.visible = false
            select_button.checked = false
            edit_button.visible = true
            delete_button.visible = false

        },"(0)="+JSON.stringify(sendToGo))
    }

    noDeleteBtn.onClicked: {
        popWindowDelete.visible = false
        detailInfo.enabled = true
    }

    select_button.onClicked: {
        checkVisible=true
        if(select_button.checked){
            for(var j=0; j<infoModel.count; j++){
                infoModel.get(j).ISCHECK=true
            }
            select_button.checked = true
        }
        else{
            for(j=0; j< infoModel.count; j++){
                infoModel.get(j).ISCHECK=false
            }
            select_button.checked = false
        }

    }
    export_button.onClicked: {
        //等待go导出接口
    }

    backBtn.onClicked:{
        if(isDeleting){
            messagebox.text = "正在删除，请稍后"
            messagebox.visible = true
            return
        }

        if(checkVisible){
            checkVisible = false
            select_button.visible = false
            select_button.checked = false
            edit_button.visible = true
            delete_button.visible = false

            for(var j=0; j< infoModel.count; j++){
                infoModel.get(j).ISCHECK=false
            }
        }
        else{
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") == 1){
                qmlData.killTaskl("VkeyBoard.exe")
            }
            emit: finishTask()
            stackView.pop()
        }
    }

    searchCondition.onCursorVisibleChanged:{
        if(searchCondition.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }

    //删除该户下所有人包括数据库 本地collect
    function deleteRelationIdData(otherCode){
        var url='http://'+goIpPort+'/relationIdData/'+otherCode
        operatehttp.get(url, function(code, data){
            if(code == 200){
//                var dataObj = JSON.parse(data)
//                var sendToGo={
//                    "optargetId":[]
//                }

//                for(var i=dataObj.length-1; i>=0; i--){
//                    qmlData.deleteOptargetIdDir("/CollectData/"+dataObj[i].optargetId)
//                    sendToGo.optargetId.push(dataObj[i].optargetId)
//                }
                var obj = JSON.parse(data)
                var sendToGo={
                    "optargetId":[]
                }
                for(var i=0; i<obj.length; i++){
                    var dataObj = JSON.parse(obj[i].Data)
                    qmlData.deleteOptargetIdDir("/CollectData/"+dataObj.optargetId)
                    sendToGo.optargetId.push(dataObj.optargetId)
                }

                var url="http://"+goIpPort+"/clearOptargetId/" +JSON.stringify(sendToGo)
                //console.log("要删除的url"+url)
                //发送给go通过档案编号删除数据库
                operatehttp.get(url, function(code, data){
                    if(code == 200){
                        emit: deleteTask()
                    }else{
                        console.log("根据档案编号删除数据失败:"+code)
                    }
                })
            }else{
                console.log("查询同户信息失败："+code)
            }
        })
    }


 //取照片
    function getPhotoPath(photoPathList){
        if(typeof(photoPathList)=="undefined"){
            return ''
        }
        var tempPhotoPath = ''
        if(photoPathList.length > 0 && photoPathList[0] != ''){
            if(qmlData.isContains(photoPathList[0], 'http')){ //网络路径
                tempPhotoPath = photoPathList[0]
            }else{
                tempPhotoPath = 'file:///' + photoPathList[0]
            }
        }else{
            switch(nPageSerialNumber){
            case QmlData.INTO_TYPE_PERSON://巡逻盘查人员
            case QmlData.INTO_TYPE_SINKIANG://新疆务工人员
            case QmlData.INTO_TYPE_SHACK://反恐暂住盘查
            case QmlData.INTO_TYPE_FLOW://反恐流动盘查
            case QmlData.INTO_TYPE_AQT_PERSION://AQT_人
            case QmlData.INTO_TYPE_PERSON_RICH://巡逻盘查人--安庆版
                tempPhotoPath = isX6 ?'qrc:/images/imagesX6/lspc_pep.png':'qrc:/images/images/none_people.png'
                break
            case QmlData.INTO_TYPE_CAR://车
            case QmlData.INTO_TYPE_AQT_CAR://AQT_车、
            case QmlData.INTO_TYPE_CAR_RICH://巡逻盘查车--安庆版
                tempPhotoPath = isX6 ?'qrc:/images/imagesX6/lspc_car.png':'qrc:/images/images/none_car.png'
                break
            }
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
            switch(nPageSerialNumber){
                case QmlData.INTO_TYPE_PERSON://巡逻盘查人员
                case QmlData.INTO_TYPE_POINTCARD_PERSION: //卡点盘查-人
                case QmlData.INTO_TYPE_PERSON:
                case QmlData.INTO_TYPE_SHACK_PERSION:
                case QmlData.INTO_TYPE_THREEREAL_UNIT_PERSION:
                case QmlData.INTO_TYPE_THREEREAL_PERSION:
                case QmlData.INTO_TYPE_PERSON_RICH:
                    tempPhotoPath = isX6 ?'qrc:/images/imagesX6/lspc_pep.png':'qrc:/images/images/none_people.png'
                    break
                case QmlData.INTO_TYPE_CAR://车辆盘查
                case QmlData.INTO_TYPE_POINTCARD_CAR://卡点盘查-车
                case QmlData.INTO_TYPE_CAR_RICH://卡点盘查-车
                    tempPhotoPath = isX6 ?'qrc:/images/imagesX6/lspc_car.png':'qrc:/images/images/none_car.png'
                    break
                default:
                    tempPhotoPath = isX6 ?'qrc:/images/imagesX6/lspc_pep.png':'qrc:/images/images/none_people.png'
            }

        }

        return tempPhotoPath
    }

    //取通讯方式号码
    function getContactWayNumber(contactWayList){

        var tempPhoneNumber = ''
        for(var j=0; j<contactWayList.length; j++){
            if(contactWayList[j].code == '00'){//通讯类型为手机
                tempPhoneNumber = contactWayList[j].number
                break;
            }
        }
        return tempPhoneNumber
    }

    //获取名字
    function getName(name){
        //console.log('====:JSL.strRealLength(name):'+JSL.strRealLength(name))
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

    //property string perRelationId : '' //前一次的同行标识
    //获取外框颜色
    function getBorderColor(relationId){
        if(perRelationId != relationId ){//这个同行人暂时未生成颜色

        }
    }

    function showInfoList(data){
        var i=0
        var Dataobject={}
        infoModel.clear()
        var obj = JSON.parse(data)
        if ((obj.Temp_data == null)&&(obj.Peo_data.length == 0)){
            matchNumber=0
            messagebox.text = "无数据"
            messagebox.visible = true
            return
        }
        var roomObj = []
        var persionObj = []
        if(obj.Temp_data != null){
            roomObj = obj.Temp_data     //暂住信息
        }
        if(obj.Peo_data != null){
            persionObj = obj.Peo_data   //人员信息
        }
        switch(nPageSerialNumber){
        case QmlData.INTO_TYPE_THREEREAL_PERSION://三实-人员
            matchNumber=persionObj.length
            for(i=0;i<persionObj.length;i++){
                Dataobject = JSON.parse(persionObj[i].Data)
                var xb=""
                if(Dataobject.jbxx.xbdm=="0"){
                    xb="未知的性别"
                }else if(Dataobject.jbxx.xbdm=="1"){
                    xb="男"
                }else if(Dataobject.jbxx.xbdm=="2"){
                    xb="女"
                }else if(Dataobject.jbxx.xbdm=="3"){
                    xb="女性改（变）为男性"
                }else if(Dataobject.jbxx.xbdm=="4"){
                    xb="男性改（变）为女性"
                }else if(Dataobject.jbxx.xbdm=="4"){
                    xb="未说明的性别"
                }
                 var collectTime=qmlData.cutStr(persionObj[i].CreatedAt, 0, 10)+" "+qmlData.cutStr(persionObj[i].CreatedAt, 11, 8)
                 infoModel.append({IMG:getPhotoPathSignal(Dataobject.xp.photo),
                                      ISSHOWUPLOAD:persionObj[i].IsUpload,
                                      SHOWTEXTTITLE:"",
                                      SHOWTEXT:'',
                                      ROW1:Dataobject.jbxx.xm,//getName(Dataobject.idcardInfo.name),
                                      ROW2:Dataobject.jbxx.zjhm,
                                      ROW3:collectTime,
                                      ROW4:"#FFFFFF",
                                      OptargetId:persionObj[i].OptargetId,
                                      JSON:JSON.stringify(Dataobject)})

            }
            break
        case QmlData.INTO_TYPE_THREEREAL_UNIT://三实 - 实有单位  dz_dwdzxz
            matchNumber=persionObj.length
            for(i=0;i<persionObj.length;i++){
                Dataobject = JSON.parse(persionObj[i].Data)
                var collectTime=qmlData.cutStr(persionObj[i].CreatedAt, 0, 10)+" "+qmlData.cutStr(persionObj[i].CreatedAt, 11, 8)
//                console.log(Dataobject.dwjbxxb.dwmc)//单位名称
//                console.log(Dataobject.Echo.dwlbdm)//单位类别
//                console.log(Dataobject.dwjbxxb.dz_dwdzxz)//单位地址
                var unitXp=""
                if(Dataobject.dwjbxxb.xp==""){
                    unitXp='qrc:/images/images/none_people.png'
                }else{
                    unitXp="file:///"+qmlData.transformBase642Image(Dataobject.dwjbxxb.xp, documentDir+"/unit"+i+".jpg")
                }
                infoModel.append({IMG: unitXp,
                                     ISSHOWUPLOAD:persionObj[i].IsUpload,
                                     SHOWTEXTTITLE:"",
                                     SHOWTEXT:'',
                                     ROW1:Dataobject.dwjbxxb.dwmc,
                                     ROW2:Dataobject.dwjbxxb.dz_dwdzxz,
                                     ROW3:collectTime,
                                     ROW4:"#FFFFFF",
                                     OptargetId:persionObj[i].OptargetId,
                                     JSON:JSON.stringify(Dataobject)})
            }
            break
        case QmlData.INTO_TYPE_THREEREAL_ROOM://三实 - 实有房屋
            matchNumber=persionObj.length
            for(i=0;i<persionObj.length;i++){
                Dataobject = JSON.parse(persionObj[i].Data)
               // var iscz=Dataobject.fwjbxxb.sfczfw==1?"是":"否"
                var collectTime=qmlData.cutStr(persionObj[i].CreatedAt, 0, 10)+" "+qmlData.cutStr(persionObj[i].CreatedAt, 11, 8)
                infoModel.append({IMG:'qrc:/images/images/none_people.png',
                                     ISSHOWUPLOAD:persionObj[i].IsUpload,
                                     SHOWTEXTTITLE:"",
                                     SHOWTEXT:'',
                                     ROW1:Dataobject.fwjbxxb.fz_xm,
                                     ROW2:Dataobject.fwjbxxb.fwdz_dzxz,
                                     ROW3:collectTime,
                                     ROW4:"#FFFFFF",
                                     OptargetId:persionObj[i].OptargetId,
                                     JSON:JSON.stringify(Dataobject)})
            }
            break
        case QmlData.INTO_TYPE_POINTCARD_CAR://卡点盘查车
            matchNumber=persionObj.length
            for(i=0;i<persionObj.length;i++){
                 var dataObj = JSON.parse(persionObj[i].Data)
                    if(!dataObj.checkException){
                        infoModel.append({   IMG:getPhotoPathSignal(dataObj.carInfo.photoPath),
                                             SHOWTEXT:'',
                                             ISSHOWUPLOAD:persionObj[i].IsUpload,
                                             SHOWTEXTTITLE:'',
                                             ROW1:dataObj.carInfo.licensePlateNo,
                                             ROW2:dataObj.carInfo.licensePlateType,
                                             ROW3:JSL.dataValueToData(dataObj.locationInfo.checkTime),
                                             //ROW3:dataObj.carInfo.performState,
                                             ROW4:"#FFFFFF",
                                             OptargetId:persionObj[i].OptargetId,
                                             JSON:JSON.stringify(dataObj)})
                    }else{
                        infoModel.append({   IMG:getPhotoPathSignal(dataObj.carInfo.photoPath),
                                             SHOWTEXT:'',
                                             ISSHOWUPLOAD:persionObj[i].IsUpload,
                                             SHOWTEXTTITLE:'',
                                             ROW1:dataObj.carInfo.licensePlateNo,
                                             ROW2:dataObj.carInfo.licensePlateType,
                                             //ROW3:dataObj.carInfo.performState,
                                             ROW3:JSL.dataValueToData(dataObj.locationInfo.checkTime),
                                             ROW4:"#FFD2D2",
                                             OptargetId:persionObj[i].OptargetId,
                                             JSON:JSON.stringify(dataObj)})
                    }

            }
            break
        case QmlData.INTO_TYPE_POINTCARD_PERSION://卡点盘查人
            matchNumber=persionObj.length
            for(i=0;i<persionObj.length;i++){
                Dataobject = JSON.parse(persionObj[i].Data)
                    if(!Dataobject.checkException){
                        infoModel.append({IMG:getPhotoPathSignal(Dataobject.idcardInfo.photo),
                                              ISSHOWUPLOAD:persionObj[i].IsUpload,
                                              SHOWTEXTTITLE:"",
                                              SHOWTEXT:'',
                                              ROW1:Dataobject.idcardInfo.name,//getName(Dataobject.idcardInfo.name),
                                              //ROW2:Dataobject.idcardInfo.sex,
                                              ROW2:Dataobject.idcardInfo.idcard,
                                              ROW3:JSL.dataValueToData(Dataobject.locationInfo.checkTime),
                                              ROW4:"#FFFFFF",
                                              OptargetId:persionObj[i].OptargetId,
                                              JSON:JSON.stringify(Dataobject)})
                    }else{
                         infoModel.append({IMG:getPhotoPathSignal(Dataobject.idcardInfo.photo),
                                              ISSHOWUPLOAD:persionObj[i].IsUpload,
                                              SHOWTEXTTITLE:"",
                                              SHOWTEXT:'',
                                              ROW1:Dataobject.idcardInfo.name,//getName(Dataobject.idcardInfo.name),
                                              //ROW2:Dataobject.idcardInfo.sex,
                                              ROW2:Dataobject.idcardInfo.idcard,
                                              ROW3:JSL.dataValueToData(Dataobject.locationInfo.checkTime),
                                              ROW4:"#FFD2D2",
                                              OptargetId:persionObj[i].OptargetId,
                                              JSON:JSON.stringify(Dataobject)})
                 }
              //}

            }
            break
        }
    }
    //从go服务获取列表
    function getDataListLy(){
        var url ="http://"+goIpPort+"/listLY/"+policeIdCard+"/"+nPageSerialNumber+"/"+""+"/1"
        console.log(url)
        operatehttp.get(url,function(code, data){
            console.log("从go服务获取列表"+data)
            if(code == 200){
                busyIndicator.running = false
                messagebox.visible = false
                showInfoList(data)
            }
            else{
                console.log("发送查询列表请求失败")
            }
        })
    }

    //搜索列表 包括一些查询条件 模糊查找内容、是否异常、时间
    function getSearchDataList(condition, type){
        var url ="http://"+goIpPort+"/NewMatchingLY/"+policeIdCard+"/"+nPageSerialNumber+"/"+taskCodeEvery+"/"+condition+"/"+statusData.get(status.currentIndex).code
                +"/"+startDateStr+"+"+startTimeStr+":00.000"+"/"+endDateStr+"+"+endTimeStr+":59.999"
        console.log("搜索列表 --------- "+url)
        operatehttp.get(url,function(code, data){
            console.log("模糊查找结束返回----")
            console.log("data"+data)
            console.log("code"+code)
            var obj = JSON.parse(data)
            if(code == 200){
                busyIndicator.running = false
                showInfoList(data)
            }else{
                console.log("发送查找请求失败")

            }
        })
    }

    //历史盘查界面最下方所有统计数据
    function allStatisticNum(type){
        ///allCountLY/:policeIdcard/:dataType/:relationId
        var url ="http://"+goIpPort+"/allCountLY/"+policeIdCard+"/"+taskCodeEvery +"/"+nPageSerialNumber
        //var url ="http://127.0.0.1:8091/allCountLY/000100//20"
        console.log("最下方所有统计数据获取"+url)
         busyIndicator.running = true
        operatehttp.get(url,function(code, data){
            console.log("最下方所有统计数据获取完成返回")
            console.log(code)
            console.log(data)
            var obj = JSON.parse(data)
            if(code == 200){
                busyIndicator.running = false
                if(nPageNumberType == QmlData.INTO_TYPE_SHACK_ROOM){
                    inventoryTotal= obj.Temp_data.AllInspectHS
                    inventoryToday= obj.Temp_data.TodayInspectHS
                    abnormalNumber= obj.Temp_data.AllExceptionHS
                    abnormalToday= obj.Temp_data.TodayExceptionHS
                    if(type==0){
                        matchNumber=obj.Temp_data.TodayInspectHS
                    }
                }else{
                    inventoryTotal=obj.Peo_data.AllInspect
                    inventoryToday=obj.Peo_data.TodayInspect
                    abnormalNumber=obj.Peo_data.AllException
                    abnormalToday=obj.Peo_data.TodayException
                    if(type==0){
                        matchNumber=obj.Peo_data.TodayInspect
                    }
                }
            }else{
                console.log("发送查找请求失败")
            }
        })
    }

}
