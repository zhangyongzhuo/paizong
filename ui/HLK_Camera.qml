import QtQuick 2.4
import QtMultimedia 5.4


VideoOutput{
    property alias camera: camera
    property int   initCamera:0

    property alias changeFlash: changeFlash
    property alias changeCamera: changeCamera

    width: 640
    height: 480
    source: camera

    property var cameraInfoList //摄像头信息 是个list<object>
    property var cameraNum      //摄像头个数
    Component.onCompleted: {
        //页面初始化的时候检查摄像头个数
        cameraInfoList = QtMultimedia.availableCameras
        //没有或者有一个摄像头 则隐藏切换摄像头按钮
        cameraNum = cameraInfoList.length

        //console.log('----摄像头个数：'+cameraNum)

        if(cameraNum < 2)
            changeCamera.visible = false
        else
            changeCamera.visible = true
    }

    HLK_StateButton{
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
                console.log("open flash")
            }
            else{
                camctrl.stop()
                console.log("close flash")
            }
        }
    }


    HLK_StateButton{
        id:changeCamera

        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        normal_image: "qrc:/images/images/camera_change1.png"
        checked_image:"qrc:/images/images/camera_change2.png"

        enabled: (camera.cameraState/2)===1 ? true : false

        onClicked: {

            initCamera++
            initCamera %= cameraNum     //除余initCamera/cameraNum的余数
            camera.deviceId = cameraInfoList[initCamera].deviceId

            initCamChanged(initCamera)
            console.log("发送变化信号  ",initCamera)
        }
    }


    Camera{
        id: camera
        flash.mode: Camera.FlashOff
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        viewfinder.resolution{
            width:  640
            height: 480
        }
    }
}
