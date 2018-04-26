import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Rectangle {
    width: itemwidth
    height: 200
    border.color: themeColor
    border.width: 1
    property int itemwidth: 220
    property string rowone: ""
    property string rowtwo: ""
    property string rowthree: ""
    property bool delEnable: false
    signal deleteButtonClicked()
    Column {
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin:20
        spacing: 20
        Text{
            width: 250
            height: 50
            font.family: "SimHei"
            font.pixelSize: 28
            color: JSL.themeColor()
            text: rowone
        }
        HLK_NormalText{
            text: rowtwo
        }
        HLK_NormalText{
            text: rowthree
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
