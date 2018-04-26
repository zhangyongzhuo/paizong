import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button {
    //property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool   mute: false
    property string button_text:""
    property string themeColor: JSL.themeColor()

    width: 100
    height: 40
    layer.enabled: pressed ? true : false
    layer.effect: DropShadow {
        transparentBorder: true
        color: themeColor
        samples: 16
    }

    style: ButtonStyle{
        background: Rectangle{
            color: "#FFFFFF"
            border.width: 1
            radius: 5
            border.color: themeColor
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 20
                font.family: "黑体"
                color: themeColor
                text: button_text
            }
        }
    }
    Timer{
        id: timeout
        interval: 500
        repeat: false
        onTriggered: {
           enabled = true
        }
    }
    onClicked: {
        timeout.start()
        enabled = false
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


