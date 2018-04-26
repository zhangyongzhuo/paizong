import QtQuick 2.0
import "qrc:/base/js/common.js" as JSL
//卡片风格的相框，用于人工辅助
HLK_Border{
    property bool checked: false
    property string photosource:""
    property string phototext:""
    property bool canChecked: true
    property bool delEnable: false
    signal deleteButtonClicked()
    signal checkedButtonClicked(bool select)
    width: 143
    height: 183

    Rectangle{
        x:0
        y:0
        width: 143
        height: 183
        border.width: 1
        border.color:JSL.themeColor()
        color: "white"
        Column{
            spacing: 1
            y:2
            anchors.horizontalCenter: parent.horizontalCenter
            Image{
                id:photoimage
                width: 141
                height: 143
                source:photosource

                Image{
                    source: "qrc:/images/images/ico1.png"
                    anchors.centerIn: parent
                    visible: canChecked?checked:false
                    width:90
                    height:86
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        checked = !checked
                        emit: checkedButtonClicked(checked)
                    }
                }
            }
            Text{
                id: name
                text: phototext
                height:38
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
                color:JSL.themeColor()
                font.family: "微软雅黑"
            }
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
