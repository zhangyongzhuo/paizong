import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    width: 100
    height: 100
    property string imgPath: ""
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#FFFFFF"
            border.width: 1
            border.color: pressed ? themeColor : "#EEEEEE"
            layer.enabled: pressed ? true : false
            layer.effect: DropShadow {
                transparentBorder: true
                color: themeColor
                radius:  8
                samples: 16
            }
            Image{
                anchors.centerIn: parent
                source: imgPath
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
//错误：DirectShowPlayerService::doRender: Unresolved error code 80004004
}


