import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Button {
    property int btnWidth: 70
    property int btnHeight: 24
    property bool btnVisible: true
    property string btnColor: "#00AECC"   //true蓝色 false橘色  ? "#00AECC" : "#FF943E"
    property string btnText: ""


    width:btnWidth
    height:btnHeight

    visible:btnVisible
    style: ButtonStyle{
        background: Rectangle{
            radius: 11
            color: btnColor
            Text {
                text: btnText
                font.pixelSize: 16
                font.family: "SimHei"
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}


