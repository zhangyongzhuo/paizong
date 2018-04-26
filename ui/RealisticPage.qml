import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

//写实界面---反恐利剑、维稳核查、社区采集中使用

RealisticPageForm {
    property var markList: []
    property int markI: 0
    Component.onCompleted: {
//        modelRe=["身份信息可疑", "没有护照", "证件不全", "在逃人员", "扣留口流利",
//                 "事实上是事实是事实", "没有护照", "证件不全", "在逃人员", "扣留口流利", "事实上是事实是事实"]
        //瀑布流传递过来的初始化值
        if(PAGEDATA != undefined){
            var obj=JSON.parse(PAGEDATA)
            //加载照片
            photoDisplyViewModel.clear()
            photoDisplyView.visible = true
            for(var i=0; i<obj.photoPath.length; i++){
                var tempPhotoPath = ''
                if(qmlData.isContains(obj.photoPath[i], 'http')){ //网络路径
                    tempPhotoPath = obj.photoPath[i]
                }else{
                    tempPhotoPath = 'file:///' + obj.photoPath[i]
                }
                photoDisplyViewModel.append({photopath:tempPhotoPath})//初始化照片区域
            }
            realistictext.text=obj.text//初始化写实
        }

        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            takephoto.enabled=false
            realistictext.enabled=false
            realistictext.modehint = ''
            delvisible=false
        }
        else{
            var url="http://"+goIpPort+"/v3/newLabel/"+PAGETYPE
            console.log("写实标签获取："+url)
            operatehttp.get(url, function(code, data){
                if(code == 200){
                    var obj = JSON.parse(data)
                    for(var i=0;i<obj.length;i++){
                        markList.push(obj[i].content)
                    }
                    modelRe=markList

                }else{
                    console.log('获取写实标签失败：'+code)
                }
            })
        }

        cnpTimer.start()
    }
    Timer{
        id: cnpTimer
        interval: 100
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            if(grid.height!=0){
                realis.height=isX6 ?(670 + grid.height):(410 + grid.height)

            }else{
                realis.height=isX6 ?(700 + grid.height):(430 + grid.height)
            }
            realHeight=realis.height
            PAGEHEIGHT=realHeight
            cnpTimer.stop()
        }

    }
    Connections{
        target: mainQml
        onFillInfoMsg:{
            var fillInfoJsonObject = PublicDataJson.getPaintRealInfo()
            for(var i=0; i<photoDisplyView.count; i++){
                var temp
                if(qmlData.isContainKey(photoDisplyViewModel.get(i).photopath,"file:"))
                    temp = qmlData.cutStr(photoDisplyViewModel.get(i).photopath, 8, 0)
                else
                    temp = ""
                fillInfoJsonObject.photoPath[i]=temp//保存照片路径数据
            }
            fillInfoJsonObject.text = realistictext.text  //保存写实数据
            PAGEDATA = JSON.stringify(fillInfoJsonObject)
        }
        onMultiPhotosShotFinished:{
            if(receivePageName==""+PAGETYPE){
                var obj = JSON.parse(JSON.stringify(result))   //拍照按钮点击进去的拍照页面完成时返回的照片路径数据
                if(obj!==""){
                    //photoDisplyViewModel.clear()
                    photoDisplyView.visible=true
                    for(var i=0;i<obj.length;i++){
                        photoDisplyViewModel.append({photopath:obj[i]})//加载返回的照片
                    }
                }
            }
        }
        onInitInfoMsg:{
            if(casecadeName == "CounterTerrorismSword" || casecadeName == "TemporaryInterrogation") { //带file:///
                console.log("写实模块--人证比对过来的照片:"+initInfo)
                photoDisplyViewModel.insert(0,{photopath:initInfo})
            }
        }
        onClearAllData:{
             realistictext.text=""
             photoDisplyViewModel.clear()
        }
    }


    takephoto.onClicked: {
        getFocus.focus = true
        stackView.push({item: "qrc:/singleFunction/ui/MultiPhotosShootPage.qml", properties:{photocount: 10,receivePageName:""+PAGETYPE}})
    }

    realistictext.onCursorVisibleChanged: {
        if(realistictext.cursorVisible == true){
            realistictext.hint=''
        }else{
            realistictext.hint='写实最多输入字符不超过三行'
        }
    }

}
