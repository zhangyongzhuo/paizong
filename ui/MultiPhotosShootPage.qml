import QtQuick 2.5
import QtMultimedia 5.5
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL

MultiPhotosShootPageForm {
    property Camera camera: null
    property int photocount : 1  //拍摄照片数量
    property string receivePageName : "" //接受拍照完成信号的界面名称
    property string facepath: facepath
    property var photoDisplylist:[]  //点击完成时通过信号返回给上层页面的数据  写实拍照
    property var pList:[]            //传入照片

    Component.onCompleted: {
        photoModel.clear()
        if(pList.length==0){
            photoNumber.text="0/5"
        }else{
            for(var i=0; i<pList.length; i++){
                photoModel.append({value: pList[i]})
            }
            photoNumber.text=pList.length+"/5"
        }

        cameraLoader.initCamera = operateconfigfile.getCameraInitNum()

    }

    cameraLoader.onItemLoaded: {
        camera = cam
        camera.deviceId = QtMultimedia.availableCameras[cameraLoader.initCamera].deviceId
    }

    finish.onClicked:{
        if(photoModel.count==0){
            messagebox.text = "请拍摄照片"
            messagebox.visible = true
            return
        }
        //取出所有拍摄的照片
        photoDisplylist = []
        for(var i=0; i<photoListView.count; i++){
            photoDisplylist.push(photoModel.get(i).value)
        }

        emit: multiPhotosShotFinished(photoDisplylist, receivePageName)
        stackView.pop()

    }

    Connections{
        target: camera.imageCapture
        onImageSaved: {
            if(photocount==1){
                facepath=path
                photoModel.clear()
            }
            if(photoModel.count<5){
                photoModel.append({value: "file:///"+path})
                photoNumber.text=photoModel.count+"/5"
            } else {
                messagebox.text = "照片不超过5张"
                messagebox.visible = true
                return
           }
        }
    }

    shoot.onClicked: {
        if(receivePageName=="WorkReportedPage"||receivePageName=="RealisticPage"){
            if(photoModel.count<5){
                camera.imageCapture.captureToLocation(documentDir)
            }else{
                messagebox.text = "照片不超过5张"
                messagebox.visible = true
                return
            }
        }else{
             camera.imageCapture.captureToLocation(documentDir)
        }
    }
}
