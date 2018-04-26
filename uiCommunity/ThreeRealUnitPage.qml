import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealUnit.js" as ThreeReal_OBJECT

ThreeRealUnitPageForm {

    property var threeRealJson : ThreeReal_OBJECT.getJsonObject()
    property int    colloctType:0           //数据采集类型 值为枚举 qmldata中有定义
    property int    entryPageMode: 0        //1增加 2删除 3修改 4查看 值为枚举 qmldata中有定义
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
        personModel.append({PAGENAME: "BaseInfoUnitPage",     //基本信息
                             PAGEHEIGHT: 870,
                             PAGENO: 0,
                             PAGETITLE:"基本信息",
                             PAGETOPLINE: false,
                             PAGEBOTTOMLINE:false,
                             enable: true,
                             PAGEDATA: ''})

        personModel.append({PAGENAME: "AddPhotosSinkPage", //写实模块（需要改造）
                               PAGEHEIGHT: isX6 ? 370 : 190,
                               PAGENO: 0,
                               PAGELOCAL: false,
                               PAGETITLE: "照片",
                               PAGEBOTTOMLINE: false,
                               enable: false,
                               PAGEDATA: JSON.stringify(threeRealJson.Data.unitInfo)})


        personModel.append({PAGENAME: "BottomInfoPage", //底部占位模块
                               PAGEHEIGHT:220,
                               PAGENO: 0,
                               PAGELOCAL: false,
                               PAGETITLE:"占位模块",
                               PAGEBOTTOMLINE:false,
                               enable: false,
                               PAGEDATA: ''})

    }
    //当点击"完成"按钮时，给子页面发送完成信号 让白流填充Json
    finish.onClicked:{
        getFocus.focus = true
        //填充采集信息
        emit: fillInfoMsg("ThreeRealPersonPage")
        fillInfoAndSave(true)
    }

    back.onClicked:{
        getFocus.focus = true
        if(entryPageMode==QmlData.VISIT_TYPE_INCREASE ||
                entryPageMode==QmlData.VISIT_TYPE_MODIFY){
            popWindow.visible = true
        }
    }

    popWindow.onVisibleChanged: {
        if(popWindow.visible){
            unitPage.enabled = false
            back.enabled = false
            finish.enabled = false
        }
        else{
            back.enabled = true
            finish.enabled = true
            unitPage.enabled = true

        }
    }
    Connections{
        target: mainQml
        onUnitEnable:{
            unitPage.enabled = status
            back.enabled = status
            finish.enabled = status
        }
    }

    function fillInfoAndSave(isFinished){

        var isSaved = true

        if(isFinished){//点击完成 此时上传状态为待上传
            threeRealJson.IsUpload = 0
        }else{
            threeRealJson.IsUpload = -1
        }
        threeRealJson.OptargetId = documentID
        threeRealJson.PoliceIdcard = policeIdCard
        threeRealJson.DataType = colloctType
        threeRealJson.Data.userid=userName//登陆用户
        threeRealJson.Data.orgjb=operateconfigfile.getOrgJb()//登陆用户所属组织机构级别
        threeRealJson.Data.orgid=operateconfigfile.getOrgId()//登陆用户所属组织机构ID
        threeRealJson.Data.menuname="实有单位管理"//登陆用户所含菜单权限

        threeRealJson.Data.dwjbxxb=JSON.parse(personModel.get(0).PAGEDATA)
        threeRealJson.Data.dwjbxxb.xp=personModel.get(1).PAGEDATA
        //threeRealJson.Data.Echo= echoObject

        //////////////////以上接受完数据，进行去除空格的操作////
        var uploadStr = JSON.stringify(threeRealJson)
        uploadStr = JSL.Trim(uploadStr, 'g')
        threeRealJson = JSON.parse(uploadStr)
        /////////////////////////////////////////

        if(threeRealJson.Data.dwjbxxb.dwmc==""){
            messagebox.text = '请填写单位名称'
            messagebox.visible = true
            return
        }

        if(threeRealJson.Data.dwjbxxb.gllxdm==""){
            messagebox.text = '请至少选择一个管理类型'
            messagebox.visible = true
            return
        }
        if(threeRealJson.Data.dwjbxxb.dwlbdm==""){
            messagebox.text = '请选择单位类别'
            messagebox.visible = true
            return
        }

        if(threeRealJson.Data.dwjbxxb.lxdh!=""){
            if(!JSL.checkMobile(threeRealJson.Data.dwjbxxb.lxdh)){
                messagebox.text = "联系电话格式不正确"
                messagebox.visible = true
                return
            }
        }

        if(threeRealJson.Data.dwjbxxb.dz_dwdzmlpdm  == ''||threeRealJson.Data.dwjbxxb.dz_dwdzdm==""){
            messagebox.text = '请选择单位标准地址'
            messagebox.visible = true
            return
        }

        if(isSaved){
            //存储JSON
            var url ="http://"+goIpPort+"/save"
            var uploadStr = JSON.stringify(threeRealJson)
            uploadStr = JSL.Trim(uploadStr, 'g')
            //console.log("存储的总信息实有单位-------："+uploadStr)
            operatehttp.post(url, function(code, data){
                console.log("存储信息结果：", code)
   				if(code==200){
                    messagebox.text = '数据保存成功'
                    messagebox.visible = true
                    emit: finishToEveryControl()
                    builDocument()
                    //锚点定位
                    basic_ui.positionViewAtIndex(0, ListView.Beginning)
                }
            },"(0)="+uploadStr)
        }else{
            if(!isFinished){ //点击返回按钮，数据不符合保存条件，则不保存数据直接跳转回上一层
                //stackView.pop()
            }
        }
    }

 }
