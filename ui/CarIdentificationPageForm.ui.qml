import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

HLK_BasePage{
    pageTitle: "拍照识别"
    property alias shot: shot
    property alias cameraLoader: cameraLoader
    property alias carIndicator: carIndicator
    property alias car_number: car_number
    property alias messagebox: messagebox

    Rectangle {
        x: 20
        y: 100
        width: 1235
        height: 400
        color: "#FFFFFF"
        radius: 10
        Rectangle {
            anchors.centerIn: parent
            width: 480
            height: 360

            HLK_CameraLoader{
                id: cameraLoader
                anchors.fill: parent
            }

            BusyIndicator{
                id: carIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                running: false
            }
        }

        HLK_ImageButton{
            id: shot
            x: 1000
            anchors.verticalCenter: parent.verticalCenter
            imagePath: "qrc:/images/images/camera2.png"
            imagePressePath:"qrc:/images/images/camera1.png"
            visible: false
        }
    }

    Rectangle{
        x: 20
        y: 620
        width: 1235
        height: 130
        color: "#FFFFFF"
        radius: 10

        Row{
            anchors.centerIn: parent
            width: 410
            spacing: 20
            Text{
                y: 10
                text: "车牌号:"
                font.pixelSize: 24
                font.family: "黑体"
                color: "#000000"
                width: 80
            }
            HLK_TextEdit{
                id: car_number
                width: 330
            }

        }
    }
    HLK_MessageBox{
        id: messagebox
    }
}

