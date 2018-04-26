import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
RadioButton {
    id: btn
    property string normal_image
    property string checked_image
    property string button_sound: "qrc:/sounds/sounds/about.wav"

    style: RadioButtonStyle{
        background: Rectangle{
            color: checked ? JSL.themeColor() : "#00000000"
            Image{
                x: 65
                y: 16
                source: checked ? checked_image : normal_image
            }
        }
        label: Text{
            x: text.length==4 ? 40 : 60
            y: 26
            text: control.text
            font.pixelSize: 22
            font.family: "SimHei"
            color: checked ? "#FFFFFF" : "#474747"
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
