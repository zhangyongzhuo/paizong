import QtQuick 2.0
import "qrc:/base/js/common.js" as JSL
//卡片风格的相框，用于人工辅助
HLK_Border{
    width: 143
    height: 183
    property bool checked: false
    property string photosource:""
    property string phototext:""
    property bool canChecked: true
    property string textColor: "white"
    property bool delEnable: false
    signal deleteButtonClicked()

    Rectangle{
        width: 143
        height: 183
        radius: 10
        color: "#EEEEEE"

        Image{
            width: 72
            height: 116
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            source:photosource
        }
        Text{
            id: name
            text: phototext
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            font.pixelSize: 20
            color: textColor
            font.family: "SimHei"
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
            visible: delEnable
            onClicked: {
                emit: deleteButtonClicked()
            }
        }
    }
}
