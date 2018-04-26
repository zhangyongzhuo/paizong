import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

//普通贴图按钮
Button {
    property string normal_image
    property string pressed_image
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool   mute: false
    property string button_text_color: "white"

    style: ButtonStyle{
        background: Image{
            source: pressed? pressed_image : normal_image
        }

        label: Text{
            text: control.text //特别注意引用父类属性
            font.pixelSize: 28
            font.family: "微软雅黑"
            color: button_text_color
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
