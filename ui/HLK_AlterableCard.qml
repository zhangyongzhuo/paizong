import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Rectangle{
    property string imgPath: "qrc:/images/images/hcjg.png"
    property string cardColor: "#EEEEEE"
    property string cardName: ""
    property string baseColor: "#EEEEEE"
    property bool visibleImgPath: true
    property bool visibleCenterText: false
    property string centerText: ""
    property bool deleteEnable: false
    signal deleteButtonClicked()
    radius: 10
    width: 170
    height: 220
    border.width: 1
    border.color: cardColor
    color: "#00000000"
    clip: true

    Rectangle{
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 1
        width: parent.width-2
        height: 180
        anchors.horizontalCenter: parent.horizontalCenter
        color: baseColor
        clip: true
        Image{
            visible: visibleImgPath
            source: imgPath
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        Text{
            visible: visibleCenterText
            text: centerText
            font.family: "SimHei"
            font.pixelSize: 40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        HLK_SimpleImageButton{
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            normal_path: "qrc:/images/images/tb002-2.png"
            checked_path: "qrc:/images/images/tb002-2.png"
            width: 20
            height: 20
            visible: deleteEnable
            onClicked: {
                emit: deleteButtonClicked()
            }
        }
    }
    Rectangle{
        z: 1
        anchors.top: parent.top
        anchors.topMargin: 165
        width: parent.width-2
        height: 13
        anchors.horizontalCenter: parent.horizontalCenter
        color: baseColor
        anchors.horizontalCenterOffset: 0
    }
    Rectangle{
        radius: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width
        height: 50
        color: cardColor
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            font.family: "SimHei"
            font.pixelSize: 20
            color: "#FFFFFF"
            text: cardName
        }
    }
}
