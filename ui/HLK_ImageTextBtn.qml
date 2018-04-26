import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    property string checked_image: ""
    property string normal_image: ""
    property string btnText: ""
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool   mute: false

    id: btn
    height:40
    width: 130
    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#FFFFFF"
           // border.width: 1//pressed ? 1 : 0
           // border.color: pressed ? themeColor : "#EDEDED"
            layer.enabled: pressed ? true : false
            layer.effect: DropShadow {
                transparentBorder: true
                color: themeColor
                radius:  8
                samples: 16
            }
            Text {
                anchors.right: deleteBtn.left
                anchors.rightMargin: 10
                font.family: "SimHei"
                font.pixelSize: 20
                color: "#474747"
                text:textTwo
                anchors.verticalCenter: parent.verticalCenter
            }
//            HLK_ImageButton{
//                id:deleteBtn
//                anchors.right:parent.right
//                anchors.rightMargin: 20
//                imagePath: "qrc:/images/images/zhlz.png"
//                imagePressePath:"qrc:/images/images/zhlz.png"
//                button_width:20
//                button_height:20
//                anchors.verticalCenter: parent.verticalCenter
//            }
            Image{
                id:deleteBtn
                anchors.right:parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/images/zhlz.png"
            }
        }
    }
}
