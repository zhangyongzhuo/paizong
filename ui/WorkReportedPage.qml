import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
import "qrc:/controls/ui"

//工作报备界面
WorkReportedPageForm {
    property bool startorEnd: true    //判断开始还是结束日期
    property bool startorEndTime: true    //判断开始还是结束时间
    property var  photoList: []    //照片base64数组
    property int  entryMode: 0    //从哪进入 1.考勤打卡
    property int  entryPageMode:0 //模式增删改查
    property string reasonHugh: ""   //
    property string approverjson: ""  //原始的审批人数据
    property var    approverlist: []     //审批人列表
    property var    approverlistTemp: []     //审批人列表
    property string overId: ""     //加班返回的Id

    property bool   isAtt: false
    property bool  kdExit:false     //判断配置文件中审批人Idcard是否存在

    property int yearCurrent:0
    property int monthCurrent:0
    property int dayCurrent:0
    property int hourCurrent:0
    property int minuteCurrent:0


    Component.onCompleted: {
        //getWorkTime()
        var currentDate = new Date()
        yearCurrent = currentDate.getFullYear()
        monthCurrent = currentDate.getMonth()+1
        dayCurrent = currentDate.getDate()
        hourCurrent = currentDate.getHours()
        minuteCurrent = currentDate.getMinutes()

        photoDisplyViewModel.clear()

        //获取审批人信息
        getApproverList()
       // approverPer.text=approverLeader
    }

    //开始日期
    startDate.onCursorVisibleChanged: {
        if(startDate.cursorVisible == true){
            if(startDate.text==""){
                datePage.year= yearCurrent
                datePage.month= monthCurrent
                datePage.day= dayCurrent
            }
            else{
                datePage.year= qmlData.cutStr(JSL.getDate(startDate.text),0,4)
                datePage.month= qmlData.cutStr(JSL.getDate(startDate.text),4,2)
                datePage.day=qmlData.cutStr(JSL.getDate(startDate.text),6,2)
            }
            datePage.visible=true
            startorEnd=true
        }
    }

    //开始时间
    startTime.onCursorVisibleChanged: {
        if(startTime.cursorVisible == true){
            if(startDate.text==""){
                messagebox.text = '请先选择开始日期再选择开始时间'
                messagebox.visible = true
            }
            else{
                if(startTime.text==""){
                    timePage.hour= hourCurrent
                    timePage.minute= minuteCurrent
                }
                else{
                    timePage.hour=qmlData.cutStr(JSL.getTime(startTime.text),0,2)
                    timePage.minute=qmlData.cutStr(JSL.getTime(startTime.text),2,2)
                }
                timePage.visible=true
                startorEndTime=true
            }
        }
    }

    //结束日期
    endDate.onCursorVisibleChanged: {
        if(endDate.cursorVisible == true){
            if(startDate.text==""){
                messagebox.text = '请先选择开始日期再选择结束日期'
                messagebox.visible = true
                return true
            }
            if(startTime.text==""){
                messagebox.text = '请先选择开始时间再选择结束日期'
                messagebox.visible = true
                return true
            }
            if(endDate.text==""){
                datePage.year= yearCurrent
                datePage.month= monthCurrent
                datePage.day= dayCurrent
            }else{
                datePage.year= qmlData.cutStr(JSL.getDate(endDate.text),0,4)
                datePage.month= qmlData.cutStr(JSL.getDate(endDate.text),4,2)
                datePage.day= qmlData.cutStr(JSL.getDate(endDate.text),6,2)
            }
            datePage.visible=true
            startorEnd=false
        }
    }

    //结束时间
    endTime.onCursorVisibleChanged: {
        if(endTime.cursorVisible == true){
            if(startDate.text==""){
                messagebox.text = '请先选择开始日期再选择结束时间'
                messagebox.visible = true
                return true
            }
            if(startTime.text==""){
                messagebox.text = '请先选择开始时间再选择结束时间'
                messagebox.visible = true
                return true
            }
            if(endDate.text==""){
                messagebox.text = '请先选择结束日期再选择结束时间'
                messagebox.visible = true
                return true
            }
            if(endTime.text==""){
                timePage.hour= hourCurrent
                timePage.minute= minuteCurrent
            }
            else{
                timePage.hour=qmlData.cutStr(JSL.getTime(endTime.text),0,2)
                timePage.minute=qmlData.cutStr(JSL.getTime(endTime.text),2,2)
            }
            timePage.visible=true
            startorEndTime=false
        }
    }

    //报备输入框焦点改变
    approverPer.onCursorVisibleChanged: {
        if(approverlist.length <= 0){
            approverDataArea.visible = false
            return;
        }
        if(approverPer.cursorVisible){
            approverDataArea.visible = true
            approverDataArea.bHightLight = true
        }
        else{
            approverDataArea.visible = false
        }
    }

    //报备输入框数据变化
    approverPer.onTextChanged: {
        if(approverPer.cursorVisible == true){
            approverDataArea.visible = true
            approverDataArea.bHightLight = true
        }
        else{
            approverDataArea.visible = false
        }
        if(approverPer.text != ""){
            approverData.json = ""
            approverlist = []
            //到原始Json中查找符合項
            if(approverjson == ""){
                approverDataArea.visible = false
            }
            else{
                var obj = JSON.parse(approverjson)
                for (var i=0;i<obj.length;i++) {
                    if(obj[i].leader.indexOf(approverPer.text)>=0){//xuyaoxiugai
                        approverlist.push(obj[i])
                    }
                }
                //有符合項
                if(approverlist.length > 0){
                    approverData.json = JSON.stringify(approverlist)
                }
                else{
                    approverDataArea.visible = false
                }
            }
        }
        else{
            if(approverjson != ""){
                approverData.json = approverjson
            }
            else{
                approverDataArea.visible = false
            }
        }
    }

    //拍照界面返回的拍照完成信号
    Connections{
        target: mainQml

        onMultiPhotosShotFinished:{
            if(receivePageName=="WorkReportedPage"){
                photoDisplyViewModel.clear()
                photoDisplyView.visible=true
                //拍照按钮点击进去的拍照页面完成时返回的照片路径数据
                for(var i=0; i<result.length; i++){
                    photoDisplyViewModel.append({photopath: result[i]})//加载返回的照片
                }
            }
        }
    }

    //修改审批人
    onChangeUserName:{
        for(var i=0; i<approverlistTemp.length; i++){
            if(name == approverlistTemp[i].name+"("+approverlistTemp[i].pCard+")"){
                approverIdcard=approverlistTemp[i].idCard
                approverLeader=name
                operateconfigfile.setApproverIdcard(approverIdcard)
                operateconfigfile.setApproverLeader(approverLeader)
            }
        }
    }

    //拍照按钮 将现有照片传入拍照界面
    takephoto.onClicked: {
        var pList=[]
        if(photoDisplyViewModel.count>0){
            for(var i=0; i<photoDisplyViewModel.count; i++){
                pList.push(photoDisplyViewModel.get(i).photopath)
            }
        }
        stackView.push({item: "qrc:/singleFunction/ui/MultiPhotosShootPage.qml", properties:{photocount: 10,receivePageName:"WorkReportedPage",pList:pList}})
    }

    back.onClicked: {
        if(isAtt){
            messagebox.text = "正在提交报备，请稍候"
            messagebox.visible = true
        }
        else{
            if(entryMode==1){
                stackView.pop()
            }
        }
    }

    finish.onClicked: {
        //1.选择报备类型(*必填项)
        if(preTypeText==''){
            messagebox.text = '请选择报备类型'
            messagebox.visible = true
            return true
        }
        //2.结束时间大于开始时间给予结束时间不能大于开始时间提示
        if(startDate.text==''||startTime.text==''){
            messagebox.text = '请填写完整开始时间 '
            messagebox.visible = true
            return true
        }
        if(endDate.text==''||endTime.text==''){
            messagebox.text = '请填写完整结束时间 '
            messagebox.visible = true
            return true
        }
        if(startDate.text!='' && endDate.text!='' && (JSL.getDate(startDate.text)-JSL.getDate(endDate.text)>0)){
            messagebox.text = '结束时间不能小于开始时间'
            messagebox.visible = true
            return true
        }else{
            if(startDate.text!='' && endDate.text!='' && (JSL.getDate(startDate.text)-JSL.getDate(endDate.text)==0)){
                if(startTime.text!='' && endTime.text!='' && (JSL.getTime(startTime.text)-JSL.getTime(endTime.text)>0)){
                    messagebox.text = '结束时间不能小于开始时间'
                    messagebox.visible = true
                    return true
                }
            }
        }
        //3.报备事由必填
        if(JSL.trimAll(realistictext.text)==''){
            messagebox.text = '请填写报备事由'
            messagebox.visible = true
            return true
        }
        //4.请选择审批人
        if(approverPer.text==''){
            messagebox.text = '请选择审批人'
            messagebox.visible = true
            return true
        }else{
            var isHaveapprover=false
            for(var i=0; i<approverlistTemp.length; i++){
                if(approverPer.text == approverlistTemp[i].name+"("+approverlistTemp[i].pCard+")"){
                    isHaveapprover=true
                }
            }
            if(!isHaveapprover){
                messagebox.text = '请选择审批人'
                messagebox.visible = true
                return true
            }
        }

        //5.提交报备接口、后台对接
        if(isAtt){
            messagebox.text = "正在提交报备，请稍候"
            messagebox.visible = true
        }
        else{
            //外出请假提交报备
            if(goOut.checked||leave.checked){
                submitWorkReported()
            }
            //加班串休提交报备
            if(outOver.checked||inOver.checked){
                popWindowOff.visible=true
                workReport.enabled=false
            }
         }
    }




    //获取审批人员信息
    function getApproverList(){
        var datajson={
            "idCard":policeIdCard
        }
        //var url="http://172.19.12.232:8888/jobpreparation/approverList"
        var url="http://"+remoteIpPort+"/attendance-service/jobpreparation/approverList"
        console.log("获取审批人员信息URL："+url)
        console.log("获取审批人员信息入参："+JSON.stringify(datajson))
        busying.running = true
        operatehttp.post(url,function(code, data){
            console.log("获取审批人员信息回参code："+code)
            console.log("获取审批人员信息回参data："+data)
            busying.running=false
            if(code==200||code==0){
                var obj = JSON.parse(data)
                approverlist=[]
                for(var i=0;i<obj.result.length;i++){
                    var temp = {}
                    temp.leader =obj.result[i].name+"("+obj.result[i].pCard+")"
                    temp.name   = obj.result[i].name
                    temp.idCard = obj.result[i].idCard
                    temp.pCard  =obj.result[i].pCard
                    approverlist.push(temp)
                    if(approverIdcard!==""){
                        if(obj.result[i].idCard == approverIdcard){
                            kdExit=true
                        }
                    }
                }
                approverlistTemp=approverlist
                approverjson=JSON.stringify(approverlist)
                approverData.json = approverjson
                if(!kdExit){
                    approverIdcard=""
                    approverLeader=""
                    operateconfigfile.setApproverIdcard("")
                    operateconfigfile.setApproverLeader("")
                }else{
                     approverPer.text=approverLeader
                }
            }
            else if(code == 500){
                obj = JSON.parse(data)
                messagebox.text = "获取审批人员信息出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = "获取审批人员信息失败，请检查网络，错误码:"+code
                messagebox.visible = true
            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

    //提交工作报备
    function submitWorkReported(){
            photoList = []
            //把照片转成base64放在数组里
            for(var i=0;i<photoDisplyViewModel.count;i++){
                photoList.push(qmlData.transformImage2Base64(qmlData.cutStr(photoDisplyViewModel.get(i).photopath, 8, 0)))
            }
            var datajson=[
                {
                    "idCard":policeIdCard,
                    "reportedLocation":JSL.trimAll(place.text),
                    "startTime":startDateStr+startTimeStr+"00",
                    "endTime":endDateStr+endTimeStr+"00",
                    "reportedReasons":JSL.trimAll(realistictext.text),
                    "approverIdCard":approverIdcard,
                    "longitude":longitude,//"312.123",
                    "latitude":latitude,//"123.231",
                    "uid":uid,
                    "reportType":preTypeCode,
                    "photoPath":photoList
                }
            ]
            //var url="http://172.19.12.232:8888/jobpreparation/workReported"
            var url="http://"+remoteIpPort+"/attendance-service/jobpreparation/workReported"
            console.log("提交工作报备URL"+url)
            console.log("提交工作报备入参："+JSON.stringify(datajson))
            isAtt = true
            busying.running = true
            operatehttp.post(url,function(code, data){
                isAtt = false
                busying.running = false
                console.log("提交工作报备code："+code)
                console.log("提交工作报备data："+data)
                if(code==200||code==0){
                    messagebox.text = '提交工作报备成功'
                    messagebox.visible = true
                    //开启跳出该界面定时器
                    finishTimer.start()
                }
                else if(code == 500){
                    var obj = JSON.parse(data)
                    messagebox.text = "提交工作报备出错，错误原因:"+obj.reason.text
                    messagebox.visible = true
                }
                else{
                    console.log(code+"工作报备申请失败")
                    messagebox.text = '提交工作报备失败，请稍后提交'
                    messagebox.visible = true
                    return true
                }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }

 //串休报备
     function onHughReported(startT,endT,hughNum){
         reasonHugh=policeName+"在"+startDate.text+","+startTime.text+"到"+endDate.text+","+endTime.text+"加班了,提交串休申请"
         console.log("加班开始时间："+startDateStr+startTimeStr+"00")
         console.log("加班结束时间："+endDateStr+endTimeStr+"00")
         console.log("串休开始时间："+startT)
         console.log("串休结束时间："+endT)
         photoList = []
        //把照片转成base64放在数组里
        for(var i=0;i<photoDisplyViewModel.count;i++){
            photoList.push(qmlData.transformImage2Base64(qmlData.cutStr(photoDisplyViewModel.get(i).photopath, 8, 0)))
        }
        var datajson=[
            {
                "idCard":policeIdCard,
                "reportedLocation":JSL.trimAll(place.text),
                "startTime":startDateStr+startTimeStr+"00",
                "endTime":endDateStr+endTimeStr+"00",
                "reportedReasons":JSL.trimAll(realistictext.text),
                "approverIdCard":approverIdcard,
                "longitude":longitude,
                "latitude":latitude,
                "uid":uid,
                "reportType":preTypeCode,
                "photoPath":photoList
            },
            {
                "idCard":policeIdCard,
                "reportedLocation":JSL.trimAll(place.text),
                "startTime":startT,
                "endTime": endT,
                "reportedReasons":reasonHugh,
                "approverIdCard":approverIdcard,
                "longitude":longitude,
                "latitude":latitude,
                "uid":uid,
                "reportType":"400105",
                "photoPath":[],
                "remark":hughNum
            }
        ]
        //var url="http://172.19.12.232:8888/jobpreparation/workReported"
        var url="http://"+remoteIpPort+"/attendance-service/jobpreparation/workReported"
        console.log("申请串休URL:"+url)
        console.log("申请串休入参:"+JSON.stringify(datajson))
        isAtt = true
        busying.running = true
        operatehttp.post(url,function(code, data){
            isAtt = false
            busying.running = false
            console.log("申请串休回参code："+code)
            console.log("申请串休回参data："+data)
            if(code==200||code==0){
                messagebox.text = '提交加班串休成功'
                messagebox.visible = true
                //开启跳出该界面定时器
                finishTimer.start()
            }
            else if(code == 500){
                var obj = JSON.parse(data)
                messagebox.text = "提交加班串休出错，错误原因:"+obj.reason.text
                messagebox.visible = true
            }
            else{
                messagebox.text = '提交加班串休失败,请稍后提交'
                messagebox.visible = true

            }
        },"(0)="+JSON.stringify(datajson),token,"","",operateconfigfile.getProxyHttpsIP(), operateconfigfile.getProxyHttpsPort(),operateconfigfile.getProxyHttpsEnable())
    }
    function  sumbitLeave(){
        if(overStart!=""&&overEnd!=""){
            var startStr=""
            var endStr=""
            var str_t=""
            if(whetherOff==0){//半天调休
               startStr=JSL.getDate(qmlData.nextMonthMaxDay(nextYear,nextMonth,nextDay))+JSL.getTime(overStart)
               str_t=qmlData.int_str((qmlData.str_int(qmlData.cutStr(JSL.getTime(overStart),0,2)))+4)+qmlData.cutStr(JSL.getTime(overStart),2,4)
               endStr=JSL.getDate(qmlData.nextMonthMaxDay(nextYear,nextMonth,nextDay))+str_t
               onHughReported(startStr,endStr,"已申请调休半天")
            }else if(whetherOff==1){//一天调休
                startStr=JSL.getDate(qmlData.nextMonthMaxDay(nextYear,nextMonth,nextDay))+JSL.getTime(overStart)
                endStr=JSL.getDate(qmlData.nextMonthMaxDay(nextYear,nextMonth,nextDay))+JSL.getTime(overEnd)
                onHughReported(startStr,endStr,"已申请调休一天")
            }else{
               submitWorkReported()
              // stackView.pop()
            }
        }else{
            messagebox.text = '获取工作时间失败无法提交报备,请稍后提交'
            messagebox.visible = true
        }
    }

     //等待一秒钟后跳出该界面
     Timer{
         id:finishTimer
         interval: 1000;
         repeat: false;
         onTriggered: {
             emit:finishTask()
             if(entryMode==1){
                 stackView.pop()
                 stackView.pop()
             }
             else{
                 stackView.pop()
             }
         }
     }
}


