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
    height: 200
    width: 40
    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#FFFFFF"
            border.width: 1//pressed ? 1 : 0
            border.color: pressed ? themeColor : "#EDEDED"
            layer.enabled: pressed ? true : false
            layer.effect: DropShadow {
                transparentBorder: true
                color: themeColor
                radius:  8
                samples: 16
            }
            Image{
                fillMode: Image.Pad
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.horizontalCenter: parent.horizontalCenter
                source: checked ? checked_image : normal_image
            }
        }
        label: HLK_NormalText{
            text: btnText
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -20
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            color: "#000000"
            font.family: "SimHei"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

//    Audio{
//        id: sound
//        source: button_sound
//    }

//    onClicked: {
//        if(!mute){
//            sound.play()
//        }
//    }
}
