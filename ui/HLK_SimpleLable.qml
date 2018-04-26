import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Rectangle{
    property string redColor: "#F12929"
    property string orangeColor: "#FF8400"
    property string yellowColor: "#F7CC22"
    property string blueColor: "#00AECC"
    property string ctrlColor: ""
    property string ctrlText: ""
    property int ctrlWidth: 0
    border.color: ctrlColor
    border.width: 1
    height: 45
    width: ctrlWidth + 40
    Text{
        id: txt
        font.family: "SimHei"
        font.pixelSize: 22
        anchors.centerIn: parent
        color: ctrlColor
        text: ctrlText
    }

}
