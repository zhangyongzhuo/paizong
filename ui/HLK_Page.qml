import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

//主页
Item{
    property string nextPage  : ""
    property string pageTitle : "黑龙江基础信息采集平台"
    property string themeColor: JSL.themeColor()
    property string policeName: "盖伦"
    property alias exitBtn: exitBtn

    width: 1280
    height: 768

    Rectangle{//页头
        width: parent.width
        height: 80
        color: themeColor

        Text {//标题
            id: title
            color: "white"
            text: pageTitle
            font.pixelSize: 26
            font.family: "SimHei"
            font.bold: true
            x: 30
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {//头像
            id: faceImg
            width: 60
            height: 60
            radius: width/2
            color: themeColor
            anchors.right: parent.right
            anchors.rightMargin: 330
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: _image
                cache: false
                smooth: true
                visible: false
                anchors.fill: parent
                source: "qrc:/images/images/home_user0.png"
                sourceSize: Qt.size(parent.size, parent.size)
                antialiasing: true
                width: 100
                height: 100
            }
            Rectangle {
                id: _mask
                color: "black"
                anchors.fill: parent
                radius: width/2
                visible: false
                antialiasing: true
                smooth: true
            }
            OpacityMask {
                id:mask_image
                anchors.fill: _image
                source: _image
                maskSource: _mask
                visible: true
                antialiasing: true
            }
        }
        Text {
            id: name
            anchors.right: parent.right
            anchors.rightMargin: 280
            anchors.verticalCenter: parent.verticalCenter
            color: "#FFFFFF"
            text: policeName
            font.pixelSize: 20
            font.family: "黑体"
        }
        Rectangle{
            width: 1
            height: 30
            color: "#6FE0F1"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 250
        }

        HLK_ToolButton{
            id: newsBtn
            //x: faceImg.x + 265
            anchors.right: parent.right
            anchors.rightMargin: 145
            anchors.verticalCenter: parent.verticalCenter
            imgPath: "qrc:/images/images/home_news.png"
            btnText: "消息"
        }

        Rectangle{
            width: 1
            height: 30
            color: "#6FE0F1"
            anchors.right: parent.right
            anchors.rightMargin: 135
            anchors.verticalCenter: parent.verticalCenter
        }

        HLK_ToolButton{
            id: exitBtn
            //x: faceImg.x + 265
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            imgPath: "qrc:/images/images/home_exit.png"
            btnText: "退出";
        }
    }


}





