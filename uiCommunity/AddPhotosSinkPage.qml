import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
import "qrc:/cascade/uiCommunity"
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

//照片采集界面--三实采集<照片>模块使用

AddPhotosSinkPageForm {
    property var pageDataJsonObject:PublicDataJson.getFaceInfoJson()

    Component.onCompleted: {
        photoDisplyViewModel.clear()
        //瀑布流传递过来的初始化值
        if(PAGEDATA != undefined){
            if(PAGEDATA!=""){
                pageDataJsonObject=JSON.parse(PAGEDATA)
                photoDisplyViewModel.clear()
                for(var i=0; i<pageDataJsonObject.photoPath.length; i++){
                    photoDisplyView.visible=true
                    photoDisplyViewModel.append({photopath:getPhotoPath(pageDataJsonObject.photoPath[i])})
                }
            }
        }
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            shotBtn.enabled=false
            delvisible=false
        }
    }

    shotBtn.onClicked: {
        emit: boxAreaOpend(PAGENAME)
        getFocus.focus = true
        stackView.push({item: "qrc:/singleFunction/ui/MultiPhotosShootPage.qml", properties:{photocount: 1,receivePageName:"AddPhotosSinkPage"}})
    }

    Connections{
        target: mainQml

        onMultiPhotosShotFinished:{
             if(receivePageName=="AddPhotosSinkPage"){
                //console.log("收到人脸拍照回复："+result)
                photoDisplyViewModel.clear()
                photoDisplyView.visible=true
                 var obj = JSON.parse(JSON.stringify(result))   //拍照按钮点击进去的拍照页面完成时返回的照片路径数据
                 for(var i=0; i<obj.length; i++){
                    photoDisplyViewModel.append({photopath: obj[i]})//加载返回的照片
                 }

             }
        }

        onFillInfoMsg:{
            pageDataJsonObject.photoPath = []
            for(var i=0; i<photoDisplyViewModel.count; i++){

                var imagePath
                if(qmlData.isContainKey(photoDisplyViewModel.get(i).photopath,"file:"))
                    imagePath = qmlData.cutStr(photoDisplyViewModel.get(i).photopath, 8, 0)
                else
                    imagePath = ""
               // pageDataJsonObject.photoPath[i] = imagePath
            }
            if(imagePath==""){
                PAGEDATA=""
            }else{
                PAGEDATA =qmlData.transformImage2Base64(imagePath)
            }
            //console.log('=========page:'+PAGEDATA)
        }

        onFinishToEveryControl:{//清空所有
            photoDisplyViewModel.clear()
        }
    }
    function getPhotoPath(photoPath){
        var tempPhotoPath = ''
        //if(photoPathList.length > 0 && photoPathList[0] != ''){
            if(qmlData.isContains(photoPath, 'http')){ //网络路径
                tempPhotoPath = photoPath
            }else{
                tempPhotoPath = 'file:///' + photoPath
            }
        //}else{
        //    tempPhotoPath = 'qrc:/images/images/renyuan.png'
        //}
        //console.log('照片路径', tempPhotoPath)
        return tempPhotoPath
    }
}
