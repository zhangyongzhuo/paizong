import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4

Button {
    id: btn
    property string normal_path: ""
    property string checked_path: ""
    property string button_sound: "qrc:/sounds/sounds/about.wav"

    style: ButtonStyle{
        background: Image{
            anchors.fill: parent
            anchors.centerIn: parent
            source: pressed ? checked_path : normal_path
        }
    }

//    Audio{
//        id: sound
//        source: button_sound
//    }

//    onClicked: {
//        sound.play()
//    }
}
