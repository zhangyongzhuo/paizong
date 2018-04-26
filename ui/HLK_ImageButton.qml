import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4

Button {
    id: btn
    property string imagePath: ""
    property string imagePressePath: ""
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property int button_width:120
    property int button_height:120
    width: button_width
    height: button_height
    style: ButtonStyle{
        background: Rectangle{
            color: "#00000000"
            Image{
                anchors.fill: parent
                anchors.centerIn: parent
                source: btn.pressed ? imagePath : imagePressePath
               // source: imagePath
            }
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
