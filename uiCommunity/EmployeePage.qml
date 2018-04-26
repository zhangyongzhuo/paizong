import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealRoom.js"  as ROOM_JSON
//import "qrc:/collectJson/js/ThreeRealJson.js" as ThreeReal_OBJECT
import QtMultimedia 5.4

EmployeePageForm {
    property var threeRealJson : ROOM_JSON.getJsonObject()  //数据采集项模板
    property int    colloctType:0           //数据采集类型 值为枚举 qmldata中有定义
    property int    entryPageMode: 0        //1增加 2删除 3修改 4查看 值为枚举 qmldata中有定义
    property var    temIdcardInfo:[]              //存放读取到的二代证数据

    property string isHouseLet:""

    function getIndexByName(model, name){
        for(var i=0; i<model.count; i++){
            if(model.get(i).value===name){
                return i
            }
        }
        return -1
    }

    Component.onCompleted:{

        bBackUsed = false
        personModel.clear()
//        personModel.append({PAGENAME: "BaseInfoPage",     //基本信息
//                             PAGEHEIGHT:370,
//                             PAGENO: 0,
//                             PAGETITLE:"基本信息",
//                             PAGETOPLINE: false,
//                             PAGEBOTTOMLINE:false,
//                               enable: true,
//                             PAGEDATA: ''})
        personModel.append({PAGENAME: "DocumentInfoPage",     //证件信息
                             PAGEHEIGHT:360,
                             PAGENO: 0,
                             PAGETITLE:"证件信息",
                             PAGETOPLINE: false,
                             PAGEBOTTOMLINE:false,
                               enable: true,
                             PAGEDATA: ''})
        personModel.append({PAGENAME: "BaseInfoEmployeePage",     //其他信息
                             PAGEHEIGHT:300,
                             PAGENO: 0,
                             PAGETITLE:"其他信息",
                             PAGETOPLINE: false,
                             PAGEBOTTOMLINE:false,
                               enable: false,
                             PAGEDATA: ''})
        personModel.append({PAGENAME: "AddPhotosSinkPage", //写实模块（需要改造）
                               PAGEHEIGHT: isX6 ? 370 : 190,
                               PAGENO: 0,
                               PAGELOCAL: false,
                               PAGETITLE: "照片",
                               PAGEBOTTOMLINE: false,
                               enable: false,
                               PAGEDATA: JSON.stringify(threeRealJson.Data.unitInfo)})

//        personModel.append({PAGENAME: "CustodianInfoPage",     //托管人信息
//                             PAGEHEIGHT:300,
//                             PAGENO: 0,
//                             PAGETITLE:"托管人信息",
//                             PAGETOPLINE: false,
//                             PAGEBOTTOMLINE:false,
//                               enable: false,
//                             PAGEDATA: ''})
//        personModel.append({PAGENAME: "RentInfoPage",     //出租信息
//                             PAGEHEIGHT:460,
//                             PAGENO: 0,
//                             PAGETITLE:"出租信息",
//                             PAGETOPLINE: false,
//                             PAGEBOTTOMLINE:false,
//                               enable: false,
//                             PAGEDATA: ''})
//        personModel.append({PAGENAME: "LessorInfoPage",     //出租人信息
//                             PAGEHEIGHT:300,
//                             PAGENO: 0,
//                             PAGETITLE:"出租人信息",
//                             PAGETOPLINE: false,
//                             PAGEBOTTOMLINE:false,
//                               enable: false,
//                             PAGEDATA: ''})

        personModel.append({PAGENAME: "BottomInfoPage", //底部占位模块
                               PAGEHEIGHT:220,
                               PAGENO: 0,
                               PAGELOCAL: false,
                               PAGETITLE:"占位模块",
                               PAGEBOTTOMLINE:false,
                               PAGETYPE: 11,
                               enable: false,
                               PAGEDATA: ''})


        if(entryPageMode == QmlData.VISIT_TYPE_SEE || entryPageMode == QmlData.VISIT_TYPE_MODIFY){
            birth.hint = ''
            cadeEnabled = false
            readIdcard.stopIdcardIdentification()
        }
        else{
            readIdcard.startIdcardIdentification(documentDir+"/read.bmp")
       }

    }
//    //当点击"完成"按钮时，给子页面发送完成信号 让白流填充Json
//    finish.onClicked:{
//        getFocus.focus = true
//        //填充采集信息
//        emit: fillInfoMsg("ThreeRealPersonPage")
//        fillInfoAndSave(true)
//    }

//    back.onClicked:{
//        getFocus.focus = true
//        if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
//                entryPageMode==QmlData.VISIT_TYPE_MODIFY){
//            popWindow.visible = true
//        }
//    }

//    function fillInfoAndSave(isFinished){

//        var isSaved = true

//        if(isFinished){//点击完成 此时上传状态为待上传
//            threeRealJson.IsUpload = 0
//        }else{
//            threeRealJson.IsUpload = -1
//        }
//        threeRealJson.OptargetId = documentID
//        threeRealJson.PoliceIdcard = policeIdCard
//        threeRealJson.DataType = colloctType
//        threeRealJson.Data.userid=userName//登陆用户
//        threeRealJson.Data.orgjb=operateconfigfile.getOrgJb()//登陆用户所属组织机构级别
//        threeRealJson.Data.orgid=operateconfigfile.getOrgId()//登陆用户所属组织机构ID
//        threeRealJson.Data.menuname="实有房屋管理"//登陆用户所含菜单权限

//        console.log("-----:"+personModel.get(0).PAGEDATA)
//        threeRealJson.Data.fwjbxxb=JSON.parse(personModel.get(0).PAGEDATA)

//        threeRealJson.Data.fwjbxxb.fz_cyzjdm=JSON.parse(personModel.get(1).PAGEDATA).fz_cyzjdm//房主证件种类
//        threeRealJson.Data.fwjbxxb.fz_zjhm=JSON.parse(personModel.get(1).PAGEDATA).fz_zjhm//房主证件号码
//        threeRealJson.Data.fwjbxxb.fz_xm=JSON.parse(personModel.get(1).PAGEDATA).fz_xm//房主姓名
//        threeRealJson.Data.fwjbxxb.fz_lxdh=JSON.parse(personModel.get(1).PAGEDATA).fz_lxdh//房主联系电话
//        threeRealJson.Data.fwjbxxb.fz_wwx=JSON.parse(personModel.get(1).PAGEDATA).fz_wwx//房主外文姓
//        threeRealJson.Data.fwjbxxb.fz_wwm=JSON.parse(personModel.get(1).PAGEDATA).fz_wwm //房主外文名

//        threeRealJson.Data.fwjbxxb.tgr_cyzjdm=JSON.parse(personModel.get(2).PAGEDATA).tgr_cyzjdm//
//        threeRealJson.Data.fwjbxxb.tgr_zjhm=JSON.parse(personModel.get(2).PAGEDATA).tgr_zjhm //当tgr_cyzjdm不为空时必填	房屋托管人证件号码
//        threeRealJson.Data.fwjbxxb.tgr_xm=JSON.parse(personModel.get(2).PAGEDATA).tgr_xm //当tgr_cyzjdm不为空时必填	房屋托管人姓名
//        threeRealJson.Data.fwjbxxb.tgr_lxdh=JSON.parse(personModel.get(2).PAGEDATA).tgr_lxdh//当tgr_cyzjdm不为空时必填	房屋托管人联系电话
//        threeRealJson.Data.fwjbxxb.tgr_wwx=JSON.parse(personModel.get(2).PAGEDATA).tgr_wwx//房屋托管人外文姓
//        threeRealJson.Data.fwjbxxb.tgr_wwm=JSON.parse(personModel.get(2).PAGEDATA).tgr_wwm //房屋托管人外文名
//        threeRealJson.Data.fwjbxxb.tgr_yfzgx_rygxdm=JSON.parse(personModel.get(2).PAGEDATA).tgr_yfzgx_rygxdm //房屋托管人外文名

//        threeRealJson.Data.czfwxxb=JSON.parse(personModel.get(3).PAGEDATA)

//        threeRealJson.Data.czfwxxb.czur_yfzgx_rygxdm=JSON.parse(personModel.get(4).PAGEDATA).czur_yfzgx_rygxdm//当sfczfw为1时该项必填	出租人与房主关系>>zdbh: XZ_D_CZFWRYGXDM
//        threeRealJson.Data.czfwxxb.czur_cyzjdm=JSON.parse(personModel.get(4).PAGEDATA).czur_cyzjdm
//        threeRealJson.Data.czfwxxb.czur_zjhm=JSON.parse(personModel.get(4).PAGEDATA).czur_zjhm //当sfczfw为1时该项必填	出租人证件号码
//        threeRealJson.Data.czfwxxb.czur_xm=JSON.parse(personModel.get(4).PAGEDATA).czur_xm//当sfczfw为1时该项必填	出租人姓名
//        threeRealJson.Data.czfwxxb.czur_lxdh=JSON.parse(personModel.get(4).PAGEDATA).czur_lxdh//当sfczfw为1时该项必填	出租人联系电话
//        threeRealJson.Data.czfwxxb.czur_wwx=JSON.parse(personModel.get(4).PAGEDATA).czur_wwx//出租人外文姓
//        threeRealJson.Data.czfwxxb.czur_wwm=JSON.parse(personModel.get(4).PAGEDATA).czur_wwm//出租人外文名

////        console.log("@@@@@@@@"+threeRealJson.Data.fwjbxxb.fwdz_mlpdm)
////        console.log("$$$$"+threeRealJson.Data.fwjbxxb.fwdz_dzid)

//        //////////////////以上接受完数据，进行去除空格的操作////
//        var uploadStr = JSON.stringify(threeRealJson)
//        uploadStr = JSL.Trim(uploadStr, 'g')
//        threeRealJson = JSON.parse(uploadStr)
//        /////////////////////////////////////////

//         //基本信息
//         if(threeRealJson.Data.fwjbxxb.fwdz_mlpdm  == ''||threeRealJson.Data.fwjbxxb.fwdz_dzid==""){
//             messagebox.text = '请选择标准房屋地址'
//             messagebox.visible = true
//             return
//         }
//         //房主信息
//         if(threeRealJson.Data.fwjbxxb.fz_zjhm == ''||threeRealJson.Data.fwjbxxb.fz_xm ==""||threeRealJson.Data.fwjbxxb.fz_lxdh==""){
//             messagebox.text = '请补充完整房主信息必填项'
//             messagebox.visible = true
//             return
//         }
//         if(threeRealJson.Data.fwjbxxb.fz_cyzjdm=="111"){
//             if(!JSL.isCardNo(threeRealJson.Data.fwjbxxb.fz_zjhm)){
//                 messagebox.text = '房主身份证号不正确'
//                 messagebox.visible = true
//                 return
//             }
//         }
//         if(!JSL.checkMobile(threeRealJson.Data.fwjbxxb.fz_lxdh )){
//             messagebox.text = "房主联系电话格式不正确"
//             messagebox.visible = true
//             return
//         }
//         //出租房屋为是时
//         if(threeRealJson.Data.fwjbxxb.sfczfw == '1'){//出租
//             //房屋托管人
//             if(threeRealJson.Data.fwjbxxb.tgr_cyzjdm!=""){
//                 if(threeRealJson.Data.fwjbxxb.tgr_zjhm == ''||threeRealJson.Data.fwjbxxb.tgr_xm == ''||threeRealJson.Data.fwjbxxb.tgr_lxdh == ''){
//                     messagebox.text = '请补充完整托管人信息必填项'
//                     messagebox.visible = true
//                     return
//                 }
//                 if(threeRealJson.Data.fwjbxxb.tgr_cyzjdm=="111"){
//                     if(!JSL.isCardNo(threeRealJson.Data.fwjbxxb.tgr_zjhm)){
//                         messagebox.text = '房屋托管人身份证号不正确'
//                         messagebox.visible = true
//                         return
//                     }
//                 }
//                 if(!JSL.checkMobile(threeRealJson.Data.fwjbxxb.tgr_lxdh )){
//                     messagebox.text = "房屋托管人联系电话格式不正确"
//                     messagebox.visible = true
//                     return
//                 }
//             }else{
//                  if(threeRealJson.Data.fwjbxxb.tgr_lxdh!=""){
//                      if(!JSL.checkMobile(threeRealJson.Data.fwjbxxb.tgr_lxdh )){
//                          messagebox.text = "房屋托管人联系电话格式不正确"
//                          messagebox.visible = true
//                          return
//                      }
//                  }
//             }

//             //出租信息
//             if(threeRealJson.Data.czfwxxb.cz_fjs!=""){
//                 if(threeRealJson.Data.fwjbxxb.fwjs==""){
//                     messagebox.text = '请补充基本信息的房间间数'
//                     messagebox.visible = true
//                     return
//                 }else{
//                     if(Number(threeRealJson.Data.czfwxxb.cz_fjs)-Number(threeRealJson.Data.fwjbxxb.fwjs)>0){
//                         messagebox.text = '出租间数不能大于实际间数'
//                         messagebox.visible = true
//                         return
//                     }
//                 }
//             }
//             if(threeRealJson.Data.czfwxxb.cz_mjpfm!=""){
//                 if(threeRealJson.Data.fwjbxxb.fwmj_mjpfm==""){
//                     messagebox.text = '请补充基本信息的房屋面积'
//                     messagebox.visible = true
//                     return
//                 }else{
//                     if(Number(threeRealJson.Data.czfwxxb.cz_mjpfm)-Number(threeRealJson.Data.fwjbxxb.fwmj_mjpfm)>0){
//                         messagebox.text = '出租面积不能大于实际面积'
//                         messagebox.visible = true
//                         return
//                     }
//                 }
//             }
//             if(threeRealJson.Data.czfwxxb.zrs_qd_rq==""){
//                 messagebox.text = '请补充完整出租信息必填项'
//                 messagebox.visible = true
//                 return
//             }

//             //出租人信息
//             if(threeRealJson.Data.czfwxxb.czur_zjhm == ''||threeRealJson.Data.czfwxxb.czur_xm == ''||threeRealJson.Data.czfwxxb.czur_lxdh == ''||threeRealJson.Data.czfwxxb.czur_yfzgx_rygxdm == ''){
//                 messagebox.text = '请补充完整出租人信息必填项'
//                 messagebox.visible = true
//                 return
//             }
//             if(!JSL.checkMobile(threeRealJson.Data.czfwxxb.czur_lxdh )){
//                 messagebox.text = "出租人联系电话格式不正确"
//                 messagebox.visible = true
//                 return
//             }
//             if(threeRealJson.Data.czfwxxb.czur_cyzjdm=="111"){
//                 if(!JSL.isCardNo(threeRealJson.Data.czfwxxb.czur_zjhm)){
//                     messagebox.text = '出租人身份证号不正确'
//                     messagebox.visible = true
//                     return
//                 }
//             }
//         }

//        if(isSaved){
//            //存储JSON
//            var url ="http://"+goIpPort+"/save"
//            var uploadStr = JSON.stringify(threeRealJson)
//            uploadStr = JSL.Trim(uploadStr, 'g')
//            //console.log("存储的总信息-------："+uploadStr)
//            operatehttp.post(url, function(code, data){
//                console.log("存储信息结果：", code)
// 				if(code==200){
//                    messagebox.text = '数据保存成功'
//                    messagebox.visible = true
//                    emit: finishToEveryControl()
//                    builDocument()
//                    //锚点定位
//                    basic_ui.positionViewAtIndex(0, ListView.Beginning)
//                }
//            },"(0)="+uploadStr)
//        }else{
//            if(!isFinished){ //点击返回按钮，数据不符合保存条件，则不保存数据直接跳转回上一层
//                //stackView.pop()
//            }
//        }
//    }

//    Audio{
//        id: readCardSound
//        source: "qrc:/sounds/sounds/readCard.wav"
//    }

//    //二代证扫描结束
//    Connections{
//        target: readIdcard
//        onReadIdcardFinished: {
//            if(!popWindow.visible){
//                temIdcardInfo = JSON.parse(idcardInformation)
//                if(temIdcardInfo.name != "" && temIdcardInfo.idcard != "")
//                {
//                    //播放声音
//                    readCardSound.play()
//                    //弹出窗口提示
//                    idcardName = temIdcardInfo.name
//                    idcardWindowLabel.text="读到["+idcardName+"]的二代证信息，填入下列哪些模块："
//                    idcardWindow.visible = true
//                }
//            }
//        }
//    }

//    queding.onClicked: {
//        if(!fangzhu.checked && !chuzuren.checked && !tuoguanren.checked){ //什么都没选
//            messagebox.text = '请至少选择一个模块'
//            messagebox.visible = true
//            return
//        }

//        if(fangzhu.checked){
//            emit : initInfoMsg(temIdcardInfo, "OwnerInfoPage")//初始化信息
//        }

//        if(chuzuren.checked){
//            if(fangzhu.checked){
//                emit : initInfoMsg("房主本人", "LessorInfoPage")//初始化信息
//            }
//            else{
//                emit : initInfoMsg(temIdcardInfo, "LessorInfoPage")//初始化信息
//            }
//        }

//        if(tuoguanren.checked){
//            if(fangzhu.checked){
//                emit : initInfoMsg("房主本人", "CustodianInfoPage")//初始化信息
//            }
//            else{
//                emit : initInfoMsg(temIdcardInfo, "CustodianInfoPage")//初始化信息
//            }

//        }

//        idcardWindow.visible = false

//    }

//    idcardWindow.onVisibleChanged: {
//        if(idcardWindow.visible){
//            roomPage.enabled = false //瀑布流不可用 防止乱点
//            back.enabled = false
//            finish.enabled = false

//            idcardName = ""
//            fangzhu.checked = false
//            chuzuren.checked = false
//            tuoguanren.checked = false
//            chuzuren.enabled = true
//            tuoguanren.enabled = true

//            if(isHouseLet == "否"){
//                fangzhu.checked = true
//                chuzuren.enabled = false
//                tuoguanren.enabled = false
//            }

//        }
//        else{
//            roomPage.enabled = true //瀑布流变可用
//            back.enabled = true
//            finish.enabled = true
//        }
//    }

//    popWindow.onVisibleChanged: {
//        if(popWindow.visible){
//            roomPage.enabled = false //瀑布流不可用 防止乱点
//            back.enabled = false
//            finish.enabled = false
//        }
//        else{
//            roomPage.enabled = true //瀑布流变可用
//            back.enabled = true
//            finish.enabled = true
//        }
//    }

//    Connections{
//        target: mainQml
//        onInitInfoMsg: {
//            if(casecadeName == "BaseInfoPage"){ // 基础信息模块传递回来的 是否出租房屋信息
//                isHouseLet = initInfo
//            }
//        }
//    }




//    //添加房屋相关人信号
//    onAddBtnClicked:{
//        if(addressInfo.address == undefined || addressInfo.address == ""){
//            messagebox.text = "请先选择房屋地址"
//            messagebox.visible = true
//        }else{
//            builDocument()
//            stackView.push({item:"qrc:/wholeFunction/uiCommunity/ThreeRealPersonPage.qml",
//                      properties:{entryPageMode:QmlData.VISIT_TYPE_INCREASE,
//                                  colloctType:QmlData.INTO_TYPE_THREEREAL_PERSION,
//                                  isFromRoom:true,
//                                  addressInfo:addressInfo}})
//        }
//    }
//    //修改按钮被点击
//    onChangeBtnClicked:{
//        var changeObj = JSON.parse(changeInfo)
//        builDocument()
//        stackView.push({item:"qrc:/wholeFunction/uiCommunity/ThreeRealPersonPage.qml",
//                  properties:{entryPageMode:QmlData.VISIT_TYPE_MODIFY,
//                              colloctType:QmlData.INTO_TYPE_THREEREAL_PERSION,
//                              isFromRoom:true,
//                              addressInfo:addressInfo,
//                              initJson:changeObj.Data}})
//    }
 }
