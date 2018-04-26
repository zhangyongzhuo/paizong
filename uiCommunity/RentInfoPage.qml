import QtQuick 2.4
import "qrc:/collectJson/js/ThreeRealRoom.js"  as ThreeRealJson

RentInfoPageForm {
    property var pageDataJsonObject:ThreeRealJson.getCzfwxxb()
    property string workLogText:""
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json
    
    Component.onCompleted:{
    
        remark.text=workLogText
        remarksNumber.text=remark.text.length+"/"+256
        
        var FWDJDM_Url = 'http://'+goIpPort+'/sy/syTypeDict/BD_D_FWDJDM'          //(房屋等级)
        operatehttp.get(FWDJDM_Url, function(code, data){
            if(code == 200){
                if(data != ""){
                    var obj = JSON.parse(data)
                    if (obj.length > 0){
                        houseGrade.model.clear()
                        for(var i=0;i<obj.length;i++){
                            //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
                             houseGrade.model.append({text:obj[i].ct, code:obj[i].dm})
                        }
                        houseGrade.currentIndex = -1
                        houseGrade.currentText = ""
                    }
                }
            }else{
                console.log('查询实有房屋_出租信息失败')
            }
        })

    }

    //小键盘调用
    //出租间数
    rentedRoom.onCursorVisibleChanged:{
        if(rentedRoom.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //出租面积
    rentedArea.onCursorVisibleChanged:{
        if(rentedArea.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //出租租金
    leaseDate.onCursorVisibleChanged:{
        if(leaseDate.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //备注
    remark.onCursorVisibleChanged:{
        if(remark.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
     /***************************日期控件调用*****************************/
    //责任书签订时间
    signTime.onCursorVisibleChanged:{
        if(signTime.cursorVisible){
            datePage.visible=true
            dataCallName="signTime"
        }
    }
    //出租日期
    rent.onCursorVisibleChanged:{
        if(rent.cursorVisible){
            datePage.visible=true
            dataCallName="rent"
        }
    }

    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            pageDataJsonObject.cz_fjs = rentedRoom.text  //出租房间数(不能大于房屋间数)
            pageDataJsonObject.cz_mjpfm =rentedArea.text  //出租面积(不能大于房屋面积)
            pageDataJsonObject.cz_rq =rent.text  //出租日期 格式：1990-02-02
            pageDataJsonObject.zj =leaseDate.text  //租金(元/月)
            if(houseGrade.currentIndex!=-1)
                pageDataJsonObject.fwdjdm = houseGrade.model.get(houseGrade.currentIndex).code//房屋等级>>zdbh: BD_D_FWDJDM
            ////////////////////////////////////////////////////////////////////////////////////////////////////
            pageDataJsonObject.zazrr_id =userName//当sfczfw为1时该项必填	治安责任人id 对应userid
            pageDataJsonObject.zazrr_xm =policeName //当sfczfw为1时该项必填	治安责任人姓名对应username
            //////////////////////////////////////////////////////////////////////////////////////////////////
            pageDataJsonObject.zrs_qd_rq =signTime.text //当sfczfw为1时该项必填	责任书签订日期 格式：1990-02-02
            pageDataJsonObject.bz =remark.text //备注
            PAGEDATA = JSON.stringify(pageDataJsonObject)
            //console.log("============="+PAGEDATA)
        }
        onSendPageUabled:{
           cadeEnabled=status
           status?colorR=  "#FFFFFF":colorR= "#F2F2F4"
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
                case "signTime"://
                  signTime.text=dataStr
                    break
                case "rent"://
                  rent.text=dataStr
                    break
            }
        }
        onFinishToEveryControl:{//清空所有
            clearAll()

        }

        onInitInfoMsg:{
            if(casecadeName == "BaseInfoPage"){ // 基础信息模块传递回来的 是否出租房屋信息
                if(initInfo == "否"){ //不是出租房屋 责任书签订时间不是必填
                    signTimeText.text = "责任书签订时间:"
                    clearAll()
                }
                else if(initInfo == "是"){//是出租房屋 责任书签订时间必填
                    signTimeText.text = "<font color='red'>*</font>责任书签订时间:"
                }
            }
        }
    }

    function clearAll(){
        rentedRoom.text=""  //出租房间数(不能大于房屋间数)
        rentedArea.text=""  //出租面积(不能大于房屋面积)
        rent.text ="" //出租日期 格式：1990-02-02
        leaseDate.text=""  //租金(元/月)
        houseGrade.currentIndex = -1
        houseGrade.currentText = ""
        signTime.text =""//当sfczfw为1时该项必填	责任书签订日期 格式：1990-02-02
        remark.text="" //备注
    }

}
