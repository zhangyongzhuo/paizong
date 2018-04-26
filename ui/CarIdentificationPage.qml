import QtQuick 2.4
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL

CarIdentificationPageForm {
    property bool bCameraPreview: true;
    property Camera camera: null

    OcrCar{
        id:ocrcar
    }

    Audio{
        id: readCardSound
        source: "qrc:/sounds/sounds/readCard.wav"
    }

    Component.onCompleted: {
        shot.visible = true
        //将配置文件中的默认摄像头传给loader
        cameraLoader.initCamera=operateconfigfile.getCameraInitNum()
    }

    cameraLoader.onItemLoaded: {
        camera = cam
        //加载完摄像头后 将其切换到默认摄像头
        camera.deviceId=QtMultimedia.availableCameras[cameraLoader.initCamera].deviceId
        startCam()
        //startShot()
    }

    finish.onClicked:{
        if(!JSL.isVehicleNumber(car_number.text)){
            messagebox.text = "车牌号码不正确"
            messagebox.visible = true
            return
        }
        emit: plateNumberDentificationFinish(car_number.text) //车牌信息采集成功
        stackView.pop()
    }

    Connections{
        target: camera.imageCapture
        onImageSaved: {
            carIndicator.running = true
            ocrcar.getCarPhotoInfo(path)
        }
    }

    //拍照按钮点击
    shot.onClicked: {
        if(bCameraPreview){
            startShot()
        }
        else{
            startCam()
            startShot()
        }
    }
    //唤醒摄像头
    function startCam(){
        bCameraPreview = true
        camera.start()
    }

    //执行拍照动作
    function startShot(){
        camera.imageCapture.captureToLocation(documentDir+"/CarNumber")
        bCameraPreview = false
    }

    Connections{
        target: ocrcar
        onOcrCarfinished:{
            readCardSound.play()
            carIndicator.running = false
            shot.visible = true
            console.log("车辆识别OCR完成："+licenseNumber)
            car_number.text = licenseNumber
        }

        onOcrCarnotify:{
            console.log("车辆识别OCR错误："+msg)
            messagebox.text = "车辆识别OCR错误"
            messagebox.visible = true
            shot.visible = true
            carIndicator.running = false
            startCam()
        }
    }
}
