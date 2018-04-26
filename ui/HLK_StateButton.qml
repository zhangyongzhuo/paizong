import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4

//自定义复选框
CheckBox {
    property string normal_image
    property string checked_image
    property string button_sound: "qrc:/sounds/sounds/about.wav"

    style: CheckBoxStyle{
        background: Image{
            source: checked? checked_image : normal_image
        }

        label: Text{
            text: control.text
            font.pixelSize: 28
            font.family: "微软雅黑"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        indicator: null
    }

//    Audio{
//        id: sound
//        source: button_sound
//    }

//    onClicked: {
//        sound.play()
//    }
}
