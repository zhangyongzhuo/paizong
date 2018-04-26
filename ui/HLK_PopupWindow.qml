import QtQuick 2.0
import "qrc:/base/js/common.js" as JSL

Rectangle{
    property string popupWindowTitle: ""
    property string themeColor: JSL.themeColor()
    property alias controlArea: controlArea
    property bool isShowClose: false
    property int windowHeight: 200
    property int popWidth:500

    id: popupWindow

    width: 1280
    height: 768
    color: "#99000000"
    Rectangle{
        id: controlArea
        anchors.centerIn: parent
        width: popWidth
        height: windowHeight
        color: "#FFFFFF"
        radius: 10

        Text{
            id: title
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            text: popupWindowTitle
            color: themeColor
            font.family: "SimHei"
            font.pixelSize: 24
        }

        HLK_SimpleImageButton{
            id: close
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            normal_path: "qrc:/images/images/close_2.png"
            checked_path: "qrc:/images/images/close_1.png"
            onClicked: {
                popupWindow.visible = false
            }
            visible: isShowClose
        }

        Rectangle{
            y: 20 + title.height + 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: popWidth-40
            height: 1
            color: "#DBDBDB"
        }
    }
}

