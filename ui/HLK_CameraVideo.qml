import QtQuick 2.4
import QtMultimedia 5.4

//录像
VideoOutput{
    property alias camera: camera
    property alias changeFlash: changeFlash
    property alias changeCamera: changeCamera
    property var cameraInfoList
    property var cameraNum
    property int initCamera: 0
    property var resolution
    width: 640
    height: 480
    source: camera

    Component.onCompleted: {
        //页面初始化的时候检查摄像头个数
        cameraInfoList = QtMultimedia.availableCameras
        //没有或者有一个摄像头 则隐藏切换摄像头按钮
        cameraNum = cameraInfoList.length
        if(cameraNum < 2)
            changeCamera.visible = false
        else
            changeCamera.visible = true
    }

    HLK_StateButton{//摄像头灯光
        id:changeFlash
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        normal_image: "qrc:/images/images/led_close.png"
        checked_image:"qrc:/images/images/led_open.png"
        enabled: (camera.cameraState/2)===1 ? true : false
        onCheckedChanged: {
            if(checked){
                camctrl.start()
            }
            else{
                camctrl.stop()
            }
        }
    }

    HLK_StateButton{//摄像头切换
        id:changeCamera
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        normal_image: "qrc:/images/images/camera_change1.png"
        checked_image:"qrc:/images/images/camera_change2.png"
        enabled: (camera.cameraState/2)===1 ? true : false
        onClicked: {
            initCamera++
            initCamera %= cameraNum
            camera.deviceId = cameraInfoList[initCamera].deviceId
            initCamChanged(initCamera)
        }
    }

    Camera{//摄像头
        id: camera
        captureMode: Camera.CaptureVideo
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction
        viewfinder.resolution.width:640
        viewfinder.resolution.height:480
        videoRecorder {
            onRecorderStateChanged: {
                console.log("########################onRecorderStateChanged: " + videoRecorder.recorderState);
                if (videoRecorder.recorderState === CameraRecorder.StoppedState) {
                    console.log("actualLocation: " + videoRecorder.actualLocation);
                    myvideo.source =  videoRecorder.actualLocation;
                }
            }
        }
        videoRecorder.audioEncodingMode: CameraRecorder.ConstantBitrateEncoding
        videoRecorder.audioBitRate: 128000
        videoRecorder.mediaContainer: "mp4"
        videoRecorder.outputLocation: "D:/a.mp4"

        Component.onCompleted: {
            resolution = camera.viewfinder.resolution
            console.log("resolution: " + resolution.width + " " + resolution.height)
            console.log("deviceId: " + camera.deviceId)
        }

    }

}
