import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Button {
    property string normal_image: ""
    property string pressed_image: ""
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool   mute: false
    property string button_text_color: "#FFFFFF"
    property string button_text:""
    property int buttonHeight:40
    width: 100
    height: buttonHeight

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

    style: ButtonStyle{
        background: Rectangle{
            radius: 5
            color: control.pressed ? "#0191AA" : JSL.themeColor()
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 20
                font.family: "SimHei"
                color: button_text_color
                text: button_text
            }
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


